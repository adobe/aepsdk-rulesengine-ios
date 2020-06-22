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

open class Step {

    public init() {}

    open var title: String {
        "\(type(of: self))"
    }

    open func execute() {}
}

public struct Condition {

    public let condition: Evaluable

    public init(@RuleBuilder _ content: () -> Evaluable) {
        condition = content()
    }

}

public struct Consequence {

    public let consequnce: [String: Any]

    public init(@RuleBuilder _ content: () -> [String: Any]) {
        consequnce = content()
    }
}

@_functionBuilder public struct RuleBuilder {

    static public func buildBlock(_ when: Condition, _ then: Consequence) -> (Condition, Consequence) {
        return (when, then)
    }
}

extension RulesEngine where R == ConsequenceRule{

    public func addRulesFrom(@RuleBuilder _ content: () -> (given: Condition, then: Consequence)) {
        let content = content()

        let rule = ConsequenceRule(id: "testid", condition: content.given.condition)

        self.addRules(rules: [rule])

   }
}
