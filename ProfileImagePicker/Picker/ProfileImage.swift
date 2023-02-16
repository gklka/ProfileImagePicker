//
//  ProfileImage.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

struct ProfileImage {
    enum BackgroundType {
        case color(UIColor)
        case gradient(UIColor, UIColor)
        case image(UIImage)
    }

    var background = BackgroundType.color(.gray)
    var text: String?
}
