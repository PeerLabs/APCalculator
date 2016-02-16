//
//  CalculatorBrain.swift
//  APCalculator
//
//  Created by Abrar Peer on 14/02/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : CustomStringConvertible {
        
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, (Double, Double) -> Double)
        
        var description: String {
            
            get {
                
                switch self {
                    
                case .Operand(let operand):
                    
                    return "\(operand)"
                    
                case .UnaryOperation(let symbol, _):
                    
                    return symbol
                    
                case .BinaryOperation(let symbol, _, _):
                    
                    return symbol

                }
                
            }
        
        }
        
        
        var precedence: Int {
            
            get {
                
                switch self {
                    
                case .BinaryOperation(_, let precedence, _):
                    
                    return precedence
                
                default:
                    
                    return Int.max
                
                }
            
            }
        
        }
        
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init() {
        
        log.debug("Started!")
        
        knownOps["×"] = Op.BinaryOperation("×", 2, *)
        knownOps["÷"] = Op.BinaryOperation("÷", 2, {$1 / $0})
        knownOps["+"] = Op.BinaryOperation("+", 1, +)
        knownOps["−"] = Op.BinaryOperation("−", 1, {$1 - $0})
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["Sin"] = Op.UnaryOperation("Sin", sin)
        knownOps["Cos"] = Op.UnaryOperation("Cos", cos)
        
        log.debug("Finished!")
        
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        log.debug("Started!")
        
        if !ops.isEmpty {
            
            var remainingOps = ops
            
            let op = remainingOps.removeLast()
            
            switch op {
                
            case Op.Operand(let operand):
                
                log.debug("Finished!")
                
                return (operand, remainingOps)
                
            case Op.UnaryOperation(_, let operation):
                
                let operandEvaluation = evaluate(remainingOps)
                
                if let operand = operandEvaluation.result {
                    
                    log.debug("Finished!")
                    
                    return (operation(operand), operandEvaluation.remainingOps)
                    
                }
                
            case Op.BinaryOperation(_, _, let operation):
                
                let op1Evaluation = evaluate(remainingOps)
                
                if let op1 = op1Evaluation.result {
                    
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    
                    if let op2 = op2Evaluation.result {
                        
                        log.debug("Finished!")
                        
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                        
                    }
                    
                }
                
                
            }
            
        }

        log.debug("Finished!")
        
        return (nil, ops)
        
    }
    
    func evaluate() -> Double? {
        
        log.debug("Started!")
        
        let (result, remainder) = evaluate(opStack)
        
        log.debug("DEBUG OUTPUT: OPSTACK \(opStack) = \(result) with \(remainder) left over")
        
        log.debug("Finished!")
        
        return result
        
    }

    func pushOperand(operand: Double) -> Double? {
        
        log.debug("Started!")
        
        opStack.append(Op.Operand(operand))
        
        log.debug("Finished!")
        
        return evaluate()
        
    }
    
    func performOperation(symbol: String) -> Double? {
        
        log.debug("Started!")
        
        if let operation = knownOps[symbol] {
            
            opStack.append(operation)
            
        }
        
        log.debug("Finished!")
        
        return evaluate()
        
    }
    
    func clearOpStack() {
        
        log.debug("Started!")
        
        opStack.removeAll()
        
        log.debug("Finished!")
        
    }

