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
import XCTest

@testable import AEPRulesEngine

class RulesEngineTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormal() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let rulesEngine = RulesEngine<TestRule>(evaluator: evaluator)

        let mustache = Operand<String>(mustache: "{{key}}")
        let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "abc")
        rulesEngine.clearRules()
        let rule1 = TestRule(condition: condition)
        rulesEngine.addRules(rules: [rule1])

        let matchedRules = rulesEngine.evaluate(data: ["key": "abc"])

        XCTAssertEqual(1, matchedRules.count)
    }

    func testTrace() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let rulesEngine = RulesEngine<TestRule>(evaluator: evaluator)

        let condition1 = ComparisonExpression(lhs: "right", operationName: "equals", rhs: "wrong")
        let condition2 = ComparisonExpression(lhs: "right", operationName: "equals", rhs: "wrong")
        let andCondition = LogicalExpression(operationName: "and", operands: condition1, condition2)

        let rule = TestRule(condition: andCondition)
        rulesEngine.addRules(rules: [rule])
        var passed = true
        var error: RulesFailure?
        rulesEngine.trace { result, _, _, failure in
            passed = result
            error = failure
        }

        let result = rulesEngine.evaluate(data: [])
        XCTAssertEqual(0, result.count)
        XCTAssertTrue(!passed)
        XCTAssertTrue(!String(describing: error).isEmpty)
    }
}

private class TestRule: Rule {
    init(condition: Evaluable) { self.condition = condition }
    var condition: Evaluable
}
