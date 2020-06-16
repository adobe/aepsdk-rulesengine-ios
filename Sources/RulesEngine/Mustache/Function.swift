//
//  Function.swift
//  Swift-Rules
//
//  Created by Jiabin Geng on 5/19/20.
//  Copyright © 2020 Adobe. All rights reserved.
//

import Foundation
public typealias Function = (Any?) -> Any?

public class Functions{
    
    var functions:[String:Function] = [:]
    
    public init(){
        
    }
    
    public func evaluate(name:String, parameter:Any?) -> Any? {
        let function = functions[name]
        
        guard let function_ = function else{
//            return .failure(RulesFailure.missingOperator(message: "Function not defined for \(name)"))
            return nil
        }
        return  function_(parameter)
        
    }
    
    public func register(name:String, function :@escaping Function){
        functions[name] = function
    }
}

