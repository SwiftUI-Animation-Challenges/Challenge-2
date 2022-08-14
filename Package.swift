// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Challenge-2",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .library(name: "Challenge-2", targets: ["Challenge-2"]),
    ],
    targets: [
        .target(name: "Challenge-2"),
    ]
)
