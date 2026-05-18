# ⏳ BreakReminders

A minimalist and premium macOS productivity and health application built with **Swift 5** and **SwiftUI**. The app enforces the **20-20-20 eye-rest rule** (Every 20 minutes, take a 20-second break looking at something 20 feet away) to protect your eyes from strain.

![App Icon](app_icon.iconset/icon_512x512.png) *(If you have the image in the root or another path, update this link)*

---

## ✨ Features

- **Menu Bar Resident:** Runs silently in the background on your Menu Bar, showing the remaining time.
- **Fullscreen Overlay:** When the timer hits zero, a beautiful, borderless window covers all screens with a Hud Window blur effect, forcing you to take a break.
- **Zen Countdown View:** Features a smooth circular progress ring and gentle text reminders.
- **Smart Timer:** Automatically pauses and resets when your Mac goes to sleep or the screensaver starts, preventing false break triggers.
- **Multi-Monitor Support:** The overlay appears on all connected screens.

---

## 🛠 Tech Stack

- **Language:** Swift 5
- **Frameworks:** SwiftUI, AppKit
- **Platforms:** macOS 13.0+

---

## 🚀 How to Run

### Method 1: Using the `.app` Bundle (Recommended)
We have already created a pre-built application bundle for you:
1. Open the project folder in Finder.
2. Locate `BreakReminders.app`.
3. Drag it to your `Applications` folder.
4. Double-click to run! 
   *(Note: Since it is not signed, you may need to right-click and choose **Open** the first time).*

### Method 2: Using Swift Package Manager
If you want to run it from the source code directly:
```bash
swift run
```
To build a production binary:
```bash
swift build -c release
```

---

## 📂 Project Structure

- `BreakRemindersApp.swift`: Main entry point setting up the `MenuBarExtra`.
- `TimerEngine.swift`: The observable object managing the timer logic and system notifications.
- `BreakView.swift`: The SwiftUI view for the overlay screen with the circular countdown.
- `RestWindow.swift`: Custom AppKit `NSWindow` implementation for multi-monitor blocking.
- `VisualEffectView.swift`: Bridge for `NSVisualEffectView` to bring native glassmorphism to SwiftUI.

---

## 🎨 Customization
You can adjust the work and break durations in `TimerEngine.swift`:
- `workDuration`: Set to `20 * 60` for 20 minutes.
- `breakDuration`: Set to `20` for 20 seconds.

---
*Stay healthy, keep your eyes rested!*
