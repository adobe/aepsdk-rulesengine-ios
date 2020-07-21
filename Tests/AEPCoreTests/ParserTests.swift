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

@testable import AEPCore
@testable import SwiftRulesEngine

class LaunchRulesTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchRuleParser() {
        if let launchRulesRoot = LaunchRulesParser.parse(json) {
            XCTAssertEqual(1, launchRulesRoot.version)
        } else {
            XCTAssertTrue(false)
        }
    }

    private let json = """
    {
      "version": 1,
      "rules": [
        {
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
                                "key": "~type",
                                "matcher": "eq",
                                "values": [
                                  "com.adobe.eventType.lifecycle"
                                ]
                              }
                            },
                            {
                              "type": "matcher",
                              "definition": {
                                "key": "~source",
                                "matcher": "eq",
                                "values": [
                                  "com.adobe.eventSource.responseContent"
                                ]
                              }
                            },
                            {
                              "type": "matcher",
                              "definition": {
                                "key": "lifecyclecontextdata.launchevent",
                                "matcher": "ex",
                                "values": []
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                },
                {
                  "type": "group",
                  "definition": {
                    "logic": "and",
                    "conditions": [
                      {
                        "type": "matcher",
                        "definition": {
                          "key": "~state.com.adobe.module.lifecycle/lifecyclecontextdata.carriername",
                          "matcher": "eq",
                          "values": [
                            "AT&T"
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
              "id": "RCd6959d7b48da42709b442c52b74b0e3c",
              "type": "url",
              "detail": {
                "url": "http://adobe.com/device={%~state.com.adobe.module.lifecycle/lifecyclecontextdata.devicename%}"
              }
            }
          ]
        },
        {
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
                                "key": "~type",
                                "matcher": "eq",
                                "values": [
                                  "com.adobe.eventType.lifecycle"
                                ]
                              }
                            },
                            {
                              "type": "matcher",
                              "definition": {
                                "key": "~source",
                                "matcher": "eq",
                                "values": [
                                  "com.adobe.eventSource.responseContent"
                                ]
                              }
                            },
                            {
                              "type": "matcher",
                              "definition": {
                                "key": "lifecyclecontextdata.launchevent",
                                "matcher": "ex",
                                "values": []
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                },
                {
                  "type": "group",
                  "definition": {
                    "logic": "and",
                    "conditions": [
                      {
                        "type": "matcher",
                        "definition": {
                          "key": "~state.com.adobe.module.lifecycle/lifecyclecontextdata.installevent",
                          "matcher": "ex",
                          "values": []
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
              "id": "RC32e02c4d81984b1c8469fdc165fe1fc5",
              "type": "url",
              "detail": {
                "url": "https://adobe.com"
              }
            }
          ]
        }
      ]
    }

    """
}
