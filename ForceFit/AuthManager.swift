//
//  AuthManager.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class AuthManager {
    
    typealias AuthCompletion = (User?, Error?) -> Void
    
    static let sharedInstance = AuthManager()
    
    func authListener(listener: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let firebaseUser = user else {
                listener(nil)
                return
            }
            
            let appUser = User(name: firebaseUser.email ?? "", identifier: firebaseUser.uid)
            listener(appUser)
        }
    }
    
    func createNewUser(email: String, password: String, completion: @escaping AuthCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let firebaseUser = user else {
                completion(nil, error)
                return
            }
            
            let appUser = User(name: firebaseUser.email ?? "", identifier: firebaseUser.uid)
            completion(appUser, nil)
        }
    }
    
    func loginWithEmail(email: String, password: String, completion: @escaping AuthCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let firebaseUser = user else {
                completion(nil, error)
                return
            }
            
            let appUser = User(name: firebaseUser.email ?? "", identifier: firebaseUser.uid)
            completion(appUser, nil)
        }
    }
    
    func loginWithFacebook(from controller: UIViewController, completion: @escaping AuthCompletion) {
        FacebookUtility.login(with: .read, from: controller) { (response, error) in
            if response == .success {
                let credential = FacebookAuthProvider.credential(withAccessToken: FacebookUtility.currentToken().tokenString)
                self.configureLogin(with: credential, completion: { (user, error) in
                    completion(user, nil)
                })
            } else {
                completion(nil, error)
            }
        }
    }
    
    func configureLogin(with credential: AuthCredential, completion: @escaping AuthCompletion) {
        Auth.auth().signIn(with: credential) { (user, error) in
            guard let firebaseUser = user else {
                completion(nil, error)
                return
            }
            
            let appUser = User(name: firebaseUser.email ?? "", identifier: firebaseUser.uid)
            completion(appUser, nil)
        }
    }
    
    func resetPassword(with email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        })
    }
    
    func signOut() {
        try! Auth.auth().signOut()
    }
}
