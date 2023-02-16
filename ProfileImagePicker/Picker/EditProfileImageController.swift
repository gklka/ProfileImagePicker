//
//  EditProfileImageController.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.15..
//

import UIKit
import UniformTypeIdentifiers

private let Padding: CGFloat = 16.0
private let CloseButtonSize: CGFloat = 44.0
private let ProfileImageViewSize: CGFloat = 120.0
private let ButtonPadding: CGFloat = 8.0
private let ButtonHeight: CGFloat = 70.0 // TODO: Should depend on font size

private let BackgroundImageMaximumSize: CGFloat = 500.0

protocol EditProfileImageControllerDelegate {
    /// Will be called when the profile image view has changed the profile image. The caller's responsibility is to save/upload the given image or drop it and error to the user if not possible.
    /// - Parameters:
    ///   - controller: The edit profile image controller
    ///   - profileImage: The new profile image
    func editProfileImageViewController(_ controller: EditProfileImageController, wantsToChangeImageTo profileImage: ProfileImage)
}

class EditProfileImageController: UIViewController {
    // MARK: - Properties
    
    var profileImage: ProfileImage = ProfileImage() {
        didSet {
            self.profileImageView.profileImage = profileImage
        }
    }
    var delegate: EditProfileImageControllerDelegate?
    
    var closeButton: UIButton!
    var profileImageView: ProfileImageView!
    var backgroundTitleLabel: UILabel!
    var cameraButton: UIButton!
    var photosButton: UIButton!
    var filesButton: UIButton!
    var colorButton: UIButton!
    
    var imagePickerController: UIImagePickerController?
    var documentPicker: UIDocumentPickerViewController?
    
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

        // Background
        self.view.backgroundColor = .secondarySystemBackground

