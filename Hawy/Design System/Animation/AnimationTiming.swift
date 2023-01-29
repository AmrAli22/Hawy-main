//
//  AnimationTiming.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/18/22.
//

import Foundation
import UIKit

enum AnimationTiming {
    
    case easeIn
    case easeOut
    
    var curve: UITimingCurveProvider {
        
        switch self {
        case .easeIn:
            return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.5, y: 0), controlPoint2: CGPoint(x: 1, y: 1))
        case .easeOut:
            return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.5, y: 0), controlPoint2: CGPoint(x: 0.4, y: 1))
        }
        
    }
    
}
