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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logLabel.text = ""
    }

    @IBAction func clearAll(sender: AnyObject) {
        displayValue = 0
        logLabel.text = ""
        operandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        println("digit = \(digit)")
        addLogMessage(digit)
        
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
        
        let operation = sender.currentTitle!
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "∏": performOperation(M_PI)
        default:break
        }
        
        addLogMessage(operation)
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operand: Double) {
        displayValue = operand
        enter()
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
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

