//
//  UIImage+Extensions.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.16..
//

import UIKit

extension UIImage {
    func resize(scaledToFill size: CGSize) -> UIImage? {
        let scale: CGFloat = max(size.width / self.size.width, size.height / self.size.height)
        let width: CGFloat = self.size.width * scale
        let height: CGFloat = self.size.height * scale
        let imageRect = CGRect(x: (size.width - width) / 2.0, y: (size.height - height) / 2.0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: imageRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
