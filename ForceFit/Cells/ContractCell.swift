//
//  ContractCell.swift
//  ForceFit
//
//  Created by Eden on 17.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class ContractCell: UICollectionViewCell {

    @IBOutlet weak var minusButton: ContractButton!
    @IBOutlet weak var plusButton: ContractButton!
    @IBOutlet weak var exercisesCountLabel: UILabel!
    
    @IBOutlet weak var counterViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var counterViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var counterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var minusButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var minusButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var minusButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButtonTrailingConstraint: NSLayoutConstraint!
    
    var exercisesCount: Int {
        get {
            return Int(self.exercisesCountLabel.text!)!
        }
        
        set {
            if newValue < workoutsMinValue {
                self.exercisesCountLabel.text = String(workoutsMinValue)
            } else if newValue > workoutsMaxValue {
                self.exercisesCountLabel.text = String(workoutsMaxValue)
            } else {
                self.exercisesCountLabel.text = String(newValue)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIScreen.main.bounds.width <= 320.0 {
            self.counterViewLeadingConstraint.constant = 10.0
            self.counterViewTrailingConstraint.constant = 10.0
            self.iconsViewBottomConstraint.constant = 0.0
            self.counterViewHeightConstraint.constant = 160.0
            self.minusButtonHeightConstraint.constant = 48.0
            self.minusButtonWidthConstraint.constant = 48.0
            self.plusButtonHeightConstraint.constant = 48.0
            self.plusButtonWidthConstraint.constant = 48.0
            self.minusButtonLeadingConstraint.constant = 24.0
            self.plusButtonTrailingConstraint.constant = 24.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIUtils.addShadow(to: self.minusButton, shadowColor: self.minusButton.backgroundColor!, yOffset: 8.0, radius: 22, oval: true, opacity: 0.2)
        UIUtils.addShadow(to: self.plusButton, shadowColor: self.plusButton.backgroundColor!, yOffset: 8.0, radius: 22, oval: true, opacity: 0.2)
        UIUtils.addShadow(to: self.exercisesCountLabel, shadowColor: self.exercisesCountLabel.textColor)
    }
    
    @IBAction func onMinusButton(_ sender: Any) {
        self.exercisesCount -= 1
    }
    
    @IBAction func onPlusButton(_ sender: Any) {
        self.exercisesCount += 1
    }
}
