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
    fileprivate let LOG_TAG = "ConditionEvaluator"
    var operators: [String: Any] = [:]

    // MARK: - Evaluating

    public func evaluate<A>(operation: String, lhs: A) -> Result<Bool, RulesFailure> {
        let op = operators[getHash(operation: operation, typeA: A.self)] as? ((A) -> Bool)

        guard let op_ = op else {
            let message = "No operator defined for \(getHash(operation: operation, typeA: A.self))"
            Log.trace(label: LOG_TAG, message)
            return Result.failure(RulesFailure.missingOperator(message: message))
        }
        return op_(lhs) ? Result.success(true) : Result.failure(.conditionNotMatched(message: "(\(String(describing: A.self))(\(lhs)) \(operation))"))
    }

    public func evaluate<A, B>(operation: String, lhs: A, rhs: B) -> Result<Bool, RulesFailure> {
        let op = operators[getHash(operation: operation, typeA: A.self, typeB: B.self)] as? ((A, B) -> Bool)

        guard let op_ = op else {
            let message = "No operator defined for \(getHash(operation: operation, typeA: A.self, typeB: B.self))"
            Log.trace(label: LOG_TAG, message)
            return Result.failure(RulesFailure.missingOperator(message: message))
        }
        return op_(lhs, rhs) ? Result.success(true) : Result.failure(.conditionNotMatched(message: "\(String(describing: A.self))(\(lhs)) \(operation) \(String(describing: B.self))(\(rhs))"))
    }
}

public extension ConditionEvaluator {
    func addUnaryOperator<A>(operation: String, closure: @escaping (A) -> Bool) {
        operators[getHash(operation: operation, typeA: A.self)] = closure
    }

    func addComparisonOperator<A, B>(operation: String, closure: @escaping (A, B) -> Bool) {
        operators[getHash(operation: operation, typeA: A.self, typeB: B.self)] = closure
    }

    func addComparisonOperator<A>(operation: String, type _: A.Type, closure: @escaping (A, A) -> Bool) {
        operators[getHash(operation: operation, typeA: A.self, typeB: A.self)] = closure
    }

    private func getHash<A, B>(operation: String, typeA _: A.Type, typeB _: B.Type) -> String {
        "\(operation)(\(String(describing: A.self)),\(String(describing: B.self)))"
    }

    private func getHash<A>(operation: String, typeA _: A.Type) -> String {
        "\(operation)(\(String(describing: A.self))\(operation))"
    }
}

public extension ConditionEvaluator {
    struct Options: OptionSet {
        public let rawValue: Int
        public static let defaultOptions = Options(rawValue: 1 << 0)
        public static let caseInsensitive = Options(rawValue: 1 << 1)

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
        addComparisonOperator(operation: "and", type: Bool.self, closure: { $0 && $1 })
        addComparisonOperator(operation: "or", type: Bool.self, closure: { $0 || $1 })

        addComparisonOperator(operation: "equals", type: String.self, closure: ==)
        addComparisonOperator(operation: "equals", type: Int.self, closure: ==)
        addComparisonOperator(operation: "equals", type: Int64.self, closure: ==)
        addComparisonOperator(operation: "equals", type: Double.self, closure: ==)
        addComparisonOperator(operation: "equals", type: Bool.self, closure: ==)

        addComparisonOperator(operation: "notEquals", type: String.self, closure: !=)
        addComparisonOperator(operation: "notEquals", type: Int.self, closure: !=)
        addComparisonOperator(operation: "notEquals", type: Int64.self, closure: !=)
        addComparisonOperator(operation: "notEquals", type: Double.self, closure: !=)
        addComparisonOperator(operation: "notEquals", type: Bool.self, closure: !=)

        addComparisonOperator(operation: "startsWith", type: String.self, closure: { $0.starts(with: $1) })
        addComparisonOperator(operation: "endsWith", type: String.self, closure: { $0.hasSuffix($1) })
        addComparisonOperator(operation: "contains", type: String.self, closure: { $0.contains($1) })
        addComparisonOperator(operation: "notContains", type: String.self, closure: { !$0.contains($1) })

        addComparisonOperator(operation: "greaterThan", type: Int.self, closure: >)
        addComparisonOperator(operation: "greaterThan", type: Int64.self, closure: >)
        addComparisonOperator(operation: "greaterThan", type: Double.self, closure: >)

        addComparisonOperator(operation: "greaterEqual", type: Int.self, closure: >=)
        addComparisonOperator(operation: "greaterEqual", type: Int64.self, closure: >=)
        addComparisonOperator(operation: "greaterEqual", type: Double.self, closure: >=)

        addComparisonOperator(operation: "lessEqual", type: Int.self, closure: <=)
        addComparisonOperator(operation: "lessEqual", type: Int64.self, closure: <=)
        addComparisonOperator(operation: "lessEqual", type: Double.self, closure: <=)

        addComparisonOperator(operation: "lessThan", type: Int.self, closure: <)
        addComparisonOperator(operation: "lessThan", type: Int64.self, closure: <)
        addComparisonOperator(operation: "lessThan", type: Double.self, closure: <)

        addComparisonOperator(operation: "notExist", type: Any?.self, closure: { lhs, _ in
            lhs == nil
        })
        addComparisonOperator(operation: "exists", type: Any?.self, closure: { lhs, _ in
            lhs != nil
        })
    }

    private func addCaseInSensitiveOperators() {
        addComparisonOperator(operation: "equals", type: String.self, closure: { $0.lowercased() == $1.lowercased() })
        addComparisonOperator(operation: "notEquals", type: String.self, closure: { $0.lowercased() != $1.lowercased() })
        addComparisonOperator(operation: "startsWith", type: String.self, closure: { $0.lowercased().starts(with: $1.lowercased()) })
        addComparisonOperator(operation: "endsWith", type: String.self, closure: { $0.lowercased().hasSuffix($1.lowercased()) })
        addComparisonOperator(operation: "contains", type: String.self, closure: { $0.lowercased().contains($1.lowercased()) })
        addComparisonOperator(operation: "notContains", type: String.self, closure: { !$0.lowercased().contains($1.lowercased()) })
    }
}
