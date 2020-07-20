// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRulesEngine",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftRulesEngine",
            targets: ["SwiftRulesEngine"]),
//        
//        .library(
//            name: "RulesDSL",
//            targets: ["RulesDSL"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftRulesEngine",
            dependencies: []),
        .testTarget(
            name: "SwiftRulesEngineTests",
            dependencies: ["SwiftRulesEngine"]),
//        .target(
//            name: "RulesDSL",
//            dependencies: []),
//        .testTarget(
//            name: "RulesDSLTests",
//            dependencies: ["RulesEngine", "RulesDSL"])
        
    ]
)
