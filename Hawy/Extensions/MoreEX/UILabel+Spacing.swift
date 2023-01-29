//
//  UILabel+Spacing.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

@IBDesignable
extension UILabel {
    
    @IBInspectable var lineHeight: CGFloat {
        get {
            return 0
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = newValue
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.alignment = self.textAlignment
            
            let attrString = NSMutableAttributedString(string: self.text ?? "")
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    @IBInspectable var attributedlineHeight: CGFloat {
        get {
            return 0
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = newValue
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.alignment = self.textAlignment
            
            let attrString = NSMutableAttributedString(attributedString: self.attributedText ?? NSAttributedString(string: ""))
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    @IBInspectable var letterSpacing: CGFloat {
        get {
            return 0
        }
        set {
            let attrString = NSMutableAttributedString(string: self.text ?? "")
            attrString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    
}
