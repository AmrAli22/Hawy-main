//
//  UITextField+Placeholder.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

@IBDesignable
extension UITextField {
    @IBInspectable var placeHolderLocalized: String? {
        set {
            placeholder = newValue?.localized
        }get {
            return placeholder
        }
    }
}
