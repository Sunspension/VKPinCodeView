//
//  VKPinCodeView.swift
//  gpn
//
//  Created by Vladimir Kokhanevich on 20/02/2019.
//  Copyright © 2019 Reksoft. All rights reserved.
//

import UIKit

typealias PinCodeValidator = (_ code: String) -> Bool

@IBDesignable
public class VKPinCodeView: UIView {
    
    private lazy var _stack = UIStackView(frame: bounds)
    
    private lazy var _textField = UITextField(frame: bounds)
    
    private var _code = "" {
        
        didSet { onCodeDidChange?(_code) }
    }
    
    private var _activeIndex: Int {
        
        var index = _code.count
        if index == length { index -= 1 }
        return index
    }
    
    @IBInspectable public var length: Int = 4 {
        
        willSet { createLabels() }
    }
    
    @IBInspectable public var spacing: CGFloat = 16 {
        
        willSet { if newValue != spacing { _stack.spacing = newValue } }
    }
    
    public var font = UIFont.systemFont(ofSize: 22) {
        
        didSet { updateFont() }
    }
    
    public var keyBoardType = UIKeyboardType.numberPad {
        
        willSet { _textField.keyboardType = newValue }
    }
    
    public var isError = false {
        
        didSet { if oldValue != isError { updateErrorState() } }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5 {
        
        didSet { updateCornerRadius() }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1 {
        
        didSet { updateBorderWidth() }
    }
    
    public var inactiveBorderColor = UIColor.red {
        
        didSet { updateInactiveBorderColor() }
    }
    
    public var activeBorderColor = UIColor.lightGray {
        
        didSet { updateActiveBorderColor() }
    }
    
    public var inactiveBackgroundColor = UIColor.white {
        
        didSet { updateInactiveBackgroundColor() }
    }
    
    public var activeBackgroundColor = UIColor.white {
        
        didSet { updateActiveBackgroundColor() }
    }
    
    public var animateActiveBorder = true
    
    public var shakeOnError = true
    
    public var errorBorderColor = UIColor.red
    
    public var errorTextColor = UIColor.red
    
    public var textColor = UIColor.black
    
    public var onComplete: ((_ code: String) -> Void)?
    
    public var onCodeDidChange: ((_ code: String) -> Void)?
    
    public var onBeginEditing: (() -> Void)?
    
    public var validator: PinCodeValidator?
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setup()
    }
    
    
    // MARK: - Overrides
    
    override func prepareForInterfaceBuilder() {
        
        setup()
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        
        _textField.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isError = false
        _textField.becomeFirstResponder()
        highlightActiveLabel(_activeIndex)
    }
    
    // MARK: - Private methods
    private func setup() {
        
        setupTextField()
        setupStackView()
        createLabels()
    }
    
    private func setupStackView() {
        
        _stack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _stack.alignment = .fill
        _stack.axis = .horizontal
        _stack.distribution = .fillEqually
        _stack.spacing = spacing
        addSubview(_stack)
    }
    
    private func setupTextField() {
        
        _textField.keyboardType = keyBoardType
        _textField.isHidden = true
        _textField.delegate = self
        _textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _textField.addTarget(self, action: #selector(self.onTextChanged(_:)), for: .editingChanged)
        
        if #available(iOS 12.0, *) {
            
            _textField.textContentType = .oneTimeCode
        }
        
        addSubview(_textField)
    }
    
    @objc private func onTextChanged(_ sender: UITextField) {
        
        let text = sender.text!
        
        if _code.count > text.count {
            
            deleteChar(text)
            var index = _code.count - 1
            if index < 0 { index = 0 }
            highlightActiveLabel(index)
        }
        else {
            
            appendChar(text)
            let index = _code.count - 1
            highlightActiveLabel(index)
        }
        
        if _code.count == length {
            
            onComplete?(_code)
            _textField.resignFirstResponder()
        }
    }
    
    private func deleteChar(_ text: String) {
        
        let index = text.count
        let previous = _stack.arrangedSubviews[index] as! UILabel
        previous.text = ""
        _code = text
    }
    
    private func appendChar(_ text: String) {
        
        if text.isEmpty { return }
        
        let activeLabel = text.count - 1
        let label = _stack.arrangedSubviews[activeLabel] as! UILabel
        let index = text.index(text.startIndex, offsetBy: activeLabel)
        label.text = String(text[index])
        _code += label.text!
    }
    
    private func highlightActiveLabel(_ activeIndex: Int) {
        
        for i in 0 ..< _stack.arrangedSubviews.count {
            
            let view = _stack.arrangedSubviews[i]
            
            if i == activeIndex {
                
                view.layer.borderColor = activeBorderColor.cgColor
                view.layer.backgroundColor = activeBackgroundColor.cgColor
                if animateActiveBorder { animateViewBorder(view) }
            }
            else {
                
                view.layer.borderColor = inactiveBorderColor.cgColor
                view.layer.backgroundColor = inactiveBackgroundColor.cgColor
                if animateActiveBorder { view.layer.removeAllAnimations() }
            }
        }
    }
    
    private func turnOffActiveLabel() {
        
        let view = _stack.arrangedSubviews[_activeIndex]
        if animateActiveBorder { view.layer.removeAllAnimations() }
        view.layer.borderColor = inactiveBorderColor.cgColor
        view.layer.backgroundColor = inactiveBackgroundColor.cgColor
    }
    
    private func createLabels() {
        
        _stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 1 ... length {
            
            let label = UILabel(frame: CGRect.zero)
            label.font = font
            label.textAlignment = .center
            label.layer.borderColor = inactiveBorderColor.cgColor
            label.layer.borderWidth = borderWidth
            label.layer.cornerRadius = cornerRadius
            _stack.addArrangedSubview(label)
        }
    }
    
    private func updateFont() {
        
        _stack.arrangedSubviews.forEach { ($0 as! UILabel).font = font }
    }
    
    private func updateCornerRadius() {
        
        _stack.arrangedSubviews.forEach { $0.layer.cornerRadius = cornerRadius }
    }
    
    private func updateBorderWidth() {
        
        _stack.arrangedSubviews.forEach { $0.layer.borderWidth = borderWidth }
    }
    
    private func updateInactiveBackgroundColor() {
        
        for i in 0 ..< _stack.arrangedSubviews.count {
            
            if i == _activeIndex { continue }
            let view = _stack.arrangedSubviews[i]
            view.layer.backgroundColor = inactiveBackgroundColor.cgColor
        }
    }
    
    private func updateActiveBackgroundColor() {
        
        _stack.arrangedSubviews[_activeIndex]
            .layer.backgroundColor = activeBackgroundColor.cgColor
    }
    
    private func updateInactiveBorderColor() {
        
        for i in 0 ..< _stack.arrangedSubviews.count {
            
            if i == _activeIndex { continue }
            let view = _stack.arrangedSubviews[i]
            view.layer.borderColor = inactiveBorderColor.cgColor
        }
    }
    
    private func updateActiveBorderColor() {
        
        highlightActiveLabel(_activeIndex)
    }
    
    private func updateErrorState() {
        
        if isError && shakeOnError { shakeAnimation() }
        
        _stack.arrangedSubviews.forEach {
            
            let label = ($0 as! UILabel)
            if animateActiveBorder { label.layer.removeAllAnimations() }
            
            if isError {
                
                label.textColor = errorTextColor
                label.layer.borderColor = errorBorderColor.cgColor
            }
            else {
                
                label.textColor = textColor
                label.layer.borderColor = inactiveBorderColor.cgColor
            }
        }
    }
    
    private func animateViewBorder(_ view: UIView) {
        
        view.layer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.borderColor))
        animation.duration = 1.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = [inactiveBorderColor.cgColor,
                            activeBorderColor.cgColor,
                            activeBorderColor.cgColor,
                            inactiveBorderColor.cgColor]
        
        view.layer.add(animation, forKey: "borderColorAnimation")
    }
    
    private func shakeAnimation() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-15.0, 15.0, -15.0, 15.0, -12.0, 12.0, -10.0, 10.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}


extension VKPinCodeView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        isError = false
        onBeginEditing?()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        return (validator?(string) ?? true) && _code.count < length
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isError { return }
        turnOffActiveLabel()
    }
}
