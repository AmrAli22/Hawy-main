//
//  UISwitch+Hieght.swift
//  aman
//
//  Created by Enas Abdallah on 13/01/2021.
//

import UIKit

extension UISwitch {

    func setSwithProperities(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
