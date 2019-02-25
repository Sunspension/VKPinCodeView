//
//  VKLabel.swift
//
//  Created by Vladimir Kokhanevich on 22/02/2019.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

/// Input item which is use in main container.
public class VKLabel: UILabel {
    
    private var _selectedColor: UIColor = .lightGray
    
    private var _lineColor: UIColor = UIColor(white: 0.9, alpha: 1)
    
    private var _errorLineColor: UIColor = .red
    
    private var _textColor: UIColor = .black
    
    private var _errorTextColor: UIColor = .red
    
    private var _backgroundColor: UIColor = .white
    
    private var _selectedBackgroundColor: UIColor = .white
    
    private var _lineWidth: CGFloat = 1
    
    private var _styleName = VKEntryViewStyleName.underline
    
    private lazy var _line: CAShapeLayer = {
        
        let line = CAShapeLayer()
        line.strokeColor = self._lineColor.cgColor
        line.lineWidth = self._lineWidth
        layer.addSublayer(line)
        return line
    }()
    
    private var _linePath: UIBezierPath {
        
        let path = UIBezierPath()
        let y = bounds.maxY - _lineWidth / 2
        path.move(to: CGPoint(x: bounds.minX, y: y))
        path.addLine(to: CGPoint(x: bounds.maxX, y: y))
        return path
    }
    
    /// Enable or disable selection animation for active input item. Default value is true.
    public var animateWhileSelected = true
    
    /// Enable or disable selection for displaying active state.
    public var isSelected = false {
        
        didSet { if oldValue != isSelected { updateSelectedState() } }
    }
    
    /// Enable or disable selection for displaying error state.
    public var isError = false {
        
        didSet {  updateErrorState() }
    }
    
    // MARK: - Initializers
    
    /// Prefered initializer if you don't use storyboards or nib files.
    public init(_ style: VKEntryViewStyle) {
        
        super.init(frame: CGRect.zero)
        setEntryViewStyle(style)
    }
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        setEntryViewStyle(VKEntryViewStyle.underline)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Overrides
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if _styleName == .border { return }
        _line.path = _linePath.cgPath
    }
    
    // MARK: - Public methods
    
    /// Set appearence style.
    public func setEntryViewStyle(_ style: VKEntryViewStyle) {
        
        _styleName = style.styleName
        textAlignment = .center
        
        switch style {
            
        case .border(let font,
                     let textColor,
                     let errorTextColor,
                     let cornerRadius,
                     let borderWidth,
                     let borderColor,
                     let selectedBorderColor,
                     let errorBorderColor,
                     let backgroundColor,
                     let selectedBackgroundColor):
            
            self.font = font
            self.textColor = textColor
            _textColor = textColor
            _errorTextColor = errorTextColor
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.backgroundColor = backgroundColor.cgColor
            _selectedColor = selectedBorderColor
            _lineColor = borderColor
            _errorLineColor = errorBorderColor
            _backgroundColor = backgroundColor
            _selectedBackgroundColor = selectedBackgroundColor
            
        case .underline(let font,
                        let textColor,
                        let errorTextColor,
                        let lineWidth,
                        let lineColor,
                        let selectedLineColor,
                        let errorLineColor):
            
            self.font = font
            self.textColor = textColor
            _textColor = textColor
            _errorTextColor = errorTextColor
            _line.strokeColor = lineColor.cgColor
            _line.lineWidth = lineWidth
            _selectedColor = selectedLineColor
            _lineColor = lineColor
            _errorLineColor = errorLineColor
        }
    }
    
    // MARK: - Private methods
    
    private func updateSelectedState() {
        
        if _styleName == .underline {
            
            if isSelected {
                
                _line.strokeColor = _selectedColor.cgColor
                
                if animateWhileSelected {
                    
                    let animation = animateViewBorder(keyPath: #keyPath(CAShapeLayer.strokeColor))
                    _line.add(animation, forKey: "strokeColorAnimation")
                }
            }
            else {
                
                _line.removeAllAnimations()
                _line.strokeColor = _lineColor.cgColor
            }
        }
        else {
            
            if isSelected {
                
                layer.borderColor = _selectedColor.cgColor
                layer.backgroundColor = _selectedBackgroundColor.cgColor
                
                if animateWhileSelected {
                    
                    let animation = animateViewBorder(keyPath: #keyPath(CALayer.borderColor))
                    layer.add(animation, forKey: "borderColorAnimation")
                }
            }
            else {
                
                layer.removeAllAnimations()
                layer.borderColor = _lineColor.cgColor
                layer.backgroundColor = _backgroundColor.cgColor
            }
        }
    }
    
    private func updateErrorState() {
        
        if isError {
            
            if _styleName == .underline {
                
                _line.removeAllAnimations()
                _line.strokeColor = _errorLineColor.cgColor
            }
            else {
                
                layer.removeAllAnimations()
                layer.borderColor = _errorLineColor.cgColor
            }
            
            textColor = _errorTextColor
        }
        else {
            
            if _styleName == .underline { _line.strokeColor = _lineColor.cgColor }
            else { layer.borderColor = _lineColor.cgColor }
            textColor = _textColor
        }
    }
    
    private func animateViewBorder(keyPath: String) -> CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.duration = 1.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = [_lineColor.cgColor,
                            _selectedColor.cgColor,
                            _selectedColor.cgColor,
                            _lineColor.cgColor]
        return animation
    }
}
