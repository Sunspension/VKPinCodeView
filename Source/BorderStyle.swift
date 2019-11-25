//
//  BorderStyle.swift
//  VKPinCodeView
//
//  Created by Vladimir Kokhanevich on 25.11.19.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

public final class BorderStyle: EntryViewStyle {

    private var _font: UIFont

    private var _textColor: UIColor

    private var _errorTextColor: UIColor

    private var _cornerRadius: CGFloat

    private var _borderColor: UIColor

    private var _borderWidth: CGFloat

    private var _selectedBorderColor: UIColor

    private var _errorBorderColor: UIColor

    private var _backgroundColor: UIColor

    private var _selectedBackgroundColor: UIColor


    public required init(
        font: UIFont = UIFont.systemFont(ofSize: 22),
        textColor: UIColor = .black,
        errorTextColor: UIColor = .red,
        cornerRadius: CGFloat = 10,
        borderWidth: CGFloat = 1,
        borderColor: UIColor = UIColor(white: 0.9, alpha: 1),
        selectedBorderColor: UIColor = .lightGray,
        errorBorderColor: UIColor = .red,
        backgroundColor: UIColor = .white,
        selectedBackgroundColor: UIColor = .white) {

        _font = font
        _textColor = textColor
        _errorTextColor = errorTextColor
        _cornerRadius = cornerRadius
        _borderWidth = borderWidth
        _borderColor = borderColor
        _selectedBorderColor = selectedBorderColor
        _errorBorderColor = errorBorderColor
        _backgroundColor = backgroundColor
        _selectedBackgroundColor = selectedBackgroundColor
    }

    public func onSetStyle(_ label: VKLabel) {

        let layer = label.layer
        layer.cornerRadius = _cornerRadius
        layer.borderColor = _borderColor.cgColor
        layer.borderWidth = _borderWidth
        layer.backgroundColor = _backgroundColor.cgColor

        label.textAlignment = .center
        label.font = _font
        label.textColor = _textColor
    }

    public func onUpdateSelectedState(_ label: VKLabel) {

        let layer = label.layer

        if label.isSelected {

            layer.borderColor = _selectedBorderColor.cgColor
            layer.backgroundColor = _selectedBackgroundColor.cgColor

            if label.animateWhileSelected {

                let colors = [_borderColor.cgColor,
                _selectedBorderColor.cgColor,
                _selectedBorderColor.cgColor,
                _borderColor.cgColor]

                let animation = animateSelection(keyPath: #keyPath(CALayer.borderColor), values: colors)
                layer.add(animation, forKey: "borderColorAnimation")
            }
        }
        else {

            layer.removeAllAnimations()
            layer.borderColor = _borderColor.cgColor
            layer.backgroundColor = _backgroundColor.cgColor
        }
    }

    public func onUpdateErrorState(_ label: VKLabel) {

        if label.isError {

            label.layer.removeAllAnimations()
            label.layer.borderColor = _errorBorderColor.cgColor
            label.textColor = _errorTextColor
        }
        else {

            label.layer.borderColor = _borderColor.cgColor
            label.textColor = _textColor
        }
    }

    public func onLayoutSubviews(_ label: VKLabel) {}
}
