//
//  CenteredLabel.swift


import Foundation
import UIKit

class CenteredLabel : UILabel {
    
    func show (labelText : String , view : UIView) {
        text = labelText
        textAlignment = .center
        isHidden = false
        frame = CGRect(x: view.frame.width / 2 - 150 , y: view.frame.height / 2, width: 300, height: 40)
        font = UIFont.init(name: "NeoSansArabic-Medium", size: 17)
        textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(self)
    }
}
