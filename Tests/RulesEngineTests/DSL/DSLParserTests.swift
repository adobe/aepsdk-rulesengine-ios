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

class DSLParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        let evaluator = ConditionEvaluator(options: .caseInsensitive)
        let engine = RulesEngine<ConsequenceRule>(evaluator: evaluator)
        engine.addRulesFrom {
            Condition {

                ComparisonExpression(lhs: Operand<String>(mustache: "{{data.blah}}"), operationName: "equals", rhs: "blah")
            }
            Consequence {
                ["key": "value"]
            }
        }

        let input = ["data": ["blah": "blah"], "context": ["blah": "blah"]]

        let output = engine.evaluate(data: input)
        XCTAssertEqual(1, output.count)

    }

}
