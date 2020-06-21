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

extension Result where Success == Bool, Failure == RulesFailure {
    var value: Bool {
        get {
            switch self {
            case .success(let value):
                return value
            default:
                return false
            }
        }
    }

    var error: RulesFailure? {
        get {
            switch self {
            case .failure(let error):
                return error
            default:
                return nil
            }
        }
    }
}

extension RulesFailure: CustomStringConvertible {
    public var description: String {
        return getLines().joined(separator: "\n")
    }

    func getLines() -> [String] {
        switch self {
        case .conditionNotMatched(let message):
            return [message]
        case .missingOperator(let message):
            return [message]
        case .innerFailure(let message, let innerFailure):
            return [message] + innerFailure.getLines().map {"   ->"+$0}
        case .innerFailures(let message, let innerFailures):
            return [message] + innerFailures.reduce([] as [String], { current, rulesFailure -> [String] in
                current + rulesFailure.getLines()
            }).map {"   "+$0}
        default:
            return ["unknown failure"]
        }
    }
}
