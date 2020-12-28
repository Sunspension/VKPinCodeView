//
//  VKPinCodeViewSettings.swift
//  VKPinCodeView
//
//  Created by Vladimir Kokhanevich on 09.09.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

public struct VKPinCodeViewSettings {
    
    public let lenght: Int
    
    public let spacing: CGFloat
    
    public let keyBoardType: UIKeyboardType
    
    public let keyBoardAppearance: UIKeyboardAppearance
    
    public let autocapitalizationType: UITextAutocapitalizationType
    
    public let animateSelectedInputItem: Bool
    
    public let shakeOnError: Bool
    
    public let resetAfterError: ResetType
    
    public let inputValidator: PinCodeValidator?
    
    public let securityUnicodeSymbol: String
    
    public let shouldDisplayTextBeforeSecureSymbol: Bool
    
    /// - parameter lenght: Number of input items. `4` by default.
    /// - parameter spacing: Spacing between input items. `16` by default.
    /// - parameter keyBoardType:`UIKeyboardType.numberPad` by default.
    /// - parameter keyBoardAppearance: Default value is `light`.
    /// - parameter autocapitalizationType: Default value is `none`.
    /// - parameter animateSelectedInputItem: Default value is `true`.
    /// - parameter shakeOnError: Default value is `true`.
    /// - parameter resetAfterError: Preferred error reset type. Default value is `none`.
    /// - parameter inputValidator: Text input validation. You might be need it if text input is different from digits. You don't need this by default.
    /// - parameter securityUnicodeSymbol: The symbool for displaying when security mode is on.
    /// - parameter shouldDisplayTextBeforeSecureSymbol: Should display entered text first before secured symbol
    
    public init(lenght: Int = 4, 
                spacing: CGFloat = 16, 
                keyBoardType: UIKeyboardType = .numberPad, 
                keyBoardAppearance: UIKeyboardAppearance = .light, 
                autocapitalizationType: UITextAutocapitalizationType = .none, 
                animateSelectedInputItem: Bool = true, 
                shakeOnError: Bool = true, 
                resetAfterError: ResetType = .none, 
                inputValidator: PinCodeValidator? = nil, 
                securityUnicodeSymbol: String = "\u{1F512}",
                shouldDisplayTextBeforeSecureSymbol: Bool = true) {
        
        self.lenght = lenght
        self.spacing = spacing
        self.keyBoardType = keyBoardType
        self.keyBoardAppearance = keyBoardAppearance
        self.autocapitalizationType = autocapitalizationType
        self.animateSelectedInputItem = animateSelectedInputItem
        self.shakeOnError = shakeOnError
        self.resetAfterError = resetAfterError
        self.inputValidator = inputValidator
        self.securityUnicodeSymbol = securityUnicodeSymbol
        self.shouldDisplayTextBeforeSecureSymbol = shouldDisplayTextBeforeSecureSymbol
    }
}
