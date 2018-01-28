//
//  GradientView.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/18/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.3642751276, green: 0.4051129818, blue: 0.8792575598, alpha: 1) {
        didSet {
            self.setNeedsLayout() // calls layoutSubviews
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 1, green: 0.3840791049, blue: 0.8340719722, alpha: 1) {
        didSet {
            self.setNeedsLayout() // calls layoutSubviews
        }
    }
    
    override func layoutSubviews() {
        
        let gradientLayer = CAGradientLayer()
        // needs colors, starting and end point, and how large it will be
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        
        // place it at the first layer aka at: 0
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

