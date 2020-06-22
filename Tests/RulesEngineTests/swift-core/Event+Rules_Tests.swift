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

class EventRulesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAnyCodableAsInputData() {
        let dictionary: [String: AnyCodable] = [
            "stringKey": "stringValue",
            "boolKey": true,
            "doubleKey": 123.456,
            "intKey": 123,
            "intKey1": 1,
            "intKey2": 0,
            "intKey3": AnyCodable(NSNumber(0)),
            "map": [
                "stringKey": "stringValue",
                "boolKey": true,
                "doubleKey": 123.456,
                "intKey": 123,
                "intKey1": 1,
                "intKey2": 0,
                "intKey3": AnyCodable(NSNumber(0))
            ]
        ]

        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let rulesEngine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

        let mustache = Operand<String>(mustache: "{{map.stringKey}}")
        let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "stringValue")

        let rule1 = ConsequenceRule(id: "test", condition: condition)
        rulesEngine.addRules(rules: [rule1])

        let matchedRules = rulesEngine.evaluate(data: dictionary)

        XCTAssertEqual(1, matchedRules.count)

    }

    func testEventAsInputData() {
         let dictionary: [String: AnyCodable] = [
                   "stringKey": "stringValue",
                   "map": [
                       "stringKey": "stringValue"
                   ]
               ]

               let requestEvent = Event(name: "testEvent", type: .analytics, source: .requestContent, data: dictionary)

               let evaluator = ConditionEvaluator(options: .defaultOptions)
               let rulesEngine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

                let mustache = Operand<String>(mustache: "{{data.map.stringKey}}")
               let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "stringValue")

               let rule1 = ConsequenceRule(id: "test", condition: condition)
               rulesEngine.addRules(rules: [rule1])

               let matchedRules = rulesEngine.evaluate(data: requestEvent)

               XCTAssertEqual(1, matchedRules.count)
    }

    struct SharedStatesWrapper: Traversable {
        let index: Int
        let maps: [String: SharedState]

        public subscript(traverse sub: String) -> Any? {
            let result =  maps[sub]?.resolve(version: index).value
            return result
        }
    }

    func testEventAndSharedStateAsInputData() {

        let eventdata: [String: AnyCodable] = [
            "stringKey": "stringValue",
            "map": [
                "stringKey": "stringValue"
            ]
        ]
        let sharedState = SharedState()
        let statesWrapper = SharedStatesWrapper(index: 3, maps: ["extension1": sharedState])
        let event = Event(name: "testEvent", type: .analytics, source: .requestContent, data: eventdata)

        let evaluator = ConditionEvaluator(options: .defaultOptions)
        let rulesEngine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

        let mustache = Operand<String>(mustache: "{{state.extension1.statekey}}")
        let condition = ComparisonExpression(lhs: mustache, operationName: "equals", rhs: "stringValue")

        let rule1 = ConsequenceRule(id: "test", condition: condition)
        rulesEngine.addRules(rules: [rule1])

        let matchedRules = rulesEngine.evaluate(data: ["event": event, "state": statesWrapper])
        XCTAssertEqual(0, matchedRules.count)

        sharedState.set(version: 3, data: ["statekey": "stringValue"])

        let matchedRules2 = rulesEngine.evaluate(data: ["event": event, "state": statesWrapper])

        XCTAssertEqual(1, matchedRules2.count)
    }

}
