//
//  ViewController.swift
//  VKPinCodeViewExample
//
//  Created by Vladimir Kokhanevich on 22/02/2019.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstContainer: ShadowView!
    
    @IBOutlet weak var secondContainer: ShadowView!
    
    @IBOutlet weak var firstPinView: VKPinCodeView!
    
    @IBOutlet weak var secondPinView: VKPinCodeView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        firstContainer.layer.cornerRadius = 20
        secondContainer.layer.cornerRadius = 20
        setupPinViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    private func setupPinViews() {
        
        let underline = VKEntryViewStyle.underline(
            font: UIFont.systemFont(ofSize: 22, weight: .medium),
            textColor: .white,
            errorTextColor: .red,
            lineWidth: 2,
            lineColor: .white,
            selectedLineColor: .lightGray,
            errorLineColor: .red)
        
        firstPinView.setStyle(underline)
        firstPinView.validator = validator(_:)
        
        let borderStyle = VKEntryViewStyle.border(
            font: UIFont.systemFont(ofSize: 22, weight: .medium),
            textColor: .white,
            errorTextColor: .red,
            cornerRadius: 10,
            borderWidth: 2,
            borderColor: .white,
            selectedBorderColor: .lightGray,
            errorBorderColor: .red,
            backgroundColor: .clear,
            selectedBackgroundColor: UIColor(named: "selection")!)
        
        secondPinView.setStyle(borderStyle)
        secondPinView.onComplete = { code in
            
            if code != "1111" { self.secondPinView.isError = true }
        }
        
        secondPinView.validator = validator(_:)
    }
    
    private func validator(_ code: String) -> Bool {
        
        return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
    }
}

