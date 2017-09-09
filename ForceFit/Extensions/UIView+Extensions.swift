//
//  UIView+Extensions.swift
//  ForceFit
//
//  Created by Eden on 17.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func reuseIdentifier() -> String {
        return String(describing: self) + "Identifier"
    }
    
    class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
