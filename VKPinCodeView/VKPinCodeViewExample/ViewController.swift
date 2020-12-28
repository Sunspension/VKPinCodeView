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

    @IBOutlet weak var secureButton: UIButton! {
        
        didSet {
            
            secureButton.layer.shadowRadius = 9
            secureButton.layer.shadowOpacity = 0.5
            secureButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        }
    }
    
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

        firstPinView.onSetupStyle = { _ in

            UnderlineStyle(textColor: .white, lineColor: .white, lineWidth: 2)
        }
        
        firstPinView.settings = VKPinCodeViewSettings(inputValidator: validator(_:))
        
        secondPinView.onSetupStyle = { _ in

            BorderStyle(
                textColor: .white,
                borderWidth: 2,
                backgroundColor: .clear,
                selectedBackgroundColor: UIColor(named: "selection")!)
        }

        secondPinView.onComplete = { code, pinView in
            
            if code != "1111" { pinView.isError = true }
        }
        
        secondPinView.settings = VKPinCodeViewSettings(inputValidator: validator(_:))
    }
    
    private func validator(_ code: String) -> Bool {
        
        return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
    }
    
    @IBAction private func secureAction(_ sender: Any) {
        
        firstPinView.isSecureEntry.toggle()
        secureButton.isSelected = firstPinView.isSecureEntry
    }
}

