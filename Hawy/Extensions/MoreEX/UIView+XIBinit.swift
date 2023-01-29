//
//  UIView+XIBinit.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//
import UIKit

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
