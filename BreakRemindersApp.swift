import SwiftUI

@main
struct BreakRemindersApp: App {
    @StateObject private var timerEngine = TimerEngine()
    
    init() {
        // Hides the dock icon so the app runs purely in the menu bar
        NSApplication.shared.setActivationPolicy(.accessory)
    }
    
    var body: some Scene {
        MenuBarExtra {
            DropdownView()
                .environmentObject(timerEngine)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "eye.fill")
                if timerEngine.isPaused {
                    Text("Paused")
                } else if timerEngine.isMeetingDetected {
                    Text("Meeting")
                } else if timerEngine.isBreakActive {
                    Text("Break!")
                } else {
                    Text("\(timerEngine.timeRemaining / 60)m")
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}

struct DropdownView: View {
    @EnvironmentObject var timerEngine: TimerEngine
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("BreakReminders")
                    .font(.headline)
                Spacer()
                
                Button(action: {
                    SettingsWindowManager.shared.show()
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Image(systemName: "power")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            
            Divider()
            
            if timerEngine.isPaused {
                VStack(spacing: 5) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("Timer Paused")
                        .font(.headline)
                }
                .frame(height: 100)
            } else if timerEngine.isMeetingDetected {
                VStack(spacing: 5) {
                    Image(systemName: "video.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text("Meeting Detected")
                        .font(.headline)
                    Text("Paused to not disturb you.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 100)
            } else {
                VStack(spacing: 5) {
                    Text("Next break in:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "%02d:%02d", timerEngine.timeRemaining / 60, timerEngine.timeRemaining % 60))
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    // Small progress bar
                    ProgressView(value: Double(timerEngine.timeRemaining), total: Double(timerEngine.workDuration))
                        .progressViewStyle(.linear)
                        .tint(.teal)
                }
                .frame(height: 100)
            }
            
            Divider()
            
            HStack {
                Label("\(timerEngine.completedBreaksToday) completed", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Skip") {
                    timerEngine.skipBreak()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(timerEngine.isBreakActive)
            }
        }
        .padding()
        .frame(width: 260)
        .onAppear {
            timerEngine.isDropdownOpen = true
        }
        .onDisappear {
            timerEngine.isDropdownOpen = false
        }
    }
}
