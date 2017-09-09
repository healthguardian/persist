//
//  ContractButton.swift
//  ForceFit
//
//  Created by Eden on 17.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class ContractButton: UIButton {
    
    @IBInspectable var sign: String!
    
    var signImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.height/2
        
        if self.signImageView == nil {
            let image = self.sign == "plus" ? #imageLiteral(resourceName: "exercise_plus") : #imageLiteral(resourceName: "exercise_minus")
            self.signImageView = UIImageView(image: image)
            self.addSubview(self.signImageView)
        }
        
        let width = self.frame.size.width/2
        self.signImageView.frame = CGRect(x: self.frame.size.width/2 - width/2, y: self.frame.size.height/2 - width/2, width: width, height: width)
        self.signImageView.contentMode = .scaleAspectFit
        self.signImageView.clipsToBounds = true
    }
}
