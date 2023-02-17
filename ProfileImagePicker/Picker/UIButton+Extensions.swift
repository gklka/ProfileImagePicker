//
//  UIButton+Extensions.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

extension UIButton {
    // Source: https://stackoverflow.com/a/44325883/511878
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        // Create 1x1 image with the given color
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Set as background
        self.setBackgroundImage(colorImage, for: state)
    }
}
