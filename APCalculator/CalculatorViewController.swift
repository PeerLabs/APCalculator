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
    
    var userHasTypedDecimal: Bool = false {
        
        willSet {
            
            self.decimalButton.enabled = !newValue
            
        }
        
    }

    
    var operandStack = [Double]()
    
    
    //Computed Property
    var displayValue: Double {
        
        get {
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        
        //hardly gets called
        set {
            
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
        }
        
        
    }
    
    var history: String = "History:"
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var decimalButton: UIButton!
    
    @IBAction func appendDigit(sender: UIButton) {
        
        log.debug("Started!")
        
        let digit = sender.currentTitle!
        
        log.debug("Digit \(digit) Pressed!")
        
        switch digit {
    
        case ".":
            
            if !userHasTypedDecimal {
            
                userHasTypedDecimal = true
            
            }
            
            if !userIsInTheMiddleOfTypingANumber {
                
                display.text = "0" + digit
                
                userIsInTheMiddleOfTypingANumber = true
                
            } else {
                
                display.text = display.text! + digit
                
            }
            
        case "∏":
            
            if userIsInTheMiddleOfTypingANumber {
                
                display.text = display.text! + "\(M_PI)"
                
            } else {
                
                display.text = "\(M_PI)"
                
                userIsInTheMiddleOfTypingANumber = true
                
            }


        default:
            
            if userIsInTheMiddleOfTypingANumber {
                
                display.text = display.text! + digit
                
            } else {
                
                display.text = digit
                
                userIsInTheMiddleOfTypingANumber = true
                
            }
            
        }
        
        log.debug("Display Value: \(displayValue)")
        
        log.debug("Finished!")
        
    }
    
    @IBAction func enter() {
       
        log.debug("Started!")
        
        userIsInTheMiddleOfTypingANumber = false
        userHasTypedDecimal = false
        
        operandStack.append(displayValue)
        
        log.debug("Operand Stack = \(operandStack)")
        
        log.debug("Finished!")
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        log.debug("Started!")
        
        if userIsInTheMiddleOfTypingANumber {
            
            enter()
            
        }
        
        let operation = sender.currentTitle!
        
        switch operation {
            
        case "×": performOperation{ $0 * $1 }
        case "÷": performOperation{ $1 / $0 }
        case "−": performOperation{ $1 - $0 }
        case "+": performOperation{ $0 + $1 }
        case "√": performUrinaryOperation{sqrt($0)}
        case "Sin": performUrinaryOperation{sin($0)}
        case "Cos": performUrinaryOperation{cos($0)}
        
        default: break
            
        }
        
        log.debug("Finished!")
        
    }
    
    @IBAction func cancel() {
        
        log.debug("Started!")
        
        userIsInTheMiddleOfTypingANumber = false
        userHasTypedDecimal = false
        
        operandStack.removeAll()
        
        display.text = "0"
        
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
