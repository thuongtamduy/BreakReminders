import AppKit
import SwiftUI

class RestWindow: NSWindow {
    init(contentRect: NSRect, contentView: NSView) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        self.level = .screenSaver
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        self.ignoresMouseEvents = false
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.contentView = contentView
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}

class RestWindowManager {
    static let shared = RestWindowManager()
    
    private var windows: [RestWindow] = []
    
    private init() {}
    
    func show(content: AnyView) {
        hide()
        
        for screen in NSScreen.screens {
            let hostingView = NSHostingView(rootView: content)
            let window = RestWindow(contentRect: screen.frame, contentView: hostingView)
            window.makeKeyAndOrderFront(nil)
            windows.append(window)
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hide() {
        for window in windows {
            window.orderOut(nil)
        }
        windows.removeAll()
    }
}
