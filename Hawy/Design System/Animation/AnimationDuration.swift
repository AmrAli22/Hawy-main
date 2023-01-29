//
//  AnimationDuration.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/18/22.
//

import Foundation

enum AnimationDuration: TimeInterval {
    
    case fast = 0.5
    case normal = 2
    case slow = 5
    
    var timeInterval: TimeInterval {
        self.rawValue
    }
    
}

