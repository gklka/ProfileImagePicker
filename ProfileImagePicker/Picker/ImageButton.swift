//
//  ImageButton.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

/// Styled button for the `EditProfileImageController`
class ImageButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    convenience init(systemImage: String, title: String) {
        // Configure style
        var configuration = UIButton.Configuration.gray()
        configuration.imagePlacement = .top
        configuration.imagePadding = 8.0
        
        self.init(configuration: configuration)

        // Set image
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        self.setImage(UIImage(systemName: systemImage, withConfiguration: imageConfig), for: .normal)

        // Set label
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
        
        self.setup()
    }
    
    func setup() {
        // Tint images
        self.tintColor = .label
    }
}
