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
import RulesEngine

extension Event: Traversable {
    public subscript(traverse sub: String) -> Any? {
        switch sub {
        case "name":return name
        case "id":return id
        case "type":return type
        case "source":return source
        case "timestamp":return timestamp
        case "responseID":return responseID
        case "data":return data
        default:
            return Optional<String>.none
        }
    }

}
