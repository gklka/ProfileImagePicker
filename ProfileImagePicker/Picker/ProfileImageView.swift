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

/// You must implement this delegate in order to be able to change images
protocol ProfileImageViewDelegate {
    /// Will be called when the profile image view has changed the profile image. The caller's responsibility is to save/upload the given image or drop it and error to the user if not possible.
    /// - Parameters:
    ///   - profileImageView: The image view
    ///   - profileImage: The new profile image
    func profileImageView(_ profileImageView: ProfileImageView, wantsToChangeImageTo profileImage: ProfileImage)
    
    /// Profile image view will ask for a controller when it wants to present its image editing controller
    /// - Parameter profileImageView: The image view
    /// - Returns: You should return a view controller which can be used for presenting a modal or popover controller, depending on the platform
    func profileImageViewPresentationController(_ profileImageView: ProfileImageView) -> UIViewController
}

class ProfileImageView: UIView {
    enum Shape {
        case square
        case circle
        case roundRect(CGFloat?)
    }

    // MARK: - Properties

    // Content properties
    public var profileImage: ProfileImage = ProfileImage() {
        didSet {
            print("profileimageview: setting new image: \(profileImage)")
            self.reset()
            self.setup()
        }
    }
    public var shape: Shape = .circle {
        didSet {
            self.reset()
            self.setup()
        }
    }
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var editable: Bool = false {
        didSet {
            self.reset()
            self.setup()
        }
    }
    public var delegate: ProfileImageViewDelegate?
    
    // Subviews
    var backgroundImageView: UIImageView?
    var textLabel: UILabel?
    var editButton: UIButton?
    var editController: EditProfileImageController?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    /// Setup view based on the current `profileImage`
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
            self.editButton?.setBackgroundColor(UIColor.gray.withAlphaComponent(0.5), for: .highlighted)
            self.addSubview(self.editButton!)
        }
        
        // Hide parts out of shape
        self.layer.masksToBounds = true
        
        // Set accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = "Profile image"
    }
    
    /// Reset all properties to initial state, remove all added subviews
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
        
        // Remove edit button
        self.editButton?.removeFromSuperview()
        self.editButton = nil
        
        // Clean edit controller
        self.editController = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Apply frame
        switch self.shape {
        case .square:
            self.layer.cornerRadius = 0
        case .circle:
            self.layer.cornerRadius = self.bounds.height / 2.0
        case .roundRect(let radius):
            self.layer.cornerRadius = radius ?? RoundRectCornerRadius
        }
    }
    
    // MARK: - GUI actions
    
    @objc func editButtonTapped(_ sender: UIButton?) {
        guard let presentingController = self.delegate?.profileImageViewPresentationController(self) else {
            print("No presenting controller provided, cannot open edit controller")
            return
        }
        
        self.editController = EditProfileImageController()
        self.editController?.profileImage = self.profileImage
        presentingController.present(self.editController!, animated: true)
    }
    
    // MARK: - Helper functions
    
    /// Adds a gradient layer based on the current `profileImage` background
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
    
    /// Retrun a readable color for the label based on the background
    /// - Returns: Color for the text
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
