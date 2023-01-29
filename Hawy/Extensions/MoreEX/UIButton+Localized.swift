//
//  UIButton+Localized.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//
import UIKit

@IBDesignable
extension UIButton {
    
    @IBInspectable var localizedText: String? {
        get {
            return currentTitle
        }
        set {
            setTitle(newValue?.localized, for: .normal)
        }
    }
    
    var localizedFont: UIFont {
        set {
            titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }get {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
}
