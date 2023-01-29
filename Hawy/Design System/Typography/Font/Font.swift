//
//  Font.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/17/22.
//

import Foundation

enum Font: String {
    
    case almaraiRegular           = "ArbFONTS-Almarai-Regular"
    case almaraiExtrabold         = "ArbFONTS-Almarai-ExtraBold"
    case almaraiLight             = "ArbFONTS-Almarai-Light"
    case almaraiBold              = "ArbFONTS-Almarai-Bold"
    
    case poppinsBlack             = "Poppins-Black"
    case poppinsBlackItalic       = "Poppins-BlackItalic"
    case poppinsBold              = "Poppins-Bold"
    case poppinsBoldItalic        = "Poppins-BoldItalic"
    case poppinsExtraBold         = "Poppins-ExtraBold"
    case poppinsExtraBoldItalic   = "Poppins-ExtraBoldItalic"
    case poppinsExtraLight        = "Poppins-ExtraLight"
    case poppinsExtraLightItalic  = "Poppins-ExtraLightItalic"
    case poppinsItalic            = "Poppins-Italic"
    case poppinsLight             = "Poppins-Light"
    case poppinsLightItalic       = "Poppins-LightItalic"
    case poppinsMedium            = "Poppins-Medium"
    case poppinsMediumItalic      = "Poppins-MediumItalic"
    case poppinsRegular           = "Poppins-Regular"
    case poppinsSemiBold          = "Poppins-SemiBold"
    case poppinsSemiBoldItalic    = "Poppins-SemiBoldItalic"
    case poppinsThin              = "Poppins-Thin"
    case poppinsThinItalic        = "Poppins-ThinItalic"
    
    var name: String {
        return self.rawValue
    }
    
}
