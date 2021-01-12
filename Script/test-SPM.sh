#!/bin/bash

set -e # Any subsequent(*) commands which fail will cause the shell script to exit immediately

PROJECT_NAME=TestProject

# Clean up.
rm -rf $PROJECT_NAME

mkdir -p $PROJECT_NAME && cd $PROJECT_NAME

# Create the package.
swift package init

# Create the Package.swift.
echo "// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: \"TestProject\",
    defaultLocalization: \"en-US\",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: \"TestProject\",
            targets: [\"TestProject\"]
        )
    ],
    dependencies: [
        .package(name: \"AEPRulesEngine\", path: \"../\"),
    ],
    targets: [
        .target(
            name: \"TestProject\",
            dependencies: [
                .product(name: \"AEPRulesEngine\", package: \"AEPRulesEngine\")])
    ]
)
" >Package.swift

swift package update

# Archive for generic iOS device
echo '############# Archive for generic iOS device ###############'
xcodebuild archive -scheme TestProject -destination 'generic/platform=iOS'

# Build for generic iOS device
echo '############# Build for generic iOS device ###############'
xcodebuild build -scheme TestProject -destination 'generic/platform=iOS'

# Build for i386 simulator
echo '############# Build for i386 simulator ###############'
xcodebuild build -scheme TestProject -destination 'generic/platform=iOS Simulator' ARCHS=i386

# Build for x86_64 simulator
echo '############# Build for x86_64 simulator ###############'
xcodebuild build -scheme TestProject -destination 'generic/platform=iOS Simulator' ARCHS=x86_64

# Clean up.
cd ../
rm -rf $PROJECT_NAME
