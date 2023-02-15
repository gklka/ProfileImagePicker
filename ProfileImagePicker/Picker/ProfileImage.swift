//
//  ProfileImage.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

struct ProfileImage {
    struct Background {
        enum BackgroundType: String {
            case color
            case gradient
            case image
        }
        
        var type: BackgroundType = .color
        var image: UIImage?
        var firstColor: UIColor = .gray
        var secondColor: UIColor?
    }
    
    var background: Background = Background(type: .color)
    var text: String?
}
