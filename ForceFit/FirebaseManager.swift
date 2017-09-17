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
import ObjectMapper
import SwiftDate

class FirebaseManager {
    static let shared = FirebaseManager()
    let databaseRef: DatabaseReference!
    
    init() {
        self.databaseRef = Database.database().reference()
    }
    
    func prepare() {
        currentUserReference()?.observe(.value, with: {
            guard let userDict = $0.value as? [String : Any] else { return }
            
            UserSource.sharedInstance.currentUser()?.cardToken = userDict["stripe_token"] as! String
            UserSource.sharedInstance.currentUser()?.penalty = userDict["penalty_value"] as! Int
            UserSource.sharedInstance.currentUser()?.exercisesPerWeek = userDict["number_of_exercises"] as! Int
            UserSource.sharedInstance.currentUser()?.paymentActive = userDict["payment_active"] as? Bool ?? false
            
            NotificationCenter.default.post(name: Notification.Name("UserChangedNotification"), object: nil)
        })
    }
    
    func currentUser(with completion: @escaping ([String: Any]?) -> ()) {
        let userReference = currentUserReference()
        userReference?.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            completion(dict)
        })
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
        
        let value: [String : Any] = [
            "number_of_exercises": exercises,
            "penalty_value": penalty,
            "stripe_token": cardToken,
            "card_name": cardName,
            "card_number": cardNumber,
            "payment_active" : true,
            "last_verified" : DateTransform().transformToJSON(Date().endWeek) ?? 0
        ]
        
        userReference?.setValue(value)
    }
    
    func activatePayment() {
        currentUserReference()?.child("payment_active").setValue(true)
    }
    
    func cancelPayment() {
        currentUserReference()?.child("payment_active").setValue(false)
    }
    
    //MARK: - Private
    
    func currentUserReference() -> DatabaseReference? {
        guard let id = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        return self.userReference(identifier: id)
    }
    
    private func userReference(identifier: String) -> DatabaseReference {
        return self.databaseRef.child("users").child(identifier)
    }
}
