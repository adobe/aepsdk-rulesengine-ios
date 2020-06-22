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

class JsonParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCaseInsensitive() {
        let json = """
        [
        {
          "id":"testid",
          "condition": {
            "type": "group",
            "definition": {
              "logic": "and",
              "conditions": [
                {
                  "type": "group",
                  "definition": {
                    "logic": "or",
                    "conditions": [
                      {
                        "type": "group",
                        "definition": {
                          "logic": "and",
                          "conditions": [
                            {
                              "type": "matcher",
                              "definition": {
                                "key": "BLAH",
                                "matcher": "eq",
                                "values": [
                                  "BLAH"
                                ]
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          "consequences": [
            {
              "id": "RCeb0af4f5231845c7ae6d98ec61846051",
              "type": "url",
              "detail": {
                "url": "https://adobe.com"
              }
            }
          ]
        }
        ]
        """

        let evaluator = ConditionEvaluator(options: .caseInsensitive)

        let engine = RulesEngine<ConsequenceRule>(evaluator: evaluator)

        if let jsonData = json.data(using: .utf8) {
            engine.addRulesFrom(json: jsonData)
        }

        let input = ["data": ["blah": "blah"], "context": ["blah": "blah"]]
        let output = engine.evaluate(data: input)
        XCTAssertEqual(1, output.count)
    }

    func testCaseSensitive() {
        let json = """
          [
          {
            "id":"testid",
            "condition": {
              "type": "group",
              "definition": {
                "logic": "and",
                "conditions": [
                  {
                    "type": "group",
                    "definition": {
                      "logic": "or",
                      "conditions": [
                        {
                          "type": "group",
                          "definition": {
                            "logic": "and",
                            "conditions": [
                              {
                                "type": "matcher",
                                "definition": {
                                  "key": "{{data.blah}}",
                                  "matcher": "eq",
                                  "values": [
                                    "BLAH"
                                  ]
                                }
                              },

                                {
                                  "type": "matcher",
                                  "definition": {
                                    "key": "{{data.number}}",
                                    "matcher": "eq",
                                    "values": [
                                      3
                                    ]
                                  }
                                }
                            ]
                          }
                        }
                      ]
                    }
                  }
                ]
              }
            },
            "consequences": [
              {
                "id": "RCeb0af4f5231845c7ae6d98ec61846051",
                "type": "url",
                "detail": {
                  "url": "https://adobe.com"
                }
              }
            ]
          }
          ]
          """
        let evaluator = ConditionEvaluator(options: .caseInsensitive)
        let engine = RulesEngine<ConsequenceRule>(evaluator: evaluator)
        if let jsonData = json.data(using: .utf8) {
            engine.addRulesFrom(json: jsonData)
        }
//        engine.traceRule(id: "testid") { (result, rule, conext, error) in
//            print(error!)
//        }
        let input = ["data": ["blah": "blah", "number": 3], "context": ["blah": "blah"]]
        let output = engine.evaluate(data: input)
        XCTAssertEqual(1, output.count)
    }

    func testCustomOperator() {
        let json = """
          [
          {
            "id":"testid",
            "condition": {
              "type": "matcher",
              "definition": {
                "key": "{{data.blah}}",
                "matcher": "isOdd",
                "values": []
              }
            },
            "consequences": [
              {
                "id": "RCeb0af4f5231845c7ae6d98ec61846051",
                "type": "url",
                "detail": {
                  "url": "https://adobe.com"
                }
              }
            ]
          }
          ]
          """
        let evaluator = ConditionEvaluator(options: .caseInsensitive)
        evaluator.addUnaryOperator(operation: "isOdd") { (a: Any) -> Bool in
            if let intValue = a as? Int {
                return intValue % 2 == 1
            }
            return false
        }
        let engine = RulesEngine<ConsequenceRule>(evaluator: evaluator)
        if let jsonData = json.data(using: .utf8) {
            engine.addRulesFrom(json: jsonData)
        }

        let input = ["data": ["blah": 1], "context": ["blah": "blah"]]
        let output = engine.evaluate(data: input)
        XCTAssertEqual(1, output.count)
    }

    func testCustomFunction() {
        let json = """
          [
          {
            "id":"testid",
            "condition": {
              "type": "matcher",
              "definition": {
                "key": "{{double(data.blah)}}",
                "matcher": "isEven",
                "values": []
              }
            },
            "consequences": [
              {
                "id": "RCeb0af4f5231845c7ae6d98ec61846051",
                "type": "url",
                "detail": {
                  "url": "https://adobe.com"
                }
              }
            ]
          }
          ]
          """
        let functions = Transform()
        functions.register(name: "double", transformation: { value in
            if value is Int {
                return (value as! Int) * 2
            }
            return value
        })
        let evaluator = ConditionEvaluator(options: .caseInsensitive)
        evaluator.addUnaryOperator(operation: "isEven") { (a: Any) -> Bool in
            if let intValue = a as? Int {
                return intValue % 2 == 0
            }
            return false
        }
        let engine = RulesEngine<ConsequenceRule>(evaluator: evaluator, transformer: functions)
        if let jsonData = json.data(using: .utf8) {
            engine.addRulesFrom(json: jsonData)
        }

        let input = ["data": ["blah": 1], "context": ["blah": "blah"]]
        let output = engine.evaluate(data: input)
        XCTAssertEqual(1, output.count)
    }

}
