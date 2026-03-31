// swift-tools-version: 6.0.3

import PackageDescription

let package = Package(
    name: "FoF_draft",
    products: [
        .library(
            name: "FoFLib",
            targets: ["FoFLib"]
        )
    ],
    targets: [
        .target(
            name: "FoFLib",
            dependencies: [],
            path: "Sources/FoFLib",
            resources: [.process("Resources")]
        ),
        .executableTarget(
            name: "FoFExecutable",
            dependencies: ["FoFLib"]
        ),
        .testTarget(
            name: "FoFLibTests",
            dependencies: ["FoFLib"],
            path: "Tests/FoFLibTest",
            resources: [.process("Resources")]
        ),
    ]
)
