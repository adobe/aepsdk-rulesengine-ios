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

public struct LogicalExpression: Evaluable {
    public let operands: [Evaluable]
    public let operationName: String

    public init(operationName: String, operands: Evaluable...) {
        self.operands = operands
        self.operationName = operationName
    }

    public init(operationName: String, operands: [Evaluable]) {
        self.operands = operands
        self.operationName = operationName
    }

    public func evaluate(in context: Context) -> Result<Bool, RulesFailure> {
        switch operationName {
        case "and":
            for evaluable in operands {
                // Exit if any evaluation fails
                if case let .failure(failure) = evaluable.evaluate(in: context) {
                    return .failure(.innerFailure(message: "`And` returns false", error: failure))
                }
            }
            return .success(true)
        case "or":
            var failureResults = [RulesFailure]()
            for evaluable in operands {
                let result = evaluable.evaluate(in: context)
                // Succeed with any success
                if case .success = result {
                    return .success(true)
                } else if case let .failure(failure) = result {
                    failureResults.append(failure)
                }
            }
            return .failure(.innerFailures(message: "`Or` returns false", errors: failureResults))
        default:
            return .failure(.missingOperator(message: "Unknown conjunction operator '\(operationName)'"))
        }
    }
}
