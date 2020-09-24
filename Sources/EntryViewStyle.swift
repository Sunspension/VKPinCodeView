//
//  EntryViewStylable.swift
//  VKPinCodeView
//
//  Created by Vladimir Kokhanevich on 25.11.19.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

/// Describes appearence lifecycle for a given label.
public protocol EntryViewStyle {

    func onSetStyle(_ label: VKLabel)

    func onUpdateSelectedState(_ label: VKLabel)

    func onUpdateErrorState(_ label: VKLabel)

    func onLayoutSubviews(_ label: VKLabel)
}

extension EntryViewStyle {

    func selectionAnimation(_ keyPath: String, values: [Any], duration: Double = 1.0) -> CAKeyframeAnimation {

        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = values
        return animation
    }
    
    func secureTextAnimation(_ duration: Double = 0.3) -> CATransition {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .push
        animation.subtype = .fromTop
        animation.duration = duration
        return animation
    }
}
