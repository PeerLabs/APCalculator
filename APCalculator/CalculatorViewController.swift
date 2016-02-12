//
//  CalculatorViewController.swift
//  APCalculator
//
//  Created by Abrar Peer on 12/02/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit
import XCGLogger

class CalculatorViewController: UIViewController {
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var operandStack = [Double]()
    
    var displayValue: Double {
        
        get {
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        
        set {
            
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
        }
        
    }
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        
        log.debug("Started!")
        
        let digit = sender.currentTitle!
        
        log.debug("Digit = \(digit)")
        
        if userIsInTheMiddleOfTypingANumber {
            
            display.text = display.text! + digit
            
        } else {
            
            display.text = digit
            
            userIsInTheMiddleOfTypingANumber = true
            
        }

        log.debug("Finished!")
        
    }
    
    @IBAction func enter() {
       
        log.debug("Started!")
        
        userIsInTheMiddleOfTypingANumber = false
        
        operandStack.append(displayValue)
        
        log.debug("Operand Stack = \(operandStack)")
        
        log.debug("Finished!")
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        log.debug("Started!")
        
        let operation = sender.currentTitle!
        
        switch operation {
            
        case "×": performOperation{ $0 * $1 }
        case "÷": performOperation{ $1 / $0 }
        case "−": performOperation{ $1 - $0 }
        case "+": performOperation{ $0 + $1 }
        case "√": performUrinaryOperation{sqrt($0)}
        
        default: break
            
        }
        
        log.debug("Finished!")
        
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        
        if operandStack.count >= 2 {
            
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
            
        }
        
    }
    
    func performUrinaryOperation(operation: Double -> Double) {
        
        if operandStack.count >= 1 {
            
            displayValue = operation(operandStack.removeLast())
            enter()
            
        }

    }

    override func viewDidLoad() {
        
        log.debug("Started!")
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        log.debug("Finished!")

    }

    override func didReceiveMemoryWarning() {
        
        log.debug("Started!")
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        log.debug("Finished!")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
