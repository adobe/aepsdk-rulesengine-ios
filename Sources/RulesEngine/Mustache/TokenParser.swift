//
//  TokenParser.swift
//  Swift-Rules
//
//  Created by Jiabin Geng on 5/19/20.
//  Copyright © 2020 Adobe. All rights reserved.
//
import Foundation

final class TokenParser {

    init() {
    }

    static func parse(_ tokenString: String) -> Result<MustacheToken, Error> {
        if let range = tokenString.range(of: #"\((.*\))+"#,
                                         options: .regularExpression) {
            let variable = String(tokenString[(tokenString.index(after: range.lowerBound))..<(tokenString.index(before: range.upperBound))]).trimmingCharacters(in: .whitespacesAndNewlines)
            let funtionName = String(tokenString[(tokenString.startIndex)...(tokenString.index(before: range.lowerBound))]).trimmingCharacters(in: .whitespacesAndNewlines)
            return .success(.function(content: funtionName, inner: .variable(text: variable)))
        } else {
            return .success(.variable(text: tokenString))
        }

    }

}
