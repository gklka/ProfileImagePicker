//
//  ProfileImageView.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

private let RoundRectCornerRadius: CGFloat = 8.0
private let LeftRightMargin = 0.1 // in width %
private let FontScaleFactor = 0.5 // % of the view height

class ProfileImageView: UIView {
    enum Shape {
        case circle
        case roundRect
    }

    // MARK: - Properties

    // Content properties
    public var profileImage: ProfileImage = ProfileImage() {
        didSet {
            self.reset()
            self.setup()
        }
    }
    public var shape: Shape = .circle
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var editable: Bool = true
    
    // Subviews
    var backgroundImageView: UIImageView?
    var textLabel: UILabel?
    var editButton: UIButton?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        // Configure background
        switch self.profileImage.background.type {
        case .color:
            self.backgroundColor = self.profileImage.background.firstColor
        case .gradient:
            self.insertGradient()
        case .image:
            self.backgroundImageView = UIImageView(frame: self.bounds)
            self.addSubview(self.backgroundImageView!)
        }
        
        // Add text if set
        if let text = self.profileImage.text {
            self.textLabel = UILabel(frame: CGRect(origin: CGPoint(x: self.bounds.width * LeftRightMargin, y: 0), size: CGSize(width: self.bounds.size.width * (1 - 2 * LeftRightMargin), height: self.bounds.size.height)))
            self.textLabel?.text = text
            self.textLabel?.textAlignment = .center
            self.textLabel?.minimumScaleFactor = 0.5
            self.textLabel?.numberOfLines = 1
            self.textLabel?.lineBreakMode = .byTruncatingTail
            self.textLabel?.font = self.font.withSize(self.bounds.height * FontScaleFactor)
            self.textLabel?.textColor = self.labelColor()
            self.addSubview(self.textLabel!)
        }
        
        // Add edit button
        if self.editable {
            self.editButton = UIButton(frame: self.bounds)
            self.editButton?.addTarget(self, action: #selector(self.editButtonTapped), for: .touchUpInside)
            self.addSubview(self.editButton!)
        }
        
        // Apply frame
        switch self.shape {
        case .circle:
            self.layer.cornerRadius = self.bounds.height / 2.0
        case .roundRect:
            self.layer.cornerRadius = RoundRectCornerRadius
        }
        self.layer.masksToBounds = true
        
        // Set accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = "Profile image"
    }
    
    func reset() {
        // Remove background color
        self.backgroundColor = .clear

        // Remove previous gradients
        self.layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        // Remove background image
        self.backgroundImageView?.removeFromSuperview()
        self.backgroundImageView = nil

        // Remove text
        self.textLabel?.removeFromSuperview()
        self.textLabel = nil
    }
    
    // MARK: - GUI actions
    
    @objc func editButtonTapped(_ sender: UIButton?) {
        print("tap!")
    }
    
    // MARK: - Helper functions

    func insertGradient() {
        guard let secondColor = self.profileImage.background.secondColor else {
            print("Wrong function call: secondColor is empty")
            return
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [self.profileImage.background.firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        self.backgroundColor = .clear
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func labelColor() -> UIColor {
        switch self.profileImage.background.type {
        case .color:
            return self.profileImage.background.firstColor.isLight() ? .black : .white
        case .gradient:
            return self.profileImage.background.firstColor.isLight() ? .black : .white // TODO: must analyze avg color of gradient
        case .image:
            return .white // TODO: must analyze avg color of image
        }
    }
}
