// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AEPRulesEngine",
    platforms: [.iOS("15.0"), .tvOS("15.0")],
    products: [
        .library(name: "AEPRulesEngine", targets: ["AEPRulesEngine"]),
    ],
    targets: [
        .target(name: "AEPRulesEngine", dependencies: []),
        .testTarget(name: "AEPRulesEngineTests", dependencies: ["AEPRulesEngine"]),
    ]
)
