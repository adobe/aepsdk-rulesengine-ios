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
}

struct Definition: Codable {
    let logic: String?
    let conditions: [Condition]?
    let key: AnyCodable?
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
    private init(condition: Evaluable) {
        self.condition = condition
    }

    public static func generateRules(json: String) -> [AEPRule] {
        if let launchRulesRoot = LaunchRulesParser.parse(json) {
            return convert(launchRulesRoot)
        } else {
            return []
        }
    }

    private static func convert(_ root: LaunchRuleRoot) -> [AEPRule] {
        var result = [AEPRule]()
        for launchRule in root.rules {
            if let conditionExpression = convert(launchRule.condition) {
                let rule = AEPRule(condition: conditionExpression)
                result.append(rule)
            }
        }
        return result
    }

    private static func convert(_ condition: Condition) -> LogicalExpression? {
       return nil
    }

//    private static func convert(_ condition: Condition) -> ComparisonExpression? {
//        guard condition.type == .matcher else {
//            return nil
//        }
//
//        return nil
//    }
}
