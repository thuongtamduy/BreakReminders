import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage("workDuration") var workDuration: Int = 30
    @AppStorage("breakDuration") var breakDuration: Int = 10
    @AppStorage("enableSound") var enableSound: Bool = true
    @AppStorage("enableEffects") var enableEffects: Bool = true
    @AppStorage("enableEyeExercise") var enableEyeExercise: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("BreakReminders Settings")
                .font(.headline)
            
            Form {
                Section(header: Text("Timers").font(.subheadline).foregroundColor(.secondary)) {
                    Picker("Work Duration:", selection: $workDuration) {
                        Text("30 seconds").tag(30)
                        Text("1 minute").tag(60)
                        Text("10 minutes").tag(10 * 60)
                        Text("20 minutes").tag(20 * 60)
                        Text("30 minutes").tag(30 * 60)
                        Text("50 minutes").tag(50 * 60)
                        Text("60 minutes").tag(60 * 60)
                        Text("120 minutes").tag(120 * 60)
                    }
                    
                    Picker("Break Duration:", selection: $breakDuration) {
                        Text("10 seconds").tag(10)
                        Text("20 seconds").tag(20)
                        Text("30 seconds").tag(30)
                        Text("1 minute").tag(60)
                        Text("5 minutes").tag(5 * 60)
                        Text("10 minutes").tag(10 * 60)
                    }
                }
                
                Divider()
                
                Section(header: Text("Zen Experience").font(.subheadline).foregroundColor(.secondary)) {
                    Toggle("Enable Sound Effects", isOn: $enableSound)
                    Toggle("Enable Animated Background", isOn: $enableEffects)
                    Toggle("Enable Eye Exercise (Moving Dot)", isOn: $enableEyeExercise)
                }
            }
            .pickerStyle(.menu)
            
            Text("Tip: Changes will take effect in the next cycle.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(30)
        .frame(width: 380)
    }
}

class SettingsWindowManager {
    static let shared = SettingsWindowManager()
    private var window: NSWindow?
    
    func show() {
        if window == nil {
            let contentView = SettingsView()
            let hostingView = NSHostingView(rootView: contentView)
            
            let win = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 380, height: 320),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            win.center()
            win.title = "Settings"
            win.contentView = hostingView
            win.isReleasedWhenClosed = false
            
            self.window = win
        }
        
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
