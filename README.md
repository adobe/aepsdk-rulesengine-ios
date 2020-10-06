# AEPRulesEngine

## BETA

AEPRulesEngine is currently in beta. Use of this code is by invitation only and not otherwise supported by Adobe. Please contact your Adobe Customer Success Manager to learn more.

## Overview

A simple, generic, extensible Rules Engine in Swift.

## Installation

### Swift Package Manager

To add the AEPRulesEngine Package to your application, from the Xcode menu select:

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


### Initialize Rules Engine

To create a `RuleEngine` instance, first define an `Evaluator` and then use it as the parameter for `RuleEngine`.
```
let evaluator = ConditionEvaluator(options: .caseInsensitive)
let rulesEngine = RulesEngine(evaluator: evaluator)
```

### Define Rules

Any thing that conforms to the `Rule` protocol can be used as rule. 
``` Swift
public class MobileRule: Rule {
    init(condition: Evaluable) { self.condition = condition }
    var condition: Evaluable
}
let condition = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
let rule = MobileRule(condition: condition)
rulesEngine.addRules(rules: [rule])
```
However, a rule like this doesn't make much sense, without the ability to dynamically fetch a value it will always be true or false.

```
let mustache = Operand<String>(mustache: "{{company}}")
let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "adobe")
let rule = MobileRule(condition: condition)
rulesEngine.addRules(rules: [rule])
```

### Evaluate data

Use the method `evaluate` to run rule engine on the input data that is `Traversable`.

```
let matchedRules = rulesEngine.evaluate(data: ["company":"adobe"])
```


## Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

## Licensing

This project is licensed under the Apache V2 License. See [LICENSE](LICENSE) for more information.
