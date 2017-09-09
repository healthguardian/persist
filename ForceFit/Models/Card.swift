//
//  Card.swift
//  ForceFit
//
//  Created by Eden on 18.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

class Card {
    let name: String
    let number: String
    let month: String
    let year: String
    
    init(name: String, number:String, month: String, year: String) {
        self.name = name
        self.number = number
        self.month = month
        self.year = year
    }
}
