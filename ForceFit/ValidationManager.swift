//
//  ValidationManager.swift
//  ForceFit
//
//  Created by Eden on 16.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

class ValidationManager {
    class func validate(email emailString: String?) -> String? {
        if emailString == nil || emailString == "" {
            return "Email field shouldn't be empty!"
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: emailString) {
            return "Please enter a valid email"
        }
        
        return nil
    }
    
    class func validate(password passwordString: String?) -> String? {
        if passwordString == nil || passwordString == "" {
            return "Password field shouldn't be empty!"
        }
        
        if passwordString!.characters.count < 6 {
            return "Password should be 6 characters at least!"
        }
        
        return nil
    }
    
    class func confirm(passwords password: String, confirmation: String?) -> String? {
        if confirmation == nil || confirmation == "" {
            return "Password doesn't match"
        }
        
        if confirmation != password {
            return "Password doesn't match"
        }
        
        return nil
    }
}
