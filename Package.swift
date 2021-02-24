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
            targets: ["EMMAInAppPlugin-Prism"]),
    ],
    targets: [
        .target(
            name: "EMMAInAppPlugin-Prism",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        /*.binaryTarget(
            name: "EMMA_iOS",
            path: "EMMA_iOS.xcframework")*/
    ]
)
