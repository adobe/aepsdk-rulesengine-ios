// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "TestProject",
    defaultLocalization: "en-US",
    platforms: [
        .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "TestProject",
            targets: ["TestProject"]
        )
    ],
    dependencies: [
        .package(name: "AEPRulesEngine", path: "../"),
    ],
    targets: [
        .target(
            name: "TestProject",
            dependencies: [
                .product(name: "AEPRulesEngine", package: "AEPRulesEngine")])
    ]
)

