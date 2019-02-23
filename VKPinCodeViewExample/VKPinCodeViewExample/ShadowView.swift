//
//  ShadowView.swift
//  VKPinCodeViewExample
//
//  Created by Vladimir Kokhanevich on 23/02/2019.
//  Copyright © 2019 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override var bounds: CGRect {
        
        didSet {
            
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 8.0
            layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
