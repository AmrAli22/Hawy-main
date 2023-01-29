//
//  UILabel+Attribute.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

extension UILabel {
    
    public func attributedUnderlineTitle(title: String) {
        let attrs = [NSAttributedString.Key.underlineStyle: 1]
        
        let attributedString = NSMutableAttributedString(string: self.text!)
        let titleStr = NSMutableAttributedString(string: title, attributes: attrs)
        titleStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .regular)], range: NSRange.init(location: 0, length: titleStr.length))
        attributedString.append(titleStr)
        self.attributedText = attributedString
    }
    
    /// Change Sepicif words in sentence
    ///
    /// - Parameters:
    ///   - fullText: write full text
    ///   - changeText: write text you want to change
    ///   - color: add color for changed text
    ///   - font: add font for changed text
    public func halfTextColorChange(fullText : String , changeText : String, color: UIColor, font: UIFont) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(.foregroundColor, value: color, range: range)
        attribute.addAttribute(.font, value: font, range: range)
        self.attributedText = attribute
    }
    
    public func strikethrough() {
        let attributedText = NSAttributedString(string: self.text ?? "" , attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: UIColor.black])
        self.attributedText = attributedText
    }
}
