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
    
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
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
