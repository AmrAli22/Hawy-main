//
//  UIView+Border.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set (newRadius) {
            self.layer.cornerRadius = newRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set (newWidth) {
            self.layer.borderWidth = newWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return (self.layer.borderColor != nil) ? UIColor(cgColor: self.layer.borderColor!) : nil
        }
        set (newColor) {
            self.layer.borderColor = newColor?.cgColor
        }
    }
    
    func addTopBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    //corner radius for specific corners of a view
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCornersWithMask(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}

extension CACornerMask {
    public static var topLeading: CACornerMask { return .layerMinXMinYCorner }

    public static var topTrailing: CACornerMask { return .layerMaxXMinYCorner }

    public static var bottomLeading: CACornerMask { return .layerMinXMaxYCorner }

    public static var bottomTrailing: CACornerMask { return .layerMaxXMaxYCorner }
}
