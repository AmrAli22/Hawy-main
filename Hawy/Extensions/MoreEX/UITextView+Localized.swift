//
//  UITextView+Localized.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

extension UITextView {
    @IBInspectable var localizedText: String? {
        get {
            return text
        }
        set {
            text = newValue?.localized
        }
    }
    
    var localizedFont: UIFont {
        set {
            font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }get {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
}
