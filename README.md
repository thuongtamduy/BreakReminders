# BreakReminders 👁

A premium, minimalist macOS Menu Bar application designed to remind you to take breaks and protect your eyes following the 20-20-20 rule.

## 🌟 Features

### 1. Premium & Aesthetic Design
- **Beautiful Popover Panel**: A sleek UI dropping down from the menu bar with real-time countdown and visual progress bar.
- **Zen Break Screen**: Full-screen overlay with a smoothly moving gradient background (Teal - Blue - Purple) and frosted glass effect.

### 2. Smart Automation
- **Meeting Detection**: Automatically pauses the countdown when you are in a meeting (Zoom, Microsoft Teams, Webex, Skype, Slack) so it won't disturb your important calls.
- **Idle Presence Detection**: If you leave your desk (no mouse/keyboard input for 5 minutes), the app auto-resets the timer when you return.

### 3. Health & Wellness
- **Interactive Eye Exercises**: During the break, a glowing dot moves in an infinity loop (♾️) for you to follow with your eyes, helping to relax eye muscles.
- **Relaxing Audio**: Peaceful bell sounds when a break starts and ends.

### 4. High Customization
- Choose between various work durations (from 30s for testing up to 120 minutes).
- Choose break durations (from 10s up to 10 minutes).
- Toggle sound effects and visual animations on/off.
- Daily statistics to see how many cycles you completed today.

## 🚀 How to Run

### From Source
Requires macOS 13.0+ and Swift 5.7+.

```bash
git clone https://github.com/thuongtamduy/BreakReminders.git
cd BreakReminders
swift run
```

### Build the App Bundle
To build a standalone `.app` that you can drag to your Applications folder:

```bash
swift build -c release
mkdir -p BreakReminders.app/Contents/MacOS BreakReminders.app/Contents/Resources
cp .build/release/BreakReminders BreakReminders.app/Contents/MacOS/
cp AppIcon.icns BreakReminders.app/Contents/Resources/
```

## 📄 License
This project is open-source. Feel free to modify and use it!
