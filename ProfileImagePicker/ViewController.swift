//
//  ViewController.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    // The current profile image
    var profileImage = ProfileImage(background: ProfileImage.Background(type: .gradient, firstColor: .blue, secondColor: .purple), text: "GK")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.profileImage = self.profileImage
    }
}

