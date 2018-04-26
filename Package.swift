// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "project5",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2.7"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/twostraws/SwiftGD.git", .upToNextMinor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/multipart.git", from: "3.0.1"),
        ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "SwiftGD", "Multipart"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

