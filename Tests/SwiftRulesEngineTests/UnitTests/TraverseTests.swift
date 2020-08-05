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

@testable import SwiftRulesEngine
import XCTest

extension Array: Traversable {
    public func get(key: String) -> Any? {
        if let index = Int(key) {
            return self[index]
        }
        return nil
    }
}

extension Dictionary: Traversable where Key == String {
    public func get(key: String) -> Any? {
        let result = self[key]
        return result
    }
}

struct CustomTraverse: Traversable {
    public func get(key: String) -> Any? {
        key
    }
}

class TraverseTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEqual_True() {
        let dict = ["key": "value", "embeded": ["blah": "blah"]] as [String: Any]
        let b = dict[path: ["key"]]
        let c = dict[path: ["embeded", "blah"]]
        XCTAssertEqual(b as! String, "value")
        XCTAssertEqual(c as! String, "blah")
    }

    func testCustom() {
        let custom = CustomTraverse()
        let dict = ["key": "value", "embeded": ["blah": "blah"], "custom": custom] as [String: Any]

        let c = dict[path: ["custom", "blah"]]
        let d = dict[path: ["custom", "blah1234"]]

        XCTAssertEqual(c as! String, "blah")
        XCTAssertEqual(d as! String, "blah1234")
    }

    func testArray() {
        let custom = CustomTraverse()
        let dict = ["array": ["value0", "value1", custom]] as [String: Any]

        let c = dict[path: ["array", "0"]]
        let d = dict[path: ["array", "2", "blah"]]

        XCTAssertEqual(c as! String, "value0")
        XCTAssertEqual(d as! String, "blah")
    }
}
