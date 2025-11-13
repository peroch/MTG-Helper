// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreUI",
            dependencies: [],
            path: "Sources/CoreUI"
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: ["CoreUI"],
            path: "Tests/CoreUITests"
        )
    ]
)
