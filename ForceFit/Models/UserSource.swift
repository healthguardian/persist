//
//  UserSource.swift
//  ForceFit
//
//  Created by Eden on 18.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

class UserSource {
    
    static let sharedInstance = UserSource()
    private var user: User?
    
    func setCurrentUser(user: User) {
        self.user = user
    }
    
    func currentUser() -> User? {
        return self.user
    }
    
    func addCardToken(cardToken: String) {
        self.user!.cardToken = cardToken
    }
    
    func setExercisesPerWeek(count: Int) {
        self.user!.exercisesPerWeek = count
    }
    
    func setPenalty(count: Int) {
        self.user!.penalty = count
    }
}
