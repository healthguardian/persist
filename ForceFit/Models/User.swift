//
//  User.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

class User {
    let userIdentifier: String
    let name: String
    var cardToken: String = ""
    var exercisesPerWeek: Int = 2
    var penalty: Int = 5
    
    init(name: String, identifier: String) {
        self.name = name
        self.userIdentifier = identifier
    }
}
