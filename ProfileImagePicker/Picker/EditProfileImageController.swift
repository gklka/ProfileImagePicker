//
//  EditProfileImageController.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

private let Padding: CGFloat = 16.0
private let CloseButtonSize: CGFloat = 44.0
private let ProfileImageViewSize: CGFloat = 120.0

class EditProfileImageController: UIViewController {
    // MARK: - Properties
    
    var profileImage: ProfileImage = ProfileImage() {
        didSet {
            self.profileImageView.profileImage = profileImage
        }
    }
    
    var closeButton: UIButton!
    var profileImageView: ProfileImageView!
    
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Build UI
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.profileImageView)
    }
    
    func setup() {
        // Close button
        self.closeButton = UIButton(frame: .zero)
        self.closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        self.closeButton.tintColor = UIColor.lightText
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Profile image
        self.profileImageView = ProfileImageView(frame: .zero)
        self.profileImageView.profileImage = self.profileImage
        self.profileImageView.editable = false
    }
    
    override func viewDidLayoutSubviews() {
        self.closeButton.frame = CGRect(
            x: self.view.bounds.size.width - CloseButtonSize,
            y: 0,
            width: CloseButtonSize,
            height: CloseButtonSize)
        
        self.profileImageView.frame = CGRect(
            x: (self.view.bounds.size.width - ProfileImageViewSize) / 2.0,
            y: Padding,
            width: ProfileImageViewSize,
            height: ProfileImageViewSize)
    }
    
    // MARK: - GUI actions
    
    @objc func closeButtonTapped(_ sender: UIButton?) {
        self.dismiss(animated: true)
    }
}
