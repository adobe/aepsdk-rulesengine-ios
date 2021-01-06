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

@testable import AEPRulesEngine
import XCTest

class RulesEngineLogLevelTests: XCTestCase {
    func testLogLevelComparison() {
        XCTAssertTrue(LogLevel.error < LogLevel.warning)
        XCTAssertTrue(LogLevel.warning < LogLevel.debug)
        XCTAssertTrue(LogLevel.debug < LogLevel.trace)
    }

    func testLogLevelToString() {
        XCTAssertEqual(LogLevel.error.toString(), "ERROR")
        XCTAssertEqual(LogLevel.warning.toString(), "WARNING")
        XCTAssertEqual(LogLevel.debug.toString(), "DEBUG")
        XCTAssertEqual(LogLevel.trace.toString(), "TRACE")
    }
}
