//
//  EntryViewStyle+Extensions.swift
//  VKPinCodeView
//
//  Created by Vladimir Kokhanevich on 25.11.19.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

/// Friednly helper for the selection animation.
public extension EntryViewStyle {

    func animateSelection(keyPath: String, values: [Any]) -> CAKeyframeAnimation {

        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.duration = 1.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = values
        return animation
    }
}
