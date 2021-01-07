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

private class TestLogger: Logging {
    public var message = ""
    public var label = ""
    public var level = LogLevel.debug
    public func log(level: LogLevel, label: String, message: String) {
        self.message = message
        self.level = level
        self.label = label
    }
}

class RulesEngineLoggingTests: XCTestCase {
    func testLogging() {
        let log = TestLogger()
        Log.logging = log
        Log.debug(label: "labelA", "debug message")
        XCTAssertEqual("labelA", log.label)
        XCTAssertEqual("debug message", log.message)
        XCTAssertEqual(LogLevel.debug, log.level)
        Log.warning(label: "labelA", "warning message")
        XCTAssertEqual(LogLevel.warning, log.level)
        Log.error(label: "labelA", "error message")
        XCTAssertEqual(LogLevel.error, log.level)
    }
}
