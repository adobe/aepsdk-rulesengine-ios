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

public protocol Resolvable {
    func resolve(in context: Context) -> Any?
}

extension MustacheToken: Resolvable {
    public func resolve(in context: Context) -> Any? {
        switch self {
        case .function(let name, let innerToken):
            let innerValue = innerToken.resolve(in: context)
            return context.functions.evaluate(name: name, parameter: innerValue)
        case .variable(let name):
            let path = name.components(separatedBy: ".")
            return context.data[path: path]
        }
    }
}

extension Operand {

        public init(mustache: String) {
            do {
                let tokens = try TemplateParser().parse(mustache).get()
                if case .mustache(let token) = tokens[0].type {
                    if let token_ = token {
                        self = .template(token_)
                    } else {
                        self = .none
                    }
                    return
                }
            } catch {
            }

            self = .none
        }
}
