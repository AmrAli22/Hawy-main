//
//  UIDevice+Extension.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//
import UIKit

extension UIDevice {
    
    enum DeviceTypes {
        case iPhone4_4s
        case iPhone5_5s
        case iPhone6_6s
        case iPhone6p_6ps
        case after_iPhone6p_6ps
    }
    
    static var deviceType: DeviceTypes {
        switch UIScreen.main.bounds.height {
        case 480.0:
            return .iPhone4_4s
        case 568.0:
            return .iPhone5_5s
        case 667.0:
            return .iPhone6_6s
        case 736.0:
            return .iPhone6p_6ps
        default:
            return .after_iPhone6p_6ps
        }
    }
}