        // Build UI
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.profileImageView)
        self.view.addSubview(self.backgroundTitleLabel)
        self.view.addSubview(self.cameraButton)
        self.view.addSubview(self.photosButton)
        self.view.addSubview(self.filesButton)
        self.view.addSubview(self.colorButton)
    }
    
    func setup() {
        // Close button
        self.closeButton = UIButton(frame: .zero)
        self.closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        self.closeButton.tintColor = UIColor.label
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Profile image
        self.profileImageView = ProfileImageView(frame: .zero)
        self.profileImageView.profileImage = self.profileImage
        self.profileImageView.editable = false
        
        let dropInteraction = UIDropInteraction(delegate: self)
        self.profileImageView.addInteraction(dropInteraction)
        
        // Background title
        self.backgroundTitleLabel = UILabel(frame: .zero)
        self.backgroundTitleLabel.text = NSLocalizedString("Background", comment: "Edit profile image - title").uppercased()
        self.backgroundTitleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        self.backgroundTitleLabel.textColor = .secondaryLabel
        
        // Camera button
        self.cameraButton = ImageButton(systemImage: "camera", title: NSLocalizedString("Camera", comment: "Edit profile image - Camera"))
        self.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        // Photos button
        self.photosButton = ImageButton(systemImage: "photo", title: NSLocalizedString("Photos", comment: "Edit profile image - Photos"))
        self.photosButton.addTarget(self, action: #selector(photosButtonTapped), for: .touchUpInside)

        // Files button
        self.filesButton = ImageButton(systemImage: "folder", title: NSLocalizedString("Files", comment: "Edit profile image - Files"))
        self.filesButton.addTarget(self, action: #selector(filesButtonTapped), for: .touchUpInside)

        // Color button
        self.colorButton = ImageButton(systemImage: "paintpalette", title: NSLocalizedString("Color", comment: "Edit profile image - Color"))
        self.colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
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
        
        self.backgroundTitleLabel.frame = CGRect(
            x: Padding,
            y: Padding + ProfileImageViewSize + Padding,
            width: self.view.bounds.size.width - 2 * Padding,
            height: UIFont.smallSystemFontSize)
        
        self.cameraButton.frame = CGRect(
            x: Padding,
            y: self.backgroundTitleLabel.frame.origin.y + self.backgroundTitleLabel.frame.size.height + Padding,
            width: (self.view.bounds.width - 2 * Padding - 3 * ButtonPadding) / 4.0,
            height: ButtonHeight)

        self.photosButton.frame = CGRect(
            x: self.cameraButton.frame.origin.x + self.cameraButton.frame.size.width + ButtonPadding,
            y: self.cameraButton.frame.origin.y,
            width: (self.view.bounds.width - 2 * Padding - 3 * ButtonPadding) / 4.0,
            height: ButtonHeight)

        self.filesButton.frame = CGRect(
            x: self.photosButton.frame.origin.x + self.photosButton.frame.size.width + ButtonPadding,
            y: self.cameraButton.frame.origin.y,
            width: (self.view.bounds.width - 2 * Padding - 3 * ButtonPadding) / 4.0,
            height: ButtonHeight)

        self.colorButton.frame = CGRect(
            x: self.filesButton.frame.origin.x + self.filesButton.frame.size.width + ButtonPadding,
            y: self.cameraButton.frame.origin.y,
            width: (self.view.bounds.width - 2 * Padding - 3 * ButtonPadding) / 4.0,
            height: ButtonHeight)
    }
    
    // MARK: - GUI actions
    
    @objc func closeButtonTapped(_ sender: UIButton?) {
        if let delegate = self.delegate {
            delegate.editProfileImageViewController(self, wantsToChangeImageTo: self.profileImage)
        }
        self.dismiss(animated: true)
    }
    
    @objc func cameraButtonTapped(_ sender: ImageButton) {
        self.enableButtons(false)
        self.imagePickerController = UIImagePickerController()
        if let imagePickerController = self.imagePickerController {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.modalPresentationStyle = .popover
            imagePickerController.popoverPresentationController?.sourceView = sender
            imagePickerController.popoverPresentationController?.delegate = self
            self.present(imagePickerController, animated: true)
        }
    }
    
    @objc func photosButtonTapped(_ sender: ImageButton) {
        self.enableButtons(false)
        self.imagePickerController = UIImagePickerController()
        if let imagePickerController = self.imagePickerController {
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = [UTType.image.identifier as String]
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.modalPresentationStyle = .popover
            imagePickerController.popoverPresentationController?.sourceView = sender
            imagePickerController.popoverPresentationController?.delegate = self
            self.present(imagePickerController, animated: true)
        }
    }
    
    @objc func filesButtonTapped(_ sender: ImageButton) {
        self.enableButtons(false)
        self.documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: false)
        if let documentPicker = self.documentPicker {
            documentPicker.allowsMultipleSelection = false
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true)
        }
    }
    
    @objc func colorButtonTapped(_ sender: ImageButton) {
    }
    
    // MARK: - Helper functions
    
    func enableButtons(_ enable: Bool) {
        self.cameraButton.isEnabled = enable
        self.photosButton.isEnabled = enable
        self.filesButton.isEnabled = enable
        self.colorButton.isEnabled = enable
    }
    
    func setNewBackgroundImage(_ image: UIImage) {
        // Resize image to maximum allowed size
        let targetSize = CGSize(width: BackgroundImageMaximumSize, height: BackgroundImageMaximumSize)
        guard let scaledImage = image.resize(scaledToFill: targetSize) else {
            print("Scaling failed")
            return
        }
        
        // Set new profile image
        var newProfileImage = self.profileImage // New copy
        newProfileImage.background = .image(scaledImage)
        self.profileImage = newProfileImage
    }
}

// MARK: - Image Picker Controller delegate

extension EditProfileImageController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        defer {
            self.enableButtons(true)
        }
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // Set new profile image
        self.setNewBackgroundImage(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.enableButtons(true)
    }
}

// MARK: - Navigation Controller delegate

extension EditProfileImageController: UINavigationControllerDelegate {
    // Just need to conform
}

// MARK: - Document Picker Controller delegate

extension EditProfileImageController: UIDocumentPickerDelegate {    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        
        defer {
            self.enableButtons(true)
            self.documentPicker = nil
        }
        
        guard let url = urls.first else {
            print("No URLs provided")
            return
        }
        
        if let image = UIImage(contentsOfFile: url.path(percentEncoded: false)) {
            self.setNewBackgroundImage(image)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
        self.enableButtons(true)
        self.documentPicker = nil
    }
}

// MARK: - Popover Presentation Controller delegate

extension EditProfileImageController: UIPopoverPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.enableButtons(true)
        self.imagePickerController = nil
    }
}

// MARK: - Drop Interaction delegate

extension EditProfileImageController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]
            guard let image = images.first else {
                return
            }
            
            self.setNewBackgroundImage(image)
        }
    }
}
