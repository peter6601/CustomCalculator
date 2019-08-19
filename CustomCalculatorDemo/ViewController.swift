//
//  ViewController.swift
//  CustomCalculatorDemo
//
//  Created by DinDin on 2019/8/17.
//  Copyright © 2019 DinDin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfMain: UITextField!
    
    @IBOutlet weak var llResult: UILabel!
    
    @IBAction func tapButton(_ sender: UIButton) {
       llResult.text = setInput(tfMain.text ?? "")
    }
    
    var brain: CalculatorBrain = CalculatorBrain()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setInput(_ text: String) -> String {
        do {
            let result = try brain.calculateText(text)
            return String(result)
        } catch  {
            return "Error"
        }
    }


}



enum CalculatorToken {
    case number(Double)
    case op(String)
}

enum ParserError: Error {
    case someError
}


struct CalculatorBrain {
    
    
    func calculateText(_ intput: String) throws ->  Double {
       let list =  scanInput(intput)
        return try calculatList(list)
    }
    
    func scanInput(_ input: String)-> [CalculatorToken] {
        var list = [CalculatorToken]()
        let scanner: Scanner =  Scanner.init(string: input)
        while scanner.isAtEnd == false {
            if let c = scanner.scanCharacters(from: CharacterSet(charactersIn: "+-x/")) {
                list.append(.op(c))
            } else if let num = scanner.scanDouble() {
                list.append(.number(num))
            }
        }
        return list
    }
    
    func calculatList(_ tokens: [CalculatorToken]) throws -> Double {
        guard case var CalculatorToken.number(v) = tokens[0] else { throw ParserError.someError}
        
        var lastToken = tokens[0]
        
        for token in tokens[1...] {
            switch token {
            case .number(let d):
                switch lastToken {
                case .number(_):
                    throw ParserError.someError
                case .op(let c):
                    switch c {
                    case "+":
                        v += d
                    case "-":
                        v -= d
                    case "x":
                        v *= d
                    case "/":
                        v /= d
                    default:
                        break
                    }
                }
                
            case .op(_):
                switch lastToken {
                case .op(_):
                    throw ParserError.someError
                case .number(_):
                    break
                }
            }
           lastToken = token
        }
        return v
    }
}
