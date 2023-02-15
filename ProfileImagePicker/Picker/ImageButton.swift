//
//  ImageButton.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

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
        var configuration = UIButton.Configuration.gray()
        configuration.imagePlacement = .top
        configuration.imagePadding = 4.0
        
        self.init(configuration: configuration)
        
        self.setImage(UIImage(systemName: systemImage), for: .normal)
        self.setTitle(title, for: .normal)
        
        self.setup()
    }
    
    func setup() {
        // Tint images
        self.tintColor = UIColor.label
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
}
