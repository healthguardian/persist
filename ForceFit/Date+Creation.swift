//
//  Date+Creation.swift
//  ForceFit
//
//  Created by Vasyl Khmil on 9/14/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

extension Date {
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
}
