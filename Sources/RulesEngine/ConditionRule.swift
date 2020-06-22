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

public class ConsequenceRule: Evaluable {

    public let id: String
    public let condition: Evaluable
    public let consequnces: [String]

    public init(id: String, condition: Evaluable, consequnces: [String] = []) {
        self.id = id
        self.condition = condition
        self.consequnces = consequnces
    }

    public func evaluate(in context: Context) -> Result<Bool, RulesFailure> {
        return self.condition.evaluate(in: context)
    }
}
