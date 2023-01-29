//
//  UIFont+Localized.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//
import UIKit

//extension UIFont {
//    
//    static func getLocalizedFont(type: FontTypesWithSize) -> UIFont {
//        
//        switch type {
//            
//        case .Bold(let value):
//            return ElMessiriFont.bold.font(for: value)
//        case .Medium(let value):
//            return ElMessiriFont.medium.font(for: value)
//        case .Regular(let value):
//            return ElMessiriFont.regular.font(for: value)
//        case .SemiBold(let value):
//            return ElMessiriFont.semiBold.font(for: value)
//        }
//    }
//}

enum FontTypesWithSize {
    case Bold(CGFloat), Medium(CGFloat), Regular(CGFloat), SemiBold(CGFloat)
}
