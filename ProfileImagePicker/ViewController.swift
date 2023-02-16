//
//  ViewController.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var radius: CGFloat = 8.0
    
    // The current profile image
    var profileImage = ProfileImage(background: .gradient(.blue, .purple), text: "GK")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config profile image view
        self.profileImageView.delegate = self
        self.profileImageView.editable = true
        self.profileImageView.profileImage = self.profileImage
    }
    
    @IBAction func shapeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.profileImageView.shape = .square
            self.radiusSlider.isHidden = true
        case 1:
            self.profileImageView.shape = .circle
            self.radiusSlider.isHidden = true
        case 2:
            self.profileImageView.shape = .roundRect(self.radius)
            self.radiusSlider.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        self.radius = CGFloat(sender.value)
        self.profileImageView.shape = .roundRect(self.radius)
    }
    
    @IBAction func sizeChanged(_ sender: UISlider) {
        self.heightConstraint.constant = CGFloat(sender.value)
    }
}

extension ViewController: ProfileImageViewDelegate {
    func profileImageView(_ profileImageView: ProfileImageView, wantsToChangeImageTo profileImage: ProfileImage) {
        self.profileImage = profileImage
        
        // TODO: upload image, store it permanently
        print("New selected profile image: \(profileImage)")
    }
    
    func profileImageViewPresentationController(_ profileImageView: ProfileImageView) -> UIViewController {
        return self
    }
}
