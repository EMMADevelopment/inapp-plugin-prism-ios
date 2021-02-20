// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EMMAPluginPrism",
    platforms: [
       .iOS(.v9)
     ],
    products: [
        .library(
            name: "EMMAPluginPrism",
            targets: ["EMMAPluginPrism"]),
    ],
    targets: [
        .target(
            name: "EMMAPluginPrism",
            path: "Sources"),
        //.binaryTarget(
        //    name: "EMMA_iOS",
        //    path: "EMMA_iOS.xcframework")
    ]
)
