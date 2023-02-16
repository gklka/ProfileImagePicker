//
//  ColorButton.swift
//  ProfileImagePicker
//
//  Created by GK on 2023.02.16..
//

import UIKit

protocol ColorButtonDelegate {
    /// Will be called when the user has changed the color
    /// - Parameters:
    ///   - colorButton: The sending button
    ///   - color: The new color
    func colorButton(_ colorButton: ColorButton, didSetColor color: UIColor)
    
    /// Color Button will ask for a controller when it wants to present its color picker controller
    /// - Parameter profileImageView: The sending button
    /// - Returns: You should return a view controller which can be used for presenting a modal or popover controller, depending on the platform
    func colorButtonPresentationController(_ colorButton: ColorButton) -> UIViewController
}

class ColorButton: UIButton {
    private var colorPicker: UIColorPickerViewController?
    
    var color: UIColor = .red {
        didSet {
            self.configuration?.baseBackgroundColor = color
        }
    }
    var delegate: ColorButtonDelegate?
    var striked: Bool = false {
        didSet {
            if striked {
                self.layer.borderColor = UIColor.secondaryLabel.cgColor
                self.layer.borderWidth = 1.0
            } else {
                self.layer.borderWidth = 0
            }
            self.setNeedsDisplay()
        }
    }
    
    convenience init(color: UIColor, delegate: ColorButtonDelegate) {
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.imagePlacement = .top
        configuration.imagePadding = 8.0
        configuration.baseBackgroundColor = color
        
        self.init(configuration: configuration)
        
        self.color = color
        self.delegate = delegate
        
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30.0, height: 30.0)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.striked {
            if let context = UIGraphicsGetCurrentContext() {
                context.setLineWidth(3.0)
                context.setStrokeColor(UIColor.red.cgColor)
                context.move(to: CGPoint(x: 0, y: self.bounds.height))
                context.addLine(to: CGPoint(x: self.bounds.width, y: 0))
                context.strokePath()
            }
        }
    }
    
    @objc func tapped(_ sender: ColorButton) {
        self.colorPicker = UIColorPickerViewController()
        self.colorPicker?.selectedColor = self.color
        self.colorPicker?.modalPresentationStyle = .popover
        self.colorPicker?.popoverPresentationController?.sourceView = self
        self.colorPicker?.delegate = self
        
        if let delegate = self.delegate {
            let controller = delegate.colorButtonPresentationController(self)
            controller.present(self.colorPicker!, animated: true)
        }
    }
}

extension ColorButton: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // Set color
        self.color = viewController.selectedColor
        
        // Notify the delegate
        if let delegate = self.delegate {
            delegate.colorButton(self, didSetColor: viewController.selectedColor)
        }
        
        viewController.dismiss(animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        viewController.dismiss(animated: true)
    }
}
