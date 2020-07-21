/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation
import SwiftRulesEngine

struct LaunchRuleRoot: Codable {
    var version: Int
    var rules: [LaunchRule]

    func convert() -> [AEPRule] {
        var result = [AEPRule]()
        for launchRule in rules {
            if let conditionExpression = launchRule.condition.convert() {
                let rule = AEPRule(condition: conditionExpression)
                result.append(rule)
            }
        }
        return result
    }
}

struct LaunchRule: Codable {
    var condition: Condition
    var consequences: [Consequence]
}

enum ConditionType: String, Codable {
    case group
    case matcher
}

class Condition: Codable {
    var type: ConditionType
    var definition: Definition
    func convert() -> Evaluable? {
        switch type {
        case .group:
            if let operationStr = definition.logic, let subConditions = definition.conditions {
                var operands = [Evaluable]()
                for subCondition in subConditions {
                    if let operand = subCondition.convert() {
                        operands.append(operand)
                    }
                }
                return operands.count == 0 ? nil : LogicalExpression(operationName: operationStr, operands: operands)
            }
            return nil
        case .matcher:
            if let key = definition.key, let matcher = definition.matcher, let values = definition.values {
                if values.count == 1 {
                    return convert(key: key, matcher: matcher, anyCodable: values[0])
                }
                if values.count > 1 {
                    var operands = [Evaluable]()
                    for value in values {
                        if let operand = convert(key: key, matcher: matcher, anyCodable: value) {
                            operands.append(operand)
                        }
                    }
                    return operands.count == 0 ? nil : LogicalExpression(operationName: "or", operands: operands)
                }
            }
            return nil
        }
    }

    func convert(key: String, matcher: String, anyCodable: AnyCodable) -> Evaluable? {
        if let value = anyCodable.value {
            switch value {
            case is String:
                if let stringValue = anyCodable.stringValue {
                    return ComparisonExpression<MustacheToken, String>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(stringLiteral: stringValue))
                }
                return nil
            //            case is Double:
            //                return ComparisonExpression<Any, Double>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(: anyCodable.doubleValue))
            case is Int:
                if let intValue = anyCodable.intValue {
                    return ComparisonExpression<MustacheToken, Int>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(integerLiteral: intValue))
                }
                return nil
            case is Float:
                if let floadValue = anyCodable.floatValue {
                    return ComparisonExpression<MustacheToken, Double>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(floatLiteral: Double(floadValue)))
                }
                return nil
            //            case is Int64:
            //                return ComparisonExpression(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(anyCodable.longValue))
            default:
                return nil
            }
        }
        return nil
    }
}

struct Definition: Codable {
    let logic: String?
    let conditions: [Condition]?
    let key: String?
    let matcher: String?
    let values: [AnyCodable]?
}

enum ConsequenceType: String, Codable {
    case url
    case add
    case mod
}

struct Detail: Codable {
    let url: String?
}

struct Consequence: Codable {
    let id: String
    let type: ConsequenceType
    let detail: Detail
}

class LaunchRulesParser {
    static func parse(_ json: String) -> LaunchRuleRoot? {
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(LaunchRuleRoot.self, from: json.data(using: .utf8)!)
        } catch {
            print("caught: \(error)")
            return nil
        }
    }
}

public class AEPRule: Rule {
    public let condition: Evaluable
    fileprivate init(condition: Evaluable) {
        self.condition = condition
    }

    public static func generateRules(json: String) -> [AEPRule] {
        if let launchRulesRoot = LaunchRulesParser.parse(json) {
            return launchRulesRoot.convert()
        } else {
            return []
        }
    }

//
//    private static func convert(_ root: LaunchRuleRoot) -> [AEPRule] {
//        var result = [AEPRule]()
//        for launchRule in root.rules {
//            if let conditionExpression = convert(launchRule.condition) {
//                let rule = AEPRule(condition: conditionExpression)
//                result.append(rule)
//            }
//        }
//        return result
//    }
//
//    private static func convert(_ condition: Condition) -> Evaluable? {
//        switch condition.type {
//        case .group:
//            if let operationStr = condition.definition.logic, let subConditions = condition.definition.conditions {
//                var operands = [Evaluable]()
//                for subCondition in subConditions {
//                    if let operand = convert(subCondition) {
//                        operands.append(operand)
//                    }
//                }
//                return operands.count == 0 ? nil : LogicalExpression(operationName: operationStr, operands: operands)
//            }
//            return nil
//        case .matcher:
//            if let key = condition.definition.key, let matcher = condition.definition.matcher, let values = condition.definition.values {
//                if values.count == 1 {
//                    return convert(key: key, matcher: matcher, anyCodable: values[0])
//                }
//                if values.count > 1 {
//                    var operands = [Evaluable]()
//                    for value in values {
//                        if let operand = convert(key: key, matcher: matcher, anyCodable: value) {
//                            operands.append(operand)
//                        }
//                    }
//                    return operands.count == 0 ? nil : LogicalExpression(operationName: "or", operands: operands)
//                }
//            }
//            return nil
//        }
//    }
//
//    private static func convert(key: String, matcher: String, anyCodable: AnyCodable) -> Evaluable? {
//        if let value = anyCodable.value {
//            switch value {
//            case is String:
//                if let stringValue = anyCodable.stringValue {
//                    return ComparisonExpression<MustacheToken, String>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(stringLiteral: stringValue))
//                }
//                return nil
    ////            case is Double:
    ////                return ComparisonExpression<Any, Double>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(: anyCodable.doubleValue))
//            case is Int:
//                if let intValue = anyCodable.intValue {
//                    return ComparisonExpression<MustacheToken, Int>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(integerLiteral: intValue))
//                }
//                return nil
//            case is Float:
//                if let floadValue = anyCodable.floatValue {
//                    return ComparisonExpression<MustacheToken, Double>(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(floatLiteral: Double(floadValue)))
//                }
//                return nil
    ////            case is Int64:
    ////                return ComparisonExpression(lhs: Operand(mustache: key), operationName: matcher, rhs: Operand(anyCodable.longValue))
//            default:
//                return nil
//            }
//        }
//        return nil
//    }
}
