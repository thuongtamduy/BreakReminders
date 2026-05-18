// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BreakReminders",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "BreakReminders", targets: ["BreakReminders"])
    ],
    targets: [
        .executableTarget(
            name: "BreakReminders",
            path: "."
        )
    ]
)
