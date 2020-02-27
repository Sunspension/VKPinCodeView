//
//  UnderlineStyle.swift
//  VKPinCodeView
//
//  Created by Vladimir Kokhanevich on 25.11.19.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

public final class UnderlineStyle: EntryViewStyle {

    private var _line = CAShapeLayer()

    private var _font: UIFont

    private var _textColor: UIColor

    private var _errorTextColor: UIColor

    private var _lineColor: UIColor

    private var _selectedLineColor: UIColor

    private var _lineWidth: CGFloat

    private var _errorLineColor: UIColor


    public required init(
        font: UIFont = UIFont.systemFont(ofSize: 22),
        textColor: UIColor = .black,
        errorTextColor: UIColor = .red,
        lineColor: UIColor = UIColor(white: 0.9, alpha: 1),
        selectedLineColor: UIColor = .lightGray,
        lineWidth: CGFloat = 1,
        errorLineColor: UIColor = .red) {

        _font = font
        _textColor = textColor
        _errorTextColor = errorTextColor
        _lineColor = lineColor
        _selectedLineColor = selectedLineColor
        _lineWidth = lineWidth
        _errorLineColor = errorLineColor
    }

    public func onSetStyle(_ label: VKLabel) {

        _line.strokeColor = _lineColor.cgColor
        _line.lineWidth = _lineWidth
        label.layer.addSublayer(_line)

        label.font = _font
        label.textColor = _textColor
        label.textAlignment = .center
    }

    public func onUpdateSelectedState(_ label: VKLabel) {

        if label.isSelected {

            _line.strokeColor = _selectedLineColor.cgColor

            if label.animateWhileSelected {

                let colors = [_lineColor.cgColor,
                _selectedLineColor.cgColor,
                _selectedLineColor.cgColor,
                _lineColor.cgColor]

                let animation = animateSelection(keyPath: #keyPath(CAShapeLayer.strokeColor), values: colors)
                _line.add(animation, forKey: "strokeColorAnimation")
            }
        }
        else {

            _line.removeAllAnimations()
            _line.strokeColor = _lineColor.cgColor
        }
    }

    public func onUpdateErrorState(_ label: VKLabel) {

        if label.isError {

            _line.removeAllAnimations()
            _line.strokeColor = _errorLineColor.cgColor
            label.textColor = _errorTextColor
        }
        else {

            _line.strokeColor = _lineColor.cgColor
            label.textColor = _textColor
        }
    }

    public func onLayoutSubviews(_ label: VKLabel) {

        let bounds = label.bounds
        let path = UIBezierPath()
        let y = bounds.maxY - _lineWidth / 2
        path.move(to: CGPoint(x: bounds.minX, y: y))
        path.addLine(to: CGPoint(x: bounds.maxX, y: y))
        _line.path = path.cgPath
    }
}
