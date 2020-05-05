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

        firstPinView.layoutDirection = .rtl
        firstPinView.inputAccessoryView = getInputAccessoryView()
        firstPinView.onSettingStyle = {

            UnderlineStyle(textColor: .white, lineColor: .white, lineWidth: 2)
        }

        firstPinView.validator = validator(_:)
        
        secondPinView.onSettingStyle = {

            BorderStyle(
                textColor: .white,
                borderWidth: 2,
                backgroundColor: .clear,
                selectedBackgroundColor: UIColor(named: "selection")!)
        }

        secondPinView.onComplete = { code, pinView in

            if code != "1111" { pinView.isError = true }
        }

        secondPinView.validator = validator(_:)
    }
    
    private func validator(_ code: String) -> Bool {
        
        return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
    }
    
    private func getInputAccessoryView() -> UIView {
        let size = CGSize(width: view.frame.width, height: .greatestFiniteMagnitude)
        let frame = CGRect(origin: .zero, size: size)
        let toolbar = UIToolbar(frame: frame)
        let toolbarDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidTap))
        toolbar.setItems([toolbarDoneButton], animated: true)
        toolbar.sizeToFit()
        return toolbar
    }
    
    @objc private func doneButtonDidTap() {
        print(firstPinView.code)
        firstPinView.endEditing(true)
    }
    
}

