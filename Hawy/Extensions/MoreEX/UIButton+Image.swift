//
//  UIButton+Image.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            let space = 35 as CGFloat
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - space))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
        }
    }
}
