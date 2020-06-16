//
//  MustacheToken.swift
//  Swift-Rules
//
//  Created by Jiabin Geng on 5/19/20.
//  Copyright © 2020 Adobe. All rights reserved.
//

import Foundation
public indirect enum MustacheToken {
        /// text
        case variable(text: String)

        /// {{ content }}
    case function(content: String, inner: MustacheToken)
}