//    private func opStackHistory(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
//        
//        log.debug("Started!")
//        
//        if !ops.isEmpty {
//            
//            var remainingOps = ops
//            
//            let op = remainingOps.removeLast()
//            
//            switch op {
//                
//            case Op.Operand(let operand):
//                
//                if remainingOps.isEmpty {
//                    
//                    log.debug("History for '\(ops)' is (result: \(operand), remainingOps: \(remainingOps))")
//                    
//                    log.debug("Finished!")
//                    
//                    return ("\(operand)", remainingOps)
//                    
//                } else {
//                    
//                    let remainingOps2 = remainingOps
//                    
//                    log.debug("History for '\(ops)' is (result: \(opStackHistory(remainingOps2).result!), \(operand), remainingOps: \(opStackHistory(remainingOps2).remainingOps))")
//                    
//                    log.debug("Finished!")
//                    
//                    return ("\(opStackHistory(remainingOps2).result!), \(operand)", opStackHistory(remainingOps2).remainingOps)
//                    
//                }
//                
//                
//            case Op.UnaryOperation(let symbol, _):
//                
//                let opStackHistoryResults = opStackHistory(remainingOps)
//                
//                if let operand = opStackHistoryResults.result {
//                    
//                    log.debug("History for '\(ops)' is (result: \(symbol)(\(operand)), remainingOps: \(remainingOps))")
//                    
//                    log.debug("Finished!")
//                    
//                    return ("\(symbol)(\(operand))", opStackHistoryResults.remainingOps)
//                    
//                }
//                
//            case Op.BinaryOperation(let symbol, _):
//                
//                if remainingOps.count == 2 {
//                
//                    let op1 = remainingOps.removeLast()
//                
//                    let op2 = remainingOps.removeLast()
//                    
//                    log.debug("History for '\(ops)' is (result: (\(op1) \(symbol) \(op2)) , remainingOps: \(remainingOps))")
//                    
//                    log.debug("Finished!")
//                    
//                    return ("(\(op1) \(symbol) \(op2))", remainingOps)
//                    
//                } else {
//                    
//                    let op1HistoryResults = opStackHistory(remainingOps)
//                    
//                    if let op1 = op1HistoryResults.result {
//                        
//                        let op2HistoryResults = opStackHistory(op1HistoryResults.remainingOps)
//                        
//                        if let op2 = op2HistoryResults.result {
//                            
//                            log.debug("History for '\(ops)' is (result: (\(op1) \(symbol) \(op2)) , remainingOps: \(op2HistoryResults.remainingOps))")
//                            
//                            log.debug("Finished!")
//                            
//                            return ("(\(op1) \(symbol) \(op2))", op2HistoryResults.remainingOps)
//                            
//                        }
//                    
//                    }
//                    
//                }
//                
//            }
//            
//        }
//        
//        log.debug("Finished!")
//        
//        return (nil, ops)
//        
//    }
    
    private func history(ops: [Op]) -> (result: String, remainingOps: [Op], precedence: Int) {
        
        log.debug("Started!")
        
        if !ops.isEmpty {
            
            log.debug("Calculating History OPSTACK: \(ops)")
            
            var remainingOps = ops
            
            let op = remainingOps.removeLast()
            
            switch op {
                
            case .Operand(let operand):
                
                log.debug("Finished!")
                
                return (operand.description, remainingOps, op.precedence)
                
            case .UnaryOperation(let symbol, _):
                
                let (result, remainingOps, _) = history(remainingOps)
                
                log.debug("Finished!")
                
                return (symbol + "(" + result + ")", remainingOps, op.precedence)
                
            case .BinaryOperation(let symbol, let precedence, _):
                
                let history1 = history(remainingOps)
                let history2 = history(history1.remainingOps)
                
                var result1 = history1.result
                var result2 = history2.result
                
                if (precedence > history1.precedence) {
                    
                    result1 = "(" + result1 + ")"
                    
                }
                
                if (precedence > history2.precedence) {
                    
                    result2 = "(" + result2 + ")"
                    
                }
                
                log.debug("Finished!")
                
                return (result2 + " " + symbol + " " + result1, history2.remainingOps, precedence)
                
            }
            
        } else {
            
            log.debug("Finished!")
            
            return ("?", ops, Int.max)
            
        }
        
    }
    
    func history() -> String? {
        
        log.debug("Started!")
        
        if opStack.isEmpty {
            
            log.debug("Finished!")
            
            return nil
        
        } else {
            
            log.debug("Finished!")
            
            return history(opStack).result
            
        }
        
    }
    
}