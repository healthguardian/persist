//
//  Coordinator.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    class func presentHomeViewController() {
        self.presentControllerWithIdentifier(identifier: "HomeNavigationController")
    }
    
    class func presentContractViewController() {
        if UserDefaults.standard.bool(forKey: contractDidSetUpKey) {
            self.presentControllerWithIdentifier(identifier: "ContractNavigationController")
        } else {
            self.presentControllerWithIdentifier(identifier: "ContractSetupNavigationController")
        }
    }
    
    private class func presentControllerWithIdentifier(identifier: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootWindow = appDelegate.window else { return }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = mainStoryboard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        rootWindow.rootViewController = navigationVC
    }
}
