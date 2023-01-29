//
//  Color.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/17/22.
//

import Foundation
import UIKit

extension DesignSystem {
    
    enum Colors: String {
        
        case PrimaryBlack       =  "PrimaryBlack"
        case PrimaryBlue        =  "PrimaryBlue"
        case PrimaryGray        =  "PrimaryGray"
        case PrimaryOrange      =  "PrimaryOrange"
        case PrimaryYellow      =  "PrimaryYellow"
        case SecondBackground   =  "SecondBackground"
        case TextFieldBG        =  "TextFieldBG"
        case PrimaryLightGray   =  "PrimaryLightGray"
        case PrimaryDarkGray    =  "PrimaryDarkGray"
        case PrimarySecondBlue  =  "PrimarySecondBlue"
        case PrimarySecondRed   =  "PrimarySecondRed"
        case PrimaryGreen       =  "PrimaryGreen"
        case ButtonBG           =  "ButtonBG"
        case PrimaryLightBlue   =  "PrimaryLightBlue"
        case PrimaryClearBlue   =  "PrimaryClearBlue"
        case PrimaryLightGreen  =  "PrimaryLightGreen"
        case PrimaryClearGreen  =  "PrimaryClearGreen"
        case PrimaryLightPurple =  "PrimaryLightPurple"
        case PrimaryClearPurple =  "PrimaryClearPurple"
        case PrimaryLightRed    =  "PrimaryLightRed"
        case PrimaryClearRed    =  "PrimaryClearRed"
        
        case PrimaryDarkRed     = "PrimaryDarkRed"
        
        case PrimaryThirdRed    = "PrimaryThirdRed"
        
        var color: UIColor {
            return UIColor(named: self.rawValue)!
        }
        
    }
    
}
