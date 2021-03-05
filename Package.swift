// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "EMMAInAppPlugin-Prism",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "EMMAInAppPlugin-Prism",
            targets: ["EMMAInAppPlugin-Prism"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/EMMADevelopment/eMMa-iOS-SDK.git", from: Version(4, 9, 0, prereleaseIdentifiers: ["beta"])),
    ],
    targets: [
        .target(
            name: "EMMAInAppPlugin-Prism",
            path: "Sources",
            exclude: [
                "Static", "PluginPrismDemo"
            ],
            resources: [
                .copy("Resources")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
