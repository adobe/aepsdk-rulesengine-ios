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

class RulesEngineDebugTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrace() {

        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let rulesEngine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

        let mustache = Operand<String>(mustache: "{{key}}")
        let condition1 = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "wrong")

        let condition2 = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "another wrong")
        let condition3 = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "abc")
        let condition4 = ComparisonExpression(lhs: mustache, operationName: "wat", rhs: "abc")
        let andCondition = ConjunctionExpression(operationName: "and", operands: condition1, condition2, condition3)
        let orCondition = ConjunctionExpression(operationName: "or", operands: andCondition, condition1, condition2, condition4)

        let rule1 = ConsequenceRule(id: "test", condition: orCondition)
        rulesEngine.addRules(rules: [rule1])

        var traceResult: Bool?
        var traceError: RulesFailure?
//        rulesEngine.traceRule(id: "test") { (result, rule, conext, error) in
//            traceResult = result
//            traceError = error
//            print(traceError!)
//        }

        let result = rulesEngine.evaluate(data: ["key": "abc"])
        XCTAssertEqual(0, result.count)
//        XCTAssertFalse(traceResult!)
    }

}
