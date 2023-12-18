// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AEPRulesEngine",
    products: [
        .library(name: "AEPRulesEngine", targets: ["AEPRulesEngine"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "AEPRulesEngine", dependencies: []),
        .testTarget(name: "AEPRulesEngineTests", dependencies: ["AEPRulesEngine"]),
    ]
)
