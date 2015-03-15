//
//  ViewController.swift
//  Calculator
//
//  Created by chenjs on 15/3/14.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logLabel.text = ""
    }

    @IBAction func clearAll(sender: AnyObject) {
        displayValue = 0
        logLabel.text = ""
        brain.reset()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." &&  display.text!.rangeOfString(".") != nil {
                println("Invalid .")
            } else {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
            
            addLogMessage(operation)
        }
    }
    
    func performOperation(operand: Double) {
        displayValue = operand
        enter()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        addLogMessage("\(displayValue)")
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    func addLogMessage(msg: String) {
        logLabel.text = logLabel.text! + msg + " "
    }
}

