//
//  WorkoutsManager.swift
//  ForceFit
//
//  Created by Vasyl Khmil on 9/14/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

class WorkoutsManager {
    static let shared = WorkoutsManager()
    
    let workoutsChangedNotification = Notification.Name("ForceFit.WorkoutsChangedNotification")
    
    private let workoutsRef = Database.database().reference().child("workouts")
    
    private var userWorkoutsRef: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        return workoutsRef.child(uid)
    }
    
    var workouts: [Workout] = [] {
        didSet {
            NotificationCenter.default.post(name: workoutsChangedNotification, object: self)
        }
    }
    
    func addWorkout() {
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let workout = Workout(uid: id)
        userWorkoutsRef?.childByAutoId().setValue(workout.toJSON())
    }
    
    func prepare() {
        let transform = DateTransform()
        
        let startWeekValue = transform.transformToJSON(Date().startOfWeek)
        let endWeekValue = transform.transformToJSON(Date().endOfWeek)
        
        userWorkoutsRef?
            .queryOrdered(byChild: "created")
            .queryStarting(atValue: startWeekValue)
            .queryEnding(atValue: endWeekValue)
            .observe(.value, with:  {
                
                guard let value = $0.value as? [String : [String : Any]] else {
                    return
                }
                
                var workouts: [Workout] = []
                
                for pair in value {
                    let map = Map(mappingType: .fromJSON, JSON: pair.value)
                    let workout = Workout(map: map)
                    workouts.append(workout)
                }
                
                self.workouts = workouts
            })
    }
}
