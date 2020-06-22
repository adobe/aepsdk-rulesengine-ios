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

import RulesEngine

public class ConstantEvaluable: Evaluable {
    let value: Bool
    init(_ value: Bool) {
        self.value = value
    }

    public func evaluate(in context: Context) -> Result<Bool, RulesFailure> {
        return .success(value)

    }
}

let ConstantTrue = ConstantEvaluable(true)
let ConstantFalse = ConstantEvaluable(false)
let matchersMapping = ["eq":"equals"]
extension String{
    var matcher:String{
        get {
            return matchersMapping[self] ?? ""
        }
    }
}

struct Converter {
    
    static func convertFrom(json data: [String: Any]) -> Evaluable {
        let type = data["type"] as? String
        switch type {
        case "group":
            let definition = data["definition"] as? [String: Any]
            let logic = definition?["logic"] as? String
            let conditions = definition?["conditions"] as? [[String: Any]]

            let Evaluables = conditions?.map({ condition in
                Converter.convertFrom(json: condition)
            })

            switch logic {
            case "and":
                return ConjunctionExpression(operationName: "and", operands: Evaluables!)

            case "or":
                return ConjunctionExpression(operationName: "or", operands: Evaluables!)
            default:
                return ConstantFalse
            }
        case "matcher":
            let definition = data["definition"] as? [String: Any]
            let key = definition?["key"] as! String
            let matcher = definition?["matcher"] as! String
            let values = definition?["values"] as! [Any]
            var isKeyMustache = false

            do {
                let regex = try NSRegularExpression(pattern: "\\{\\{(.*)\\}\\}", options: NSRegularExpression.Options.caseInsensitive)
                let matches = regex.matches(in: key, options: [], range: NSRange(location: 0, length: key.utf8.count))

                isKeyMustache = matches.count > 0
            } catch {
            }

            if values.count > 0 {
                let conditions = values.filter({ (item) -> Bool in
                    item is String || item is Int || item is Double || item is Bool
                }).map({ (item) -> Evaluable in
                    switch item {
                    case is String:
                        return isKeyMustache
                            ? ComparisonExpression(lhs: Operand<String>(mustache: key), operationName: matcher.matcher, rhs: .some(item as! String))
                            : ComparisonExpression(lhs: .some(key), operationName: matcher.matcher, rhs: .some(item as! String))
                    case is Int:
                        return isKeyMustache
                            ? ComparisonExpression(lhs: Operand<Int>(mustache: key), operationName: matcher.matcher, rhs: .some(item as! Int))
                            : ComparisonExpression(lhs: .some(Int(key)), operationName: matcher.matcher, rhs: .some(item as! Int))
                    case is Double:
                        return isKeyMustache
                            ? ComparisonExpression(lhs: Operand<Double>(mustache: key), operationName: matcher.matcher, rhs: .some(item as! Double))
                            : ComparisonExpression(lhs: .some(Double(key)), operationName: matcher.matcher, rhs: .some(item as! Double))
                    case is Bool:
                        return isKeyMustache
                            ? ComparisonExpression(lhs: Operand<Bool>(mustache: key), operationName: matcher.matcher, rhs: .some(item as! Bool))
                            : ComparisonExpression(lhs: .some(Bool(key)), operationName: matcher.matcher, rhs: .some(item as! Bool))

                    default:
                        return ComparisonExpression(lhs: .some(""), operationName: "equals", rhs: .some(""))
                    }
                })

                return ConjunctionExpression(operationName: "or", operands: conditions)
            } else {
                return isKeyMustache ? UnaryExpression(lhs: Operand<Any>(mustache: key), operationName: matcher) :ConstantFalse
            }
        default:
            return ConstantFalse
        }

    }
}

extension ConsequenceRule {
    static func createFrom(json data: [String: Any]) -> ConsequenceRule {

        let id = data["id"] as! String
        let consequnces = data["consequences"] as? [String]
        let condition = Converter.convertFrom(json: data["condition"] as! [String: Any])

        return ConsequenceRule(id: id, condition: condition, consequnces: consequnces ?? [])
    }
}

extension RulesEngine where R == ConsequenceRule{

    public func addRulesFrom(json data: Data) {

        let json = try? JSONSerialization.jsonObject(with: data, options: [])

        if let array = json as? [[String: Any]] {
            let rules = array.map({ item in
                ConsequenceRule.createFrom(json: item)
            })

            self.addRules(rules: rules)
        }

    }
}
