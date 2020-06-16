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

public protocol ConditionExpression {
    func resolve(in context: Context) -> Result<Bool, RulesFailure>
}


@dynamicCallable
public enum Operand<T>{
    case none
    case some(T)
    case template(Resolvable)
    
    func dynamicallyCall(withArguments args: [Context]) ->  T?{
        switch self {
        case .none:
            return nil
        case .some(let value):
            return value
        case .template(let template):
            if let result = template.resolve(in: args[0]) {
                return result as? T
            }
            return nil
        }
    }
}


extension Operand: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "<None>"
        case .some(let value):
            return "<Value:\(value)>"
        case .template(let mustache):
            return "<Template:\(mustache)>"
        }
    }
}


public struct ConjunctionExpression:ConditionExpression {
    public let operands:[ConditionExpression]
    public let operationName:String
    
    public init(operationName:String, operands:ConditionExpression...){
        self.operands = operands
        self.operationName = operationName
    }
    
    public init(operationName:String, operands:[ConditionExpression]){
        self.operands = operands
        self.operationName = operationName
    }
    
    public  func resolve(in context: Context) -> Result<Bool, RulesFailure>{
        let operandsResolve = operands.map { conditionExpression in
            conditionExpression.resolve(in: context)
        }
        
        switch operationName {
        case "and":
            if operandsResolve.contains(where: {!$0.value}) {
                return Result.failure(.innerFailures(message: "`And` returns false", errors:  operandsResolve.filter{ !$0.value}.map{ $0.error!}))
            }
            return .success(true)
        case "or":
            if operandsResolve.contains(where: {$0.value}) {
                return .success(true)
            }
            return Result.failure(.innerFailures(message: "`Or` returns false", errors:  operandsResolve.filter{ !$0.value}.map{ $0.error ?? RulesFailure.unknown}))
        default:
            return .failure(.missingOperator(message: "Unkonwn conjunction operator"))
        }
        
    }
}

public class UnaryExpression<A>:ConditionExpression{
    let lhs:Operand<A>
    let operationName:String
    
    public init(lhs:Operand<A>, operationName:String){
        self.lhs = lhs
        self.operationName = operationName
    }
    
    public func resolve(in context: Context) -> Result<Bool, RulesFailure>{
        let resolvedLhs = lhs(context)
        if let resolvedLhs_ = resolvedLhs{
            return context.evaluator.evaluate(operation: operationName, lhs: resolvedLhs_)
        }
        return context.evaluator.evaluate(operation: operationName, lhs: resolvedLhs)
    }
    
}

public class ComparisonExpression<A,B>:ConditionExpression{
    let lhs:Operand<A>
    let rhs:Operand<B>
    let operationName:String
    
    public init(lhs:Operand<A>, operationName:String, rhs:Operand<B>){
        self.lhs = lhs
        self.rhs = rhs
        self.operationName = operationName
    }
    
    public func resolve(in context: Context) -> Result<Bool, RulesFailure>{
        let resolvedLhs = lhs(context)
        let resolvedRhs = rhs(context)
        var result : Result<Bool, RulesFailure>
        if let resolvedLhs_ = resolvedLhs, let resolvedRhs_ = resolvedRhs {
            result = context.evaluator.evaluate(operation: operationName, lhs: resolvedLhs_, rhs: resolvedRhs_)
        } else{
            result = context.evaluator.evaluate(operation: operationName, lhs: resolvedLhs, rhs: resolvedRhs)
        }
        switch result {
        case .success(_):
            return result
        case .failure(let error):
            return Result.failure(.innerFailure(message: "Comparison (\(lhs) \(operationName) \(rhs)) returns false", error: error))
        }
        
    }
}
