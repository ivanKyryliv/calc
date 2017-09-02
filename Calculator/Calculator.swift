//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by іван on 13.08.17.
//  Copyright © 2017 ivan. All rights reserved.
//

import Foundation

func factorial(op1: Double) -> Double {
    if (op1 <= 1) {
        return 1
    }
    return op1 * factorial(op1: op1 - 1.0)
}

struct Calculator {
    
    private var accumulator: Double?
    private var descriptionAccumulator: String?
    private var blind :(accumulator: Double? , descriptionAccumulator: String? )
    
    var description: String? {
        get {
            if pendingBinaryOperation == nil {
                return descriptionAccumulator
            } else {
                return pendingBinaryOperation!.descriptionFunction(
                    pendingBinaryOperation!.descriptionOperand, blind.descriptionAccumulator ?? "" )
            }
        }
    }
    
    var result: Double? {
        get {
            return blind.accumulator
        }
    }
    
    var resultItIsPendin: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private enum Operation {
        case nullaryOperation (() -> Double, String)
        case constant(Double)
        case unaryOperation((Double) -> Double, ((String) -> String)?)
        case binaryOperation((Double, Double) -> Double, ((String, String) -> String)?)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "Ran": Operation.nullaryOperation(drand48, "rand()"),
        "π":Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "ln": Operation.unaryOperation(log, nil),
        "√":Operation.unaryOperation(sqrt, nil),
        "±":Operation.unaryOperation({-$0},nil),
        "cos": Operation.unaryOperation(cos, nil),
        "sin": Operation.unaryOperation(sin,nil),
        "tan": Operation.unaryOperation(tan,nil),
        "sin⁻¹": Operation.unaryOperation(asin, nil),
        "cos⁻¹": Operation.unaryOperation(acos, nil),
        "tan⁻¹": Operation.unaryOperation(atan, nil),
        "x²": Operation.unaryOperation({$0 * $0}, { "(" + $0 + ")⁻¹"}),
        "x⁻¹": Operation.unaryOperation({1 / $0}, { "(" + $0 + ")²"}),
        "10ˣ" : Operation.unaryOperation(({ pow(10, $0) }),nil),
        "xʸ": Operation.binaryOperation(pow, { $0 + " ^ " + $1 }),
         "x!" : Operation.unaryOperation(factorial, { "(" + $0 + ")!"}),
        "+" : Operation.binaryOperation({$0 + $1},nil),
        "-" : Operation.binaryOperation({$0 - $1},nil),
        "×" : Operation.binaryOperation({$0 * $1},nil),
        "÷" : Operation.binaryOperation({$0 / $1},nil),
        "=": Operation.equals,
    ]
    
    mutating func setOperand (_ operand: Double){
        blind.accumulator = operand
        if let value = blind.accumulator {
            blind.descriptionAccumulator = formatter.string(from: NSNumber(value:value)) ?? ""
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .nullaryOperation(let function, let descriptionValue):
                blind = (function(), descriptionValue)
                
            case .constant(let value):
                blind = (value,symbol)
                
            case .unaryOperation (let function, var descriptionFunction):
                if blind.accumulator != nil {
                    blind.accumulator = function (blind.accumulator!)
                    if  descriptionFunction == nil{
                        descriptionFunction = {symbol + "(" + $0 + ")"}
                    }
                    blind.descriptionAccumulator = descriptionFunction!(blind.descriptionAccumulator!)
                }
            case .binaryOperation (let function, var descriptionFunction):
                performPendingBinaryOperation()
                if blind.accumulator != nil {
                    if  descriptionFunction == nil{
                        descriptionFunction = {$0 + " " + symbol + " " + $1}
                    }
                    
                    pendingBinaryOperation = PendingBynaryOperation (function: function,
                                                                     firstOperand: blind.accumulator!,
                                                                     descriptionFunction: descriptionFunction!,
                                                                     descriptionOperand: blind.descriptionAccumulator!)
                    blind = (nil, nil)
                }
            case .equals:
                performPendingBinaryOperation()
                
            }
        }
    }
    private mutating func  performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && blind.accumulator != nil {
            
            blind.accumulator =  pendingBinaryOperation!.perform(with: blind.accumulator!)
            blind.descriptionAccumulator =
                pendingBinaryOperation!.performDescription(with: blind.descriptionAccumulator!)
            
            pendingBinaryOperation = nil
        }
    }
    private var pendingBinaryOperation: PendingBynaryOperation?
    
    private struct PendingBynaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
        func perform (with secondOperand: Double) -> Double {
            return function (firstOperand, secondOperand)
        }
        
        func performDescription (with secondOperand: String) -> String {
            return descriptionFunction ( descriptionOperand, secondOperand)
        }
    }
    
    mutating func clear() {
        blind = (nil, " ")
        pendingBinaryOperation = nil
    }
}

