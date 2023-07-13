// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DigiModule",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "DigiModule",
            targets: ["DigiModule"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DigiModule",
            dependencies: [],
            resources: [
                .process("digi_page.html")
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
