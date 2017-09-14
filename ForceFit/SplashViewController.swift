//
//  SplashViewController.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit
import FirebaseAuth

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .lightContent
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard nil != user else {
                Coordinator.presentHomeViewController()
                return
            }
            
            FirebaseManager.shared.userWithIdentifier(identifier: user!.uid, completion: { (dict) in
                guard let userDict = dict else {
                    Coordinator.presentContractSetupViewController()
                    return
                }
                
                let user = User(name: user!.email!, identifier: user!.uid)
                user.cardToken = userDict["stripe_token"] as! String
                user.penalty = userDict["penalty_value"] as! Int
                user.exercisesPerWeek = userDict["number_of_exercises"] as! Int
                UserSource.sharedInstance.setCurrentUser(user: user)
                
                Coordinator.presentContractViewController()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
