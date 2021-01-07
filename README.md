# AEPRulesEngine

<!--
on [![Cocoapods](https://img.shields.io/cocoapods/v/AEPRulesEngine.svg?color=orange&label=AEPCore&logo=apple&logoColor=white)](https://cocoapods.org/pods/AEPRulesEngine)
-->
[![SPM](https://img.shields.io/badge/SPM-Supported-orange.svg?logo=apple&logoColor=white)](https://swift.org/package-manager/)
[![CI](https://github.com/adobe/aepsdk-rulesengine-ios/workflows/CI/badge.svg)](https://github.com/adobe/aepsdk-rulesengine-ios/actions)
[![Code Coverage](https://img.shields.io/codecov/c/github/adobe/aepsdk-rulesengine-ios/main.svg?logo=codecov)](https://codecov.io/gh/adobe/aepsdk-rulesengine-ios/branch/main)
[![GitHub](https://img.shields.io/github/license/adobe/aepsdk-rulesengine-ios)](https://github.com/adobe/aepsdk-rulesengine-ios/blob/main/LICENSE)

## BETA

AEPRulesEngine is currently in beta. Use of this code is by invitation only and not otherwise supported by Adobe. Please contact your Adobe Customer Success Manager to learn more.

## Overview

A simple, generic, extensible Rules Engine in Swift.

## Requirements
- Xcode 11.0 (or newer)
- Swift 5.1 (or newer)

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'AEPRulesEngine', :git => 'https://github.com/adobe/aepsdk-rulesengine-ios.git', :branch => 'main'    
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

### Swift Package Manager

To add the AEPRulesEngine package to your application, from the Xcode menu select:

`File > Swift Packages > Add Package Dependency...`

Enter the URL for the AEPRulesEngine package repository: `https://github.com/adobe/aepsdk-rulesengine-ios.git`.

When prompted, make sure you change the branch to `main`.

There are three options for selecting your dependencies as identified by the *suffix* of the library name:

- "Dynamic" - the library will be linked dynamically
- "Static" - the library will be linked statically
- *(none)* - (default) SPM will determine whether the library will be linked dynamically or statically

Alternatively, if your project has a `Package.swift` file, you can add AEPRulesEngine directly to your dependencies:

```
dependencies: [
    .package(url: "https://github.com/adobe/aepsdk-rulesengine-ios.git", .branch("main"))
]
```

## Usage

### Initialize the Rules Engine

To create a `RulesEngine` instance, define an `Evaluator` and pass it to the `RulesEngine`'s initializer:
```
let evaluator = ConditionEvaluator(options: .caseInsensitive)
let rulesEngine = RulesEngine(evaluator: evaluator)
```

### Define Rules

Anything that conforms to the `Rule` protocol can be used as rule:
``` Swift
public class MobileRule: Rule {
    init(condition: Evaluable) { self.condition = condition }
    var condition: Evaluable
}
let condition = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
let rule = MobileRule(condition: condition)
rulesEngine.addRules(rules: [rule])
```
A rule without the flexibility to dynamically fetch a value will always evaluate to true or false.  To fetch the value for a rule at runtime, use a Mustache Token:

``` Swift
let mustache = Operand<String>(mustache: "{{company}}")
let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "adobe")
let rule = MobileRule(condition: condition)
rulesEngine.addRules(rules: [rule])
```

### Evaluate data

Use the `evaluate` method to process `Traversable` data through the `RulesEngine`:

```
let matchedRules = rulesEngine.evaluate(data: ["company":"adobe"])
```


## Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

## Licensing

This project is licensed under the Apache V2 License. See [LICENSE](LICENSE) for more information.
