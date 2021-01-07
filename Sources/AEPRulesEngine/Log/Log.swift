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

/// The `Log` class will be dormant unless its static `logging` variable is initialized.
/// To enable logging from the RulesEngine, implement a class that conforms to the
/// `Logging` protocol and use an instance of it to set the `Log.logging` variable.
public enum Log {
    public static var logging: Logging?
    /// Used to print more verbose information.
    /// - Parameters:
    ///   - label: the name of the label to localize message
    ///   - message: the string to be logged
    static func trace(label: String, _ message: String) {
        logging?.log(level: .trace, label: label, message: message)
    }

    /// Information provided to the debug method should contain high-level details about the data being processed
    /// - Parameters:
    ///   - label: the name of the label to localize message
    ///   - message: the string to be logged
    static func debug(label: String, _ message: String) {
        logging?.log(level: .debug, label: label, message: message)
    }

    /// Information provided to the warning method indicates that a request has been made to the SDK, but the SDK will be unable to perform the requested task
    /// - Parameters:
    ///   - label: the name of the label to localize message
    ///   - message: the string to be logged
    static func warning(label: String, _ message: String) {
        logging?.log(level: .warning, label: label, message: message)
    }

    /// Information provided to the error method indicates that there has been an unrecoverable error
    /// - Parameters:
    ///   - label: the name of the label to localize message
    ///   - message: the string to be logged
    static func error(label: String, _ message: String) {
        logging?.log(level: .error, label: label, message: message)
    }
}
