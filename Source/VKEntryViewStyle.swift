//
//  EntryViewStyle.swift
//
//  Created by Vladimir Kokhanevich on 23/02/2019.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

public enum VKEntryViewStyleName {
    
    case border, underline
}

public enum VKEntryViewStyle {
    
    case border(
        font: UIFont,
        textColor: UIColor,
        errorTextColor: UIColor,
        cornerRadius: CGFloat,
        borderWidth: CGFloat,
        borderColor: UIColor,
        selectedBorderColor: UIColor,
        errorBorderColor: UIColor,
        backgroundColor: UIColor,
        selectedBackgroundColor: UIColor)
    
    case underline(
        font: UIFont,
        textColor: UIColor,
        errorTextColor: UIColor,
        lineWidth: CGFloat,
        lineColor: UIColor,
        selectedLineColor: UIColor,
        errorLineColor: UIColor)
    
    static var underline: VKEntryViewStyle {
        
        return .underline(font: UIFont.systemFont(ofSize: 22),
                          textColor: .black,
                          errorTextColor: .red,
                          lineWidth: 1,
                          lineColor: UIColor.init(white: 0.9, alpha: 1),
                          selectedLineColor: .lightGray,
                          errorLineColor: .red)
    }
    
    static var border: VKEntryViewStyle {
        
        return .border(font: UIFont.systemFont(ofSize: 22),
                       textColor: .black,
                       errorTextColor: .red,
                       cornerRadius: 5,
                       borderWidth: 1,
                       borderColor: UIColor.init(white: 0.9, alpha: 1),
                       selectedBorderColor: .lightGray,
                       errorBorderColor: .red,
                       backgroundColor: .white,
                       selectedBackgroundColor: .white)
    }
    
    var styleName: VKEntryViewStyleName {
        
        switch self {
            
        case .border:
            return .border
            
        case .underline:
            return .underline
        }
    }
}
