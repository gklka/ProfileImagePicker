//
//  UIColor+Extensions.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

extension UIColor {
    /// Returns true if color is light, false if it is dark
    func isLight() -> Bool {
        // Algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1_000

        if brightness < 0.5 {
            return false
        } else {
            return true
        }
    }
    
    /// Check if alpha value is zero
    func isTransparent() -> Bool {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)

        return a == 0.0
    }
}

