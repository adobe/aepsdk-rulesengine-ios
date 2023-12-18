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

public typealias RulesTracer = (Bool, Rule, Context, RulesFailure?) -> Void

public class RulesEngine<T: Rule> {
    public let version = "5.0.0"
    let evaluator: Evaluating
    let transformer: Transforming
    var tracer: RulesTracer?
    var rules = [T]()

    public init(evaluator: Evaluating, transformer: Transforming = Transformer()) {
        self.evaluator = evaluator
        self.transformer = transformer
    }

    /// Evaluate all the rules against the input data
    /// - Parameter data: input data
    /// - Returns: all the rules that have been matched
    public func evaluate(data: Traversable) -> [T] {
        let context = Context(data: data, evaluator: evaluator, transformer: transformer)
        return rules.filter { rule -> Bool in
            let result = rule.condition.evaluate(in: context)
            if let tracer = self.tracer {
                tracer(result.value, rule, context, result.error)
            }
            return result.value
        }
    }

    /// Register a set of rules
    /// - Parameters:
    ///   - rules: array of rules
    public func addRules(rules: [T]) {
        self.rules += rules
    }

    /// clear the current rules set
    public func clearRules() {
        rules = [T]()
    }

    /// trace the result of each rule evaluation
    /// - Parameter tracer: the `RulesTracer` which will be called after each rule evaluation
    public func trace(with tracer: @escaping RulesTracer) {
        self.tracer = tracer
    }
}
