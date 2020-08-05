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

@testable import SwiftRulesEngine
struct CustomOperand: Traversable {
    func get(key:String) -> Any? {
        return key
    }
}

class ExpressionTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testString() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)

        let a = ComparisonExpression(lhs: 3, operationName: "equals", rhs: 3)
        let result = a.evaluate(in: Context(data: [:], evaluator: evaluator, transformer: Transform()))
        XCTAssertTrue(result.value)
    }

    func testAnd() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)

        let a = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let b = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let c = LogicalExpression(operationName: "and", operands: a, b)
        let result = c.evaluate(in: Context(data: [:], evaluator: evaluator, transformer: Transform()))
        XCTAssertTrue(result.value)
    }

    func testMustache() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let mustache = Operand<String>(mustache: "{{key}}")
        let a = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "abc")
        let b = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let c = LogicalExpression(operationName: "and", operands: a, b)
        let result = c.evaluate(in: Context(data: ["key": "abc"], evaluator: evaluator, transformer: Transform()))
        XCTAssertTrue(result.value)
    }

    func testMustache_Nil() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let mustache = Operand<String>(mustache: "{{key}}")
        let a = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "abc")
        let b = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let c = LogicalExpression(operationName: "and", operands: a, b)
        let result = c.evaluate(in: Context(data: ["someelse": "abc"], evaluator: evaluator, transformer: Transform()))
        XCTAssertFalse(result.value)
    }

    func testMustache_Any_isNil_false() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let mustache = Operand<String>(mustache: "{{key}}")
        let a = ComparisonExpression(lhs: mustache, operationName: "nx", rhs: Operand<String>.none)
        let b = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let c = LogicalExpression(operationName: "and", operands: a, b)
        let result = c.evaluate(in: Context(data: ["key": "abc"], evaluator: evaluator, transformer: Transform()))

        XCTAssertFalse(result.value)
    }

    func testMustache_Any_isNil_true() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let mustache = Operand<Any>(mustache: "{{other}}")
        let a = ComparisonExpression(lhs: mustache, operationName: "notExist", rhs: Operand<Any>.none)
        let b = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let c = LogicalExpression(operationName: "and", operands: a, b)
        let result = c.evaluate(in: Context(data: ["key": "abc"], evaluator: evaluator, transformer: Transform()))

        XCTAssertTrue(result.value)
    }

    func testMustache_Custom() {
        let evaluator = ConditionEvaluator(options: .defaultOptions)
        evaluator.addUnaryOperator(operation: "isAmazing") { (lhs: CustomOperand) -> Bool in
            (lhs.get(key: "test") as? String) == "test"
        }

        let mustache = Operand<CustomOperand>(mustache: "{{custom}}")
        let a = UnaryExpression(lhs: mustache, operationName: "isAmazing")
        let b = ComparisonExpression(lhs: "abc", operationName: "equals", rhs: "abc")
        let c = LogicalExpression(operationName: "and", operands: a, b)
        let result = c.evaluate(in: Context(data: ["custom": CustomOperand()], evaluator: evaluator, transformer: Transform()))
        XCTAssertTrue(result.value)
    }
}
