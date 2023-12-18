#!/bin/bash

set -e # Any subsequent(*) commands which fail will cause the shell script to exit immediately

PROJECT_NAME=TestProject

# Clean up.
rm -rf $PROJECT_NAME

# iOS
mkdir -p $PROJECT_NAME && cd $PROJECT_NAME

# Create a new Xcode project.
swift package init
swift package generate-xcodeproj

# Create a Podfile with our pod as dependency.
echo "
target '$PROJECT_NAME' do
  platform :ios, '12.0'
  use_frameworks!
  pod 'AEPRulesEngine', :path => '../'
end
" >>Podfile

# Install the pods.
pod install

# Archive for generic iOS device
echo '############# Archive for generic iOS device ###############'
xcodebuild archive -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=iOS'

# Build for generic iOS device
echo '############# Build for generic iOS device ###############'
xcodebuild clean build -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=iOS'

# Archive for x86_64 simulator
echo '############# Archive for simulator ###############'
xcodebuild archive -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=iOS Simulator'

# Build for x86_64 simulator
echo '############# Build for simulator ###############'
xcodebuild clean build -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=iOS Simulator'

# tvOS
cd ../
rm -rf $PROJECT_NAME
mkdir -p $PROJECT_NAME && cd $PROJECT_NAME
# Create a new Xcode project.
swift package init
swift package generate-xcodeproj

# Create a Podfile with our pod as dependency.
echo "
target '$PROJECT_NAME' do
  platform :tvos, '12.0'
  use_frameworks!
  pod 'AEPRulesEngine', :path => '../'
end
" >>Podfile

# Install the pods.
pod install
# Archive for generic tvOS device
echo '############# Archive for generic tvOS device ###############'
xcodebuild archive -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=tvOS'

# Build for generic tvOS device
echo '############# Build for generic tvOS device ###############'
xcodebuild build -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=tvOS'

# Archive for generic tvOS device
echo '############# Archive for generic tvOS device ###############'
xcodebuild archive -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=tvOS Simulator'

# Build for generic tvOS simulator
echo '############# Build for x86_64 simulator ###############'
xcodebuild build -scheme TestProject-Package -workspace TestProject.xcworkspace -destination 'generic/platform=tvOS Simulator'

# Clean up.
cd ../
rm -rf $PROJECT_NAME
