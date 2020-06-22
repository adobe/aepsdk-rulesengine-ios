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

        let result = TemplateParser.parse("sdfdfd{{test}}aaa")
        XCTAssertEqual(3, (try! result.get()).count)
    }

    func testPerformanceExample() {
        let template = Template(templateString: "sdfdfd{{test}}aaa")
        let result = template.render(data: ["test":"value"], transformers: Transform())
        XCTAssertEqual("sdfdfdvalueaaa", result)
    }
    
        func testTransform() {
            let template = Template(templateString: "sdfdfd{{dash(test)}}aaa")
            let tran = Transform()
            tran.register(name: "dash", transformation: { value in
                if value is String {
                    return "-\(value as! String)-"
                }
                return value
            })
            let result = template.render(data: ["test":"value"], transformers: tran)
            XCTAssertEqual("sdfdfd-value-aaa", result)
    //        let parser = TokenParser()
    //        parser.parse("abc(test)")
        }
    
        func testTransform1() {
            let template = Template(templateString: "sdfdfd{{dash(test)}}aaa{{dash(int)}}")
            let tran = Transform()
            let result = template.render(data: ["test":"value", "int":5], transformers: tran)
            XCTAssertEqual("sdfdfdvalueaaa5", result)
        }
    
    func testTransform12() {
        let template = Template(templateString: "sdfdfd{{dash(test)}}aaa{{dash(int)}")
        let tran = Transform()
        let result = template.render(data: ["test":"value", "int":5], transformers: tran)
        XCTAssertEqual("", result)
    }
    
    func testTransform123() {
        let template = Template(templateString: "sdfdfd{{}}")
        let tran = Transform()
        let result = template.render(data: ["test":"value", "int":5], transformers: tran)
        XCTAssertEqual("sdfdfd", result)
    }
}
