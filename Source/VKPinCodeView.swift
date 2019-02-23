//
//  VKPinCodeView.swift
//  gpn
//
//  Created by Vladimir Kokhanevich on 20/02/2019.
//  Copyright © 2019 Reksoft. All rights reserved.
//

import UIKit

public typealias VKPinCodeValidator = (_ code: String) -> Bool

public class VKPinCodeView: UIView {
    
    private lazy var _stack = UIStackView(frame: bounds)
    
    private lazy var _textField = UITextField(frame: bounds)
    
    private var _style: VKEntryViewStyle?
    
    private var _code = "" {
        
        didSet { onCodeDidChange?(_code) }
    }
    
    private var _activeIndex: Int {
        
        return _code.count == 0 ? 0 : _code.count - 1
    }
    
    public var length: Int = 4 {
        
        willSet { createLabels() }
    }
    
    public var spacing: CGFloat = 16 {
        
        willSet { if newValue != spacing { _stack.spacing = newValue } }
    }
    
    public var keyBoardType = UIKeyboardType.numberPad {
        
        willSet { _textField.keyboardType = newValue }
    }
    
    public var isError = false {
        
        didSet { if oldValue != isError { updateErrorState() } }
    }
    
    public var animateSelectedEntry = true
    
    public var shakeOnError = true
    
    public var onComplete: ((_ code: String) -> Void)?
    
    public var onCodeDidChange: ((_ code: String) -> Void)?
    
    public var onBeginEditing: (() -> Void)?
    
    public var validator: VKPinCodeValidator?
    
    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    init(style: VKEntryViewStyle) {
        
        super.init(frame: CGRect.zero)
        _style = style
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Life cycle
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        setup()
    }
    
    
    // MARK: - Overrides
    
    override public func prepareForInterfaceBuilder() {
        
        setup()
    }
    
    @discardableResult override public func becomeFirstResponder() -> Bool {
        
        onBecomeActive()
        return super.becomeFirstResponder()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        onBecomeActive()
    }
    
    
    // MARK: - Public methods
    
    public func setStyle(_ style: VKEntryViewStyle) {
        
        _style = style
        createLabels()
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
        
        if #available(iOS 12.0, *) { _textField.textContentType = .oneTimeCode }
        
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
            turnOffSelectedLabel()
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
            
            let label = _stack.arrangedSubviews[i] as! VKLabel
            label.isSelected = i == activeIndex
        }
    }
    
    private func turnOffSelectedLabel() {
        
        let label = _stack.arrangedSubviews[_activeIndex] as! VKLabel
        label.isSelected = false
    }
    
    private func createLabels() {
        
        let style = _style ?? VKEntryViewStyle.border
        _stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 1 ... length { _stack.addArrangedSubview(VKLabel(style)) }
    }
    
    private func updateErrorState() {
        
        if isError {
            
            turnOffSelectedLabel()
            if shakeOnError { shakeAnimation() }
        }
        
        _stack.arrangedSubviews.forEach({ ($0 as! VKLabel).isError = isError })
    }
    
    private func shakeAnimation() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-15.0, 15.0, -15.0, 15.0, -12.0, 12.0, -10.0, 10.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    private func onBecomeActive() {
        
        _textField.becomeFirstResponder()
        highlightActiveLabel(_activeIndex)
    }
}


extension VKPinCodeView: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        isError = false
        onBeginEditing?()
    }
    
    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        return (validator?(string) ?? true) && _code.count < length
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isError { return }
        turnOffSelectedLabel()
    }
}
