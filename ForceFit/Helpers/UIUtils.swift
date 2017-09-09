//
//  UIUtils.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import UIKit

class UIUtils {
    
    class func apply(borderWidth: CGFloat = 1.0, borderColor: UIColor, toView: UIView) {
        toView.layer.borderWidth = borderWidth
        toView.layer.borderColor = borderColor.cgColor
    }
    
    class func addShadow(to view: UIView, shadowColor: UIColor, yOffset: CGFloat = 2, radius: CGFloat = 1, oval: Bool = false, opacity: CGFloat = 0.5) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = Float(opacity)
        view.layer.shadowOffset = CGSize(width: 0, height: yOffset)
        view.layer.shadowRadius = radius
        view.layer.shadowPath = oval ? UIBezierPath(ovalIn: view.bounds).cgPath : UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func addShadow(to label: UILabel, shadowColor: UIColor) {
        label.layer.shadowColor = shadowColor.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.2
        label.layer.shadowOffset = CGSize(width: 0, height: 6)
        label.layer.masksToBounds = false
    }
}
