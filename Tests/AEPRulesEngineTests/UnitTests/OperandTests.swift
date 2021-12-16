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

class OperandTests: XCTestCase {
    func testMustacheNoneValue() {
        let mustache = Operand<String>(mustache: "")
        XCTAssertEqual("<None>", String(describing: mustache))
    }

    func testDoubleValue() {
        let operand = Operand(floatLiteral: 1.2)
        XCTAssertEqual("<Value: 1.2>", String(describing: operand))
    }

    func testBoolValue() {
        let operand = Operand(booleanLiteral: true)
        XCTAssertEqual("<Value: true>", String(describing: operand))
    }

    func testNilValue() {
        let operand: Operand<String> = nil
        XCTAssertEqual("<None>", String(describing: operand))
    }

    func testFunctionValue() {
        let operand: Operand<Int> = Operand(function: { _ in
            1
        })
        XCTAssertEqual(1, operand.resolve(in: Context(data: CustomTraverse(), evaluator: ConditionEvaluator(), transformer: Transformer())))
    }

    func testFunctionWithParams() {
        let parameters: [Any] = ["aString", 552]
        let operand: Operand<Int> = Operand(function: { params in
            guard let p = params else {
                return 0
            }
            XCTAssertEqual(2, p.count)
            XCTAssertEqual("aString", p[0] as? String)
            XCTAssertEqual(552, p[1] as? Int)

            return 1
        }, parameters: parameters)

        let result = operand.resolve(in: Context(data: CustomTraverse(), evaluator: ConditionEvaluator(), transformer: Transformer()))
        XCTAssertEqual(1, result)
    }
}
