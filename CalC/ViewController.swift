//
//  ViewController.swift
//  CalC
//
//  Created by Utsav Parikh on 2/7/16.
//  Copyright (c) 2016 Utsav Parikh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // UI Set-up
    @IBOutlet var resultField: UITextField!
    @IBOutlet var btnClear: UIButton!
    @IBOutlet var bntEqualTo: UIButton!
    @IBOutlet var btnAddition: UIButton!
    @IBOutlet var btnSubtraction: UIButton!
    @IBOutlet var btnMultiplication: UIButton!
    @IBOutlet var btnDivision: UIButton!
    @IBOutlet var btnDecimalPoint: UIButton!
    
    @IBOutlet var btn0: UIButton!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    @IBOutlet var btn6: UIButton!
    @IBOutlet var btn7: UIButton!
    @IBOutlet var btn8: UIButton!
    @IBOutlet var btn9: UIButton!
    
    @IBAction func btn0Press(sender: UIButton) {
        handleInputString("0")
    }
    @IBAction func btn1Press(sender: UIButton) {
        handleInputString("1")
    }
    @IBAction func btn2Press(sender: UIButton) {
        handleInputString("2")
    }
    @IBAction func btn3Press(sender: UIButton) {
        handleInputString("3")
    }
    @IBAction func btn4Press(sender: UIButton) {
        handleInputString("4")
    }
    @IBAction func btn5Press(sender: UIButton) {
        handleInputString("5")
    }
    @IBAction func btn6Press(sender: UIButton) {
        handleInputString("6")
    }
    @IBAction func btn7Press(sender: UIButton) {
        handleInputString("7")
    }
    @IBAction func btn8Press(sender: UIButton) {
        handleInputString("8")
    }
    @IBAction func btn9Press(sender: UIButton) {
        handleInputString("9")
    }

    //Variables Set-up
    var calcVal: Double = 0.0 // Store the calculated value here
    var inputData = "" // User-entered digits
    
    var numberStack: [Double] = [] // Number stack
    var operatorStack: [String] = [] // Operator stack

    // Looks for a single character in a string.
    func hasIndex(stringToSearch str: String, characterToFind chr: Character) -> Bool {
        for c in str.characters {
            if c == chr {
                return true
            }
        }
        return false
    }
    
    func handleInputString(str: String) {
        if str == "-" {
            if inputData.hasPrefix(str) {
                // Strip off the first character (a dash)
                inputData = inputData.substringFromIndex(inputData.startIndex.successor())
            } else {
                inputData = str + inputData
            }
        } else {
            inputData += str
        }
        calcVal = Double((inputData as NSString).doubleValue)
        updateCalculatorDisplay()
    }
    
    func deleteInputString() {
        if inputData.characters.count > 0 {
            inputData = inputData.substringToIndex(inputData.endIndex.predecessor())
        }
        calcVal = Double((inputData as NSString).doubleValue)
        updateCalculatorDisplay()
    }
    
    func updateCalculatorDisplay() {
        // If the value is an integer, don't show a decimal point
        let intCalcVal = Int64(calcVal)
        if calcVal - Double(intCalcVal) == 0 {
            resultField.text = "\(intCalcVal)"
        } else {
            resultField.text = "\(calcVal)"
        }
    }
    
    func doOperation(newOp: String) {
        if inputData != "" && !numberStack.isEmpty {
            let stackOp = operatorStack.last
            if !((stackOp == "+" || stackOp == "-") && (newOp == "*" || newOp == "/")) {
                let oper = operation[operatorStack.removeLast()]
                calcVal = oper!(numberStack.removeLast(), calcVal)
                doEqualTo()
            }
        }
        operatorStack.append(newOp)
        numberStack.append(calcVal)
        inputData = ""
        updateCalculatorDisplay()
    }
    
    func doEqualTo() {
        if inputData == "" {
            return
        }
        if !numberStack.isEmpty {
            let oper = operation[operatorStack.removeLast()]
            calcVal = oper!(numberStack.removeLast(), calcVal)
            if !operatorStack.isEmpty {
                doEqualTo()
            }
        }
        updateCalculatorDisplay()
        inputData = ""
    }
    
    @IBAction func btnDeletePress(sender: UIButton) {
        deleteInputString()
    }
    
    @IBAction func btnDecPress(sender: UIButton) {
        if hasIndex(stringToSearch: inputData, characterToFind: ".") == false {
            handleInputString(".")
        }
    }
    
    @IBAction func btnPlusMinusPress(sender: UIButton) {
        if inputData.isEmpty {
            inputData = resultField.text!
        }
        handleInputString("-")
    }
    
    @IBAction func btnACPress(sender: UIButton) {
        inputData = ""
        calcVal = 0
        updateCalculatorDisplay()
        numberStack.removeAll()
        operatorStack.removeAll()
    }
    
    @IBAction func btnPlusPress(sender: UIButton) {
        doOperation("+")
    }
    
    @IBAction func btnMinusPress(sender: UIButton) {
        doOperation("-")
    }
    
    @IBAction func btnMultiplyPress(sender: UIButton) {
        doOperation("*")
    }
    
    @IBAction func btnDividePress(sender: UIButton) {
        doOperation("/")
    }
    
    @IBAction func btnSquareRootPress(sender: UIButton) {
        if(calcVal >= 0)
        {
            calcVal = sqrt(calcVal)
            if(!inputData.isEmpty)
            {
                inputData = inputData.substringToIndex(inputData.endIndex.predecessor())
            }
            updateCalculatorDisplay()
        }
        
    }
    
    @IBAction func btnEqualsPress(sender: UIButton) {
        doEqualTo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultField.font = UIFont.systemFontOfSize(50)
        resultField.layer.sublayerTransform = CATransform3DMakeTranslation(-4, 0, 0);

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

func addition(a: Double, b: Double) -> Double {
    let answer = a + b
    return answer
}
func subtraction(a: Double, b: Double) -> Double {
    let answer = a - b
    return answer
}
func multiplication(a: Double, b: Double) -> Double {
    let answer = a * b
    return answer
}
func division(a: Double, b: Double) -> Double {
    let answer = a / b
    return answer
}

typealias Binaryop = (Double, Double) -> Double
let operation: [String: Binaryop] = [ "+" : addition, "-" : subtraction, "*" : multiplication, "/" : division ]

