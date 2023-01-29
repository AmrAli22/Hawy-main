//
//  UITextfield+Padding.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    @IBInspectable var bottomBorderColor: UIColor = .lightGray
    @IBInspectable var bottomBorderHeight: CGFloat = 0
    
    var bottomBorder = UIView()
    
    // Insets for placholder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // Insets for text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if bottomBorderHeight > 0 {
            bottomBorder.backgroundColor = bottomBorderColor
            addSubview(bottomBorder)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bottomBorderHeight > 0 {
            bottomBorder.frame = CGRect(x: 0, y: self.layer.frame.height, width: self.layer.frame.width, height: bottomBorderHeight)
        }
    }
}
