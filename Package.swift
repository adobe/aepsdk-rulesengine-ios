// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AEPRulesEngine",
    products: [
        .library(name: "AEPRulesEngine", targets: ["AEPRulesEngine"]),
        .library(name: "AEPRulesEngineDynamic", type: .dynamic, targets: ["AEPRulesEngine"]),
        .library(name: "AEPRulesEngineStatic", type: .static, targets: ["AEPRulesEngine"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1")
    ],
    targets: [
        .target(name: "AEPRulesEngine", dependencies: []),
        .testTarget(name: "AEPRulesEngineTests", dependencies: ["AEPRulesEngine"]),
    ]
)
