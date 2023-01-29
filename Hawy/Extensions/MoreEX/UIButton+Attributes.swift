//
//  UIButton+Attributes.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

extension UIButton {
    
    public func newAttributedTitle(title: String, letterSpacing: CGFloat, lineHeight: CGFloat, tintColor: UIColor, backgroundColor: UIColor) {
        let attributedString = NSMutableAttributedString.init(string: title)
        
        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        self.setAttributedTitle(attributedString, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        
    }
    
    public func underlineTitle(_ title: String, _ color: UIColor = .black, _ fontSize: CGFloat = 14) {
        let attributedString = NSAttributedString(string: title, attributes: [.font : UIFont.systemFont(ofSize: fontSize, weight: .bold), .foregroundColor: color, .underlineStyle: 1.0])
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
