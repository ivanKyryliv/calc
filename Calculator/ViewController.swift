//
//  ViewController.swift
//  Calculator
//
//  Created by іван on 13.08.17.
//  Copyright © 2017 ivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var tochka: UIButton! {
        didSet {
            tochka.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    
    @IBAction func pulsButton(_ sender: UIButton) {
        sender.pulsate()
    }
    
    let decimalSeparator = formatter.decimalSeparator ?? "."
    var userIsStillTyping = false
    private var calculator = Calculator()
    var dotIsPlased = false
    
    var displayValue: Double? {
        get {
            if let text = display.text , let value = Double(text) {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                display.text = formatter.string(from: NSNumber(value:value))
            }
        }
    }
    
    //MARK: - ABActions
    @IBAction func touchDigitButton(_ sender: UIButton){
        let digitButton = sender.currentTitle!
        // print("\(digitButton) button pressed")
        if userIsStillTyping {
            let textCurrentlyInDisplay = display.text!
            
            if((display.text?.characters.count)! < 20  ) {
                
                if (digitButton != decimalSeparator) || !(textCurrentlyInDisplay.contains(decimalSeparator)) {
                    if(digitButton == "0") && ((display.text == "0") || (display.text == "-0")) { return}
                    
                    if(digitButton != decimalSeparator) && ((display.text == "0") || (display.text == "-0"))
                    {
                        self.display.text = digitButton ; return
                    }
                    display.text = textCurrentlyInDisplay + digitButton
                }
            }
            
        } else {
            display.text = "." == digitButton ? "0." : digitButton
            userIsStillTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsStillTyping {
            if let value = displayValue {
                calculator.setOperand(value)
            }
            userIsStillTyping = false
        }
        
        if let mathenaticalSymbol = sender.currentTitle {
            
            calculator.performOperation(mathenaticalSymbol)
        }
        displayValue = calculator.result
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        calculator.clear()
        displayValue = 0
        userIsStillTyping = false
    }
    
    @IBAction func backspaseButton(_ sender: UIButton) {
        guard userIsStillTyping && !display.text!.isEmpty else { return }
        display.text = String (display.text!.characters.dropLast())
        if display.text!.isEmpty{
            displayValue = 0
        }
    }
}

