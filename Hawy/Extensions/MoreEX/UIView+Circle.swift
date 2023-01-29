//
//  UIView+Circle.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

extension UIView {
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    @IBInspectable var circlePaddingsView: Bool {
        get {
            return self.circlePaddingsView
        }set {
            layer.cornerRadius = self.frame.height / 2
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var viewTopCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topRight, .topLeft],
                                    cornerRadii: CGSize(width: newValue, height: newValue))
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func origin (_ point: CGPoint) {
        frame.origin.x = point.x
        frame.origin.y = point.y
    }
}

extension UIView {
    
    @IBInspectable
    var isCircular: Bool {
        set {
            makeCircular()
        }
        get {
            return cornerRadius == bounds.width / 2
        }
    }
}

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
}
extension UIView {
    
    public func round() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - width / 2, y: bounds.midY - width / 2, width: width, height: width)).cgPath
        self.layer.mask = mask
    }
    
    public func roundCorners() {
        let cornerRadius: CGFloat = frame.height / 2
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath
        layer.mask = maskLayer
    }
    
    func roundCorners(_ borderColor: UIColor, borderWidth: CGFloat) {
        let cornerRadius: CGFloat = frame.height / 2
        roundCorner(.allCorners, radius: cornerRadius, borderColor: .blue, borderWidth: 1)
    }
}

extension UIView {
    // Apply round corner and border. An extension method of UIView.
    public func roundCorner(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        let borderPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
