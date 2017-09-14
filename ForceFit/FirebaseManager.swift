//
//  FirebaseManager.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    let databaseRef: DatabaseReference!
    
    init() {
        self.databaseRef = Database.database().reference()
    }
    
    func userWithIdentifier(identifier: String, completion: @escaping ([String: AnyObject]?) -> ()) {
        let userReference = self.userReference(identifier: identifier)
        userReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                completion(nil)
                return 
            }
            completion(dict)
        })
    }
    
    func saveContract(exercises: Int, penalty: Int, cardToken: String, cardName: String, cardNumber: String, completion: @escaping () -> ()) {
        let userReference = self.currentUserReference()
        userReference?.observeSingleEvent(of: .value, with: { (snapshot) in
            completion()
        })
        
        userReference?.setValue(["number_of_exercises": exercises,
                                "penalty_value": penalty,
                                "stripe_token": cardToken,
                                "card_name": cardName,
                                "card_number": cardNumber])
    }
    
    //MARK: - Private
    
    func currentUserReference() -> DatabaseReference? {
        guard let id = UserSource.sharedInstance.currentUser()?.userIdentifier else {
            return nil
        }
        
        return self.userReference(identifier: id)
    }
    
    private func userReference(identifier: String) -> DatabaseReference {
        return self.databaseRef.child("users").child(identifier)
    }
}
