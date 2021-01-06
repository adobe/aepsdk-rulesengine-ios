/*
 Copyright 2021 Adobe. All rights reserved.
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
}
