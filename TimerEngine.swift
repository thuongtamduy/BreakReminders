import Foundation
import Combine
import AppKit
import SwiftUI
import CoreGraphics

class TimerEngine: ObservableObject {
    @AppStorage("workDuration") var workDuration: Int = 30
    @AppStorage("breakDuration") var breakDuration: Int = 10
    @AppStorage("enableSound") var enableSound: Bool = true
    
    // Analytics
    @AppStorage("completedBreaksToday") var completedBreaksToday: Int = 0
    @AppStorage("lastCompletedDate") var lastCompletedDate: String = ""
    
    @Published var timeRemaining: Int = 30
    @Published var breakRemaining: Int = 10
    @Published var isBreakActive: Bool = false
    @Published var isPaused: Bool = false
    @Published var isMeetingDetected: Bool = false
    @Published var isDropdownOpen: Bool = false
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var tickCounter: Int = 0
    
    // OPTIMIZATION: Reuse DateFormatter to save resources
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init() {
        self.timeRemaining = workDuration
        self.breakRemaining = breakDuration
        
        checkDateReset()
        startWorkTimer()
        setupSystemNotifications()
    }
    
    func checkDateReset() {
        let today = dateFormatter.string(from: Date())
        
        if today != lastCompletedDate {
            completedBreaksToday = 0
            lastCompletedDate = today
        }
    }
    
    func startWorkTimer() {
        timer?.invalidate()
        timeRemaining = workDuration
        isBreakActive = false
        tickCounter = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            self.tickCounter += 1
            
            // OPTIMIZATION: Check for running meetings every 5 seconds AND run it on a background thread
            if self.tickCounter % 5 == 0 || self.isMeetingDetected {
                DispatchQueue.global(qos: .background).async {
                    let meetingRunning = self.isMeetingRunning()
                    DispatchQueue.main.async {
                        self.isMeetingDetected = meetingRunning
                    }
                }
                
                if self.isMeetingDetected {
                    return // Stay paused
                }
            }
            
            // Smart Feature: Detect Idle (Presence)
            if !self.isDropdownOpen {
                let idleTime = CGEventSource.secondsSinceLastEventType(.combinedSessionState, eventType: .null)
                if idleTime > 5 * 60 { // 5 minutes
                    if self.timeRemaining != self.workDuration {
                        DispatchQueue.main.async {
                            self.timeRemaining = self.workDuration
                        }
                    }
                    return
                }
            }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.startBreak()
            }
        }
    }
    
    func startBreak() {
        timer?.invalidate()
        breakRemaining = breakDuration
        isBreakActive = true
        
        // FIX: Use absolute path for system sounds to guarantee playback
        if enableSound {
            NSSound(contentsOfFile: "/System/Library/Sounds/Glass.aiff", byReference: true)?.play()
        }
        
        DispatchQueue.main.async {
            RestWindowManager.shared.show(content: AnyView(BreakView().environmentObject(self)))
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.breakRemaining > 0 {
                self.breakRemaining -= 1
            } else {
                self.endBreak()
            }
        }
    }
    
    func endBreak() {
        timer?.invalidate()
        isBreakActive = false
        
        // FIX: Use absolute path for system sounds to guarantee playback
        if enableSound {
            NSSound(contentsOfFile: "/System/Library/Sounds/Hero.aiff", byReference: true)?.play()
        }
        
        checkDateReset()
        completedBreaksToday += 1
        
        DispatchQueue.main.async {
            RestWindowManager.shared.hide()
        }
        
        startWorkTimer()
    }
    
    func skipBreak() {
        if isBreakActive {
            endBreak()
        } else {
            startWorkTimer()
        }
    }
    
    private func isMeetingRunning() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        let meetingAppNames = ["Zoom", "Microsoft Teams", "Webex", "Skype", "slack"]
        for app in runningApps {
            if let name = app.localizedName, meetingAppNames.contains(where: { name.localizedCaseInsensitiveContains($0) }) {
                return true
            }
        }
        return false
    }
    
    private func setupSystemNotifications() {
        let center = NSWorkspace.shared.notificationCenter
        
        center.publisher(for: Notification.Name("com.apple.screensaver.didstart"))
            .sink { [weak self] _ in
                self?.pauseAndReset()
            }
            .store(in: &cancellables)
            
        center.publisher(for: NSWorkspace.willSleepNotification)
            .sink { [weak self] _ in
                self?.pauseAndReset()
            }
            .store(in: &cancellables)
            
        center.publisher(for: Notification.Name("com.apple.screensaver.didstop"))
            .sink { [weak self] _ in
                self?.resume()
            }
            .store(in: &cancellables)
            
        center.publisher(for: NSWorkspace.didWakeNotification)
            .sink { [weak self] _ in
                self?.resume()
            }
            .store(in: &cancellables)
    }
    
    func pauseAndReset() {
        timer?.invalidate()
        timeRemaining = workDuration
        isBreakActive = false
        isPaused = true
        
        DispatchQueue.main.async {
            RestWindowManager.shared.hide()
        }
    }
    
    func resume() {
        isPaused = false
        startWorkTimer()
    }
}
