//
//  Workout.swift
//  ForceFit
//
//  Created by Vasyl Khmil on 9/14/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import ObjectMapper

class Workout: Mappable {
    
    var created: Date = Date()
    var uid: String?
    
    init(uid: String) {
        self.uid = uid
    }
    
    required init(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.created <- (map["created"], DateTransform())
        self.uid <- map["uid"]
    }
}
