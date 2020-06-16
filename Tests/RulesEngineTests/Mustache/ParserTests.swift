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

class ParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let parser = TemplateParser(tagDelimiterPair: ("{{", "}}"))
        let result = parser.parse("sdfdfd{{test}}aaa")
        XCTAssertEqual(3, (try! result.get()).count)
    }

    func testPerformanceExample() {
        let parser = TokenParser()
//        parser.parse("abc(test)")
    }

}
