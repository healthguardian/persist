//
//  PenaltyCell.swift
//  ForceFit
//
//  Created by Eden on 17.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class PenaltyCell: UICollectionViewCell {

    @IBOutlet weak var minusButton: ContractButton!
    @IBOutlet weak var plusButton: ContractButton!
    @IBOutlet weak var penaltyCountLabel: UILabel!
    
    @IBOutlet weak var estimatedWeeklyRewardLabel: UILabel!
    
    @IBOutlet weak var counterViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var counterViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var counterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rewardTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rewardDescriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelDescriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var minusButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var minusButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dollarSignTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var minusButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButtonTrailingConstraint: NSLayoutConstraint!
    
    var penalty: Int {
        get {
            return Int(self.penaltyCountLabel.text!)!
        }
        
        set {
            if newValue < penaltyMinValue {
                self.penaltyCountLabel.text = String(penaltyMinValue)
            } else if newValue > penaltyMaxValue {
                self.penaltyCountLabel.text = String(penaltyMaxValue)
            } else {
                self.penaltyCountLabel.text = String(newValue)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIScreen.main.bounds.width <= 320.0 {
            self.counterViewLeadingConstraint.constant = 10.0
            self.counterViewTrailingConstraint.constant = 10.0
            self.counterViewHeightConstraint.constant = 160.0
            self.infoViewBottomConstraint.constant = 0.0
            self.infoViewBottomConstraint.constant = 0.0
            self.cancelTitleTopConstraint.constant = 4.0
            self.rewardTitleTopConstraint.constant = 4.0
            self.cancelDescriptionBottomConstraint.constant = 4.0
            self.rewardDescriptionBottomConstraint.constant = 4.0
            self.minusButtonHeightConstraint.constant = 48.0
            self.minusButtonWidthConstraint.constant = 48.0
            self.plusButtonHeightConstraint.constant = 48.0
            self.plusButtonWidthConstraint.constant = 48.0
            self.dollarSignTopConstraint.constant = 20.0
            self.minusButtonLeadingConstraint.constant = 24.0
            self.plusButtonTrailingConstraint.constant = 24.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIUtils.addShadow(to: self.minusButton, shadowColor: self.minusButton.backgroundColor!, yOffset: 8.0, radius: 22, oval: true, opacity: 0.2)
        UIUtils.addShadow(to: self.plusButton, shadowColor: self.plusButton.backgroundColor!, yOffset: 8.0, radius: 22, oval: true, opacity: 0.2)
        UIUtils.addShadow(to: self.penaltyCountLabel, shadowColor: self.penaltyCountLabel.textColor)
    }
    
    //MARK: - IBActions
    
    @IBAction func onMinusButton(_ sender: Any) {
        self.penalty -= 5
        self.updateRewardLabel()
    }
    
    @IBAction func onPlusButton(_ sender: Any) {
        self.penalty += 5
        self.updateRewardLabel()
    }
    
    //MARK: - Private
    
    private func updateRewardLabel() {
        self.estimatedWeeklyRewardLabel.text = String(ForceFitCalculator.calculateWeeklyReward(penalty: self.penalty))
    }
}
