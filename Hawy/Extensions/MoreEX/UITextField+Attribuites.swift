//
//  UITextField+Attribuites.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

extension UITextField {
    
    @IBInspectable var letterSpacing: CGFloat {
        get {
            // unsupported
            return 0
        }
        set {
            let attrString = NSMutableAttributedString(string: self.text!)
            attrString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    
    public func attributedPlaceholder(title: String) {
        let attributesStr = NSMutableAttributedString.init(string: title)
        attributesStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .medium), range: NSRange.init(location: 0, length: attributesStr.length))
        attributesStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange.init(location: 0, length: attributesStr.length))
        
        self.attributedPlaceholder = attributesStr
    }
    
    public func attributedText(title: String) {
        let attributesStr = NSMutableAttributedString.init(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.alignment = NSTextAlignment.left
        
        attributesStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributesStr.length))
        attributesStr.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GothamPro", size: 16)!, range: NSRange.init(location: 0, length: attributesStr.length))
        attributesStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange.init(location: 0, length: attributesStr.length))
        
        self.attributedPlaceholder = attributesStr
    }
    
    func addRightView(with image: UIImage) {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15)
        rightViewMode = .always
        rightView = button
    }
    
    func addLeftView(with image: UIImage) {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        leftViewMode = .always
        leftView = button
    }
}
