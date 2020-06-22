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


public class ConditionEvaluator: Evaluating {

    var operators: [String: Any] = [:]
    public func evaluate<A>(operation: String, lhs: A) -> Result<Bool, RulesFailure> {
        let op = operators[getHash(operation: operation, typeA: A.self)] as? ((A) -> Bool)
        guard let op_ = op else {
            return Result.failure(RulesFailure.missingOperator(message: "Operator not defined for \(getHash(operation: operation, typeA: A.self))"))
        }
        return op_(lhs) ? Result.success(true) : Result.failure(.conditionNotMatched(message: "(\(String(describing: A.self))(\(lhs)) \(operation))" ))
    }

    public func evaluate<A, B>(operation: String, lhs: A, rhs: B) -> Result<Bool, RulesFailure> {
        let op = operators[getHash(operation: operation, typeA: A.self, typeB: B.self)] as? ((A, B) -> Bool)

        guard let op_ = op else {
                return Result.failure(RulesFailure.missingOperator(message: "Operator not defined for \(getHash(operation: operation, typeA: A.self, typeB: B.self))"))
        }
        return op_(lhs, rhs) ? Result.success(true) : Result.failure(.conditionNotMatched(message: "\(String(describing: A.self))(\(lhs)) \(operation) \(String(describing: B.self))(\(rhs))" ))

    }
}

extension ConditionEvaluator {

    public func addUnaryOperator<A>(operation: String, closure:@escaping (A) -> Bool) {
        operators[getHash(operation: operation, typeA: A.self)] = closure
    }

    public func addComparisonOperator<A, B>(operation: String, closure:@escaping (A, B) -> Bool) {
        operators[getHash(operation: operation, typeA: A.self, typeB: B.self)] = closure
    }

    public func addComparisonOperator<A>(operation: String, type: A.Type, closure:@escaping (A, A) -> Bool) {
        operators[getHash(operation: operation, typeA: A.self, typeB: A.self)] = closure
    }

    private func getHash<A, B>(operation: String, typeA: A.Type, typeB: B.Type) -> String {
        return "\(operation)(\(String(describing: A.self)),\(String(describing: B.self)))"
    }
    private func getHash<A>(operation: String, typeA: A.Type) -> String {
        return "\(operation)(\(String(describing: A.self))\(operation))"
    }
}

public extension ConditionEvaluator {

    struct Options: OptionSet {
        public let rawValue: Int
        public static let defaultOptions    = Options(rawValue: 1 << 0)
        public static let caseInsensitive  = Options(rawValue: 1 << 1)

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    convenience init(options: Options) {
        self.init()
        addDefaultOperators()

        if options.contains(.caseInsensitive) {
            addCaseInSensitiveOperators()
        }
    }

    private func addDefaultOperators() {

        self.addComparisonOperator(operation: "and", type: Bool.self, closure: {$0 && $1})
        self.addComparisonOperator(operation: "or", type: Bool.self, closure: {$0 || $1})

        self.addComparisonOperator(operation: "equals", type: String.self, closure: ==)
        self.addComparisonOperator(operation: "equals", type: Int.self, closure: ==)
        self.addComparisonOperator(operation: "equals", type: Double.self, closure: ==)
        self.addComparisonOperator(operation: "equals", type: Bool.self, closure: ==)

        self.addComparisonOperator(operation: "startsWith", type: String.self, closure: {$0.starts(with: $1)})
        self.addComparisonOperator(operation: "endsWith", type: String.self, closure: {$0.hasSuffix($1)})
        self.addComparisonOperator(operation: "contains", type: String.self, closure: {$0.contains($1)})

        self.addComparisonOperator(operation: "greaterThan", type: Int.self, closure: >)
        self.addComparisonOperator(operation: "greaterThan", type: Double.self, closure: >)

        self.addComparisonOperator(operation: "greaterEqual", type: Int.self, closure: >=)
        self.addComparisonOperator(operation: "greaterEqual", type: Double.self, closure: >=)

        self.addComparisonOperator(operation: "lessEqual", type: Int.self, closure: <=)
        self.addComparisonOperator(operation: "lessEqual", type: Double.self, closure: <=)

        self.addComparisonOperator(operation: "lessThan", type: Int.self, closure: <)
        self.addComparisonOperator(operation: "lessThan", type: Double.self, closure: <)

        addComparisonOperator(operation: "notExist", type: Optional<Any>.self, closure: { lhs, _ in
            lhs == nil
        })
        addComparisonOperator(operation: "exists", type: Optional<Any>.self, closure: { lhs, _ in
            lhs != nil
        })

//        self.addComparisonOperator(operation: "co", closure: { (lhs:Array<String>, rhs:String) in
//            return lhs.contains(rhs)
//        })
//        self.addComparisonOperator(operation: "eq", type: AnyObject.self, closure: {$0.isEqual($1)})
    }

    private func addCaseInSensitiveOperators() {

        self.addComparisonOperator(operation: "startsWith", type: String.self, closure: {$0.lowercased().starts(with: $1.lowercased())})
        self.addComparisonOperator(operation: "equals", type: String.self, closure: {$0.lowercased() ==  $1.lowercased()})
        self.addComparisonOperator(operation: "endsWith", type: String.self, closure: {$0.lowercased().hasSuffix($1.lowercased())})
        self.addComparisonOperator(operation: "contains", type: String.self, closure: {$0.lowercased().contains($1.lowercased())})
    }

}
