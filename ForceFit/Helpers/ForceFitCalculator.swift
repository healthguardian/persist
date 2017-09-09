//
//  ForeFitCalculator.swift
//  ForceFit
//
//  Created by Eden on 24.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

class ForceFitCalculator {
    
    private static let week = 7.0
    private static let month = 30.0
    
    static func calculateReward(penalty value: Int) -> Double {
        if value >= 5 && value <= 10 {
            return 0.50
        } else if value >= 15 && value <= 20 {
            return 0.70
        } else if value >= 25 && value <= 30 {
            return 0.95
        } else if value >= 35 && value <= 40 {
            return 1.25
        } else if value >= 45 && value <= 50 {
            return 1.60
        }
        
        return 0.0
    }
    
    static func calculateWeeklyReward(penalty value: Int) -> Double {
        return self.calculateReward(penalty: value) * self.week
    }
    
    static func calculateMonthReward(penalty value: Int) -> Double {
        return self.calculateReward(penalty: value) * self.month
    }
    
}
