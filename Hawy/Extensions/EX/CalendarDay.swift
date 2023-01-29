//
//  CalendarDay.swift
//  Hawy
//
//  Created by ahmed abu elregal on 09/09/2022.
//

import Foundation

class CalendarDay {
    var day: String!
    var month: Month!
    
    enum Month {
        case previous
        case current
        case next
    }
}
