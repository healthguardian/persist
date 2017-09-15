//
//  ProgressView.swift
//  ForceFit
//
//  Created by Eden on 19.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let width: CGFloat = 8.0
        
        let grayPath = UIBezierPath(arcCenter: center,
                                radius: CGFloat(radius/2 - width/2),
                                startAngle: 2*CGFloat.pi,
                                endAngle: -2*CGFloat.pi,
                                clockwise: false)
        grayPath.lineWidth = CGFloat(width)
        let grayColor = UIColor(red: 219.0/255.0, green: 223.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        grayColor.setStroke()
        grayPath.stroke()
        
        let path = UIBezierPath(arcCenter: center,
                                radius: CGFloat(radius/2 - width/2),
                                startAngle: -CGFloat.pi/2 + progress * 2 * CGFloat.pi,
                                endAngle: -CGFloat.pi/2,
                                clockwise: false)
        path.lineWidth = CGFloat(width)
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        redColor.setStroke()
        path.stroke()
    }
}
