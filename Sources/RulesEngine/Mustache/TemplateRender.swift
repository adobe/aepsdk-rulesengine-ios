//
//  TemplateRender.swift
//  Swift-Rules
//
//  Created by Jiabin Geng on 5/22/20.
//  Copyright © 2020 Adobe. All rights reserved.
//

import Foundation


public class TemplateRender {
    let functions:Functions
    public init(functions: Functions){
        self.functions = functions
    }
    
    public func render(tokens: [TemplateToken]) -> String{
        tokens.map({ token  in
            switch token.type {
            case .text(let content):
                return content
            case .mustache(let mustache): break
                
            }
            return ""
        }).joined()
        
    }
}
