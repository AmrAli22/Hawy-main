//
//  AnimationDesignSystem.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/18/22.
//

import Foundation
import UIKit

extension DesignSystem {
    
    enum AnimationDesignSystem {
        
        case easeIn(duration: AnimationDuration)
        
        var animator: UIViewPropertyAnimator {
            
            switch self {
            case .easeIn(let duration):
                return UIViewPropertyAnimator(duration: duration.timeInterval, timingParameters: AnimationTiming.easeIn.curve)
            }
            
        }
        
    }
    
}
