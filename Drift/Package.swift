// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Drift",
    targets: [
        Target(name: "DriftTransform", dependencies: ["DriftRuntime"]),
        Target(name: "DriftRuntime", dependencies: [])
    ],
    dependencies: [
        .Package(url: "/private/tmp/Antlr4-tmp-1495430765", majorVersion: 4)
    ]
)
