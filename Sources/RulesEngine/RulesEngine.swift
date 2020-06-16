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

public typealias RuleTracer = (Bool, Rule, Context, RulesFailure?) -> Void

public class RulesEngine {

    let evaluator: Evaluator
    let functions: Functions
    var tracer: RuleTracer?
    var rules = [Rule]()

    public init(evaluator: Evaluator, functions: Functions = Functions()) {
        self.evaluator = evaluator
        self.functions = functions
    }

    /// Evaluate all the rules against the input data
    /// - Parameter data: input data
    /// - Returns: all the rules that have been matched
    public func evaluate(data: Traversable) -> [Rule] {

        let context = Context(data: data, evaluator: evaluator, functions: functions)
        return rules.filter { rule -> Bool in
            let result = rule.evalate(in: context)
            if let tracer_ = self.tracer {
                tracer_(result.value, rule, context, result.error)
            }
            return result.value
        }
    }

    /// Register a set of rules
    /// - Parameters:
    ///   - rules: array of rules
    public func addRules(rules: [Rule]) {
        self.rules += rules
    }

    public func traceRule(with tracer:@escaping RuleTracer) {
        self.tracer = tracer
    }

    //TODO: Query of rules?
}

public struct Context {
    public let data: Traversable
    public let evaluator: Evaluator
    public let functions: Functions
}

public protocol Rule {
    var id: String { get }
    func evalate(in context: Context) -> Result<Bool, RulesFailure>
}

public enum RulesFailure: Error {
    case unknown
    case conditionNotMatched(message: String)
    case typeMismatched(message: String)
    case missingOperator(message: String)
    indirect case innerFailure(message: String, error: RulesFailure)
    indirect case innerFailures(message: String, errors:[RulesFailure])
}

extension Result where Success == Bool, Failure == RulesFailure {
    var value: Bool {
        get {
            switch self {
            case .success(let value):
                return value
            default:
                return false
            }
        }
    }

    var error: RulesFailure? {
        get {
            switch self {
            case .failure(let error):
                return error
            default:
                return nil
            }
        }
    }
}

extension RulesFailure: CustomStringConvertible {
    public var description: String {
        return getLines().joined(separator: "\n")
    }

    func getLines() -> [String] {
        switch self {
        case .conditionNotMatched(let message):
            return [message]
        case .missingOperator(let message):
            return [message]
        case .innerFailure(let message, let innerFailure):
            return [message] + innerFailure.getLines().map {"   ->"+$0}
        case .innerFailures(let message, let innerFailures):
            return [message] + innerFailures.reduce([] as [String], { current, rulesFailure -> [String] in
                current + rulesFailure.getLines()
            }).map {"   "+$0}
        default:
            return ["unknown failure"]
        }
    }
}
