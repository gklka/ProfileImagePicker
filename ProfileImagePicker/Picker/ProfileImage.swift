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
        var firstColor: UIColor = .red
        var secondColor: UIColor?
    }
    
    var background: Background = Background(type: .color, firstColor: .red)
    var text: String?
}
