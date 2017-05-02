//
//  CalculatorViewController.swift
//  APCalculator
//
//  Created by Abrar Peer on 12/02/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var userHasTypedDecimal: Bool = false {
        
        willSet {
            
            self.decimalButton.isEnabled = !newValue
            
        }
        
    }
    
    var brain = CalculatorBrain()
    
    //Computed Property
    var displayValue: Double {
        
        get {
            
            return NumberFormatter().number(from: display.text!)!.doubleValue
            
        }
        
        //hardly gets called
        set {
            
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
        }
        
        
    }
    
    var history: String = "History:"
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var historyLabel: UILabel!
    
    @IBOutlet weak var decimalButton: UIButton!
    
    @IBAction func appendDigit(_ sender: UIButton) {
        
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
                
                display.text = display.text! + "\(Double.pi)"
                
            } else {
                
                display.text = "\(Double.pi)"
                
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
        
        //operandStack.append(displayValue)
        
        //log.debug("Operand Stack = \(operandStack)")
        
        if let result = brain.pushOperand(operand: displayValue) {
            
            displayValue = result
            
        } else {
            
            //TODO: handle nil case
            
            displayValue = 0
            
        }
        
        if let resultHistory = brain.history()  {
            
            historyLabel.text = resultHistory
            
        } else {
            
            historyLabel.text = "No History"
        }
        
        log.debug("Finished!")
        
    }
    
    @IBAction func operate(_ sender: UIButton) {
        
        log.debug("Started!")
        
        if userIsInTheMiddleOfTypingANumber {
            
            enter()
            
        }
        
        if let operation = sender.currentTitle {
            
            if let result = brain.performOperation(symbol: operation) {
                
                displayValue = result
            
            } else {
                
                //TODO: handle nil case
                
                displayValue = 0
                
            }
            
        }
        
        if let resultHistory = brain.history()  {
            
            historyLabel.text = resultHistory
            
        } else {
            
            historyLabel.text = "No History"
        }

        
        log.debug("Finished!")
        
    }
    
    @IBAction func cancel() {
        
        log.debug("Started!")
        
        userIsInTheMiddleOfTypingANumber = false
        userHasTypedDecimal = false
        
        brain.clearOpStack()
        
        display.text = "0"
        
        log.debug("Finished!")
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
