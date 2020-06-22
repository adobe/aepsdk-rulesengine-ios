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

import XCTest
import Foundation

@testable import RulesEngine

class RulesEngineTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMustache() {

        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let rulesEngine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

        let mustache = Operand<String>(mustache: "{{key}}")
        let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "abc")

        let rule1 = ConsequenceRule(id: "test", condition: condition)
        rulesEngine.addRules(rules: [rule1])

        let matchedRules = rulesEngine.evaluate(data: ["key": "abc"])

        XCTAssertEqual(1, matchedRules.count)
    }

    func testCaseInsensitive() {
        let evaluator = ConditionEvaluator(options: .caseInsensitive)
        let rulesEngine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

        let condition = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "ABC")

        let rule1 = ConsequenceRule(id: "test", condition: condition)
        rulesEngine.addRules(rules: [rule1])

        let matchedRules = rulesEngine.evaluate(data: [:])

        XCTAssertEqual(1, matchedRules.count)
    }

}
