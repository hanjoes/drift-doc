// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Drift",
    targets: [
        Target(name: "DriftTransform", dependencies: ["DriftRuntime"]),
        Target(name: "DriftRuntime", dependencies: [])
    ],
    dependencies: [
        .Package(url: "Antlr4", majorVersion: 4),
        .Package(url: "https://github.com/hanjoes/git.git", Version(1, 0, 2)),
        .Package(url: "https://github.com/hanjoes/BitSet.git", Version(1, 0, 3))
    ]
)
