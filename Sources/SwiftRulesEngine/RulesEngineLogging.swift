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
public protocol RulesEngineLogging {
    /// Logs a message
    /// - Parameters:
    ///   - level: One of the message level identifiers, e.g., DEBUG
    ///   - label: Name of a label to localize message
    ///   - message: The string message
    func log(level: RulesEngineLogLevel, label: String, message: String)
}

public enum RulesEngineLogLevel: Int, Comparable {
    case error = 0
    case warning = 1
    case debug = 2
    case trace = 3

    /// Compares two `RulesEngineLogLevel`s for order
    /// - Parameters:
    ///   - lhs: the first `RulesEngineLogLevel` to be compared
    ///   - rhs: the second `RulesEngineLogLevel` to be compared
    /// - Returns: true, only if the second `LogLevel` is more critical
    public static func < (lhs: RulesEngineLogLevel, rhs: RulesEngineLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public func toString() -> String {
        switch self {
        case .trace:
            return "TRACE"
        case .debug:
            return "DEBUG"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }
}
