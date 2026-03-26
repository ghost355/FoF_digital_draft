// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "FoF_draft",
    products: [
        .library(
            name: "FoFLib",
            targets: ["FoFLib"]
        ),
    ],
    targets: [
        .target(
            name: "FoFLib"
        ),
        .executableTarget(
            name: "FoFExecutable",
            dependencies: ["FoFLib"]
        ),
        .testTarget(
            name: "FoFLibTests",
            dependencies: ["FoFLib"]
        ),
    ]
)
