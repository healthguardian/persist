//
//  TermsCell.swift
//  ForceFit
//
//  Created by Eden on 18.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

protocol TermsCellDelegate {
    func termsCellDidConfirmAction()
}

class TermsCell: UITableViewCell {

    @IBOutlet weak var contractLabel: UILabel!
    @IBOutlet weak var acceptImageView: UIImageView!
    @IBOutlet weak var checkboxView: UIView!
    @IBOutlet weak var termsViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: TermsCellDelegate?
    
    var accepted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attributedContract = NSMutableAttributedString(string: "Contract - I commit to exercise at least [xx] times per week. Change\n\nPenalties - If I do not complete my [xx] workouts by the end of the week (Sunday 12:00pm), I will be charged [xx] US$ per workout missed. Change\n\nRewards - If I complete all my workouts by the end of the week, I will be rewarded [xx] US$.\n\nCancellations - I can cancel my contract anytime by tapping “Modify or cancel”. I can’t cancel a week in progress. Cancellations take effect starting the following week.", attributes: [NSFontAttributeName: UIFont(name: "Lato-Regular", size: 16.0)!, NSForegroundColorAttributeName: UIColor(red: 78.0/255.0, green: 85.0/255.0, blue: 91.0/255.0, alpha: 1.0)])
        let rangeOfContract = attributedContract.mutableString.range(of: "Contract")
        attributedContract.addAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: 16.0)!], range: rangeOfContract)
        let rangeOfPenalties = attributedContract.mutableString.range(of: "Penalties")
        attributedContract.addAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: 16.0)!], range: rangeOfPenalties)
        let rangeOfReward = attributedContract.mutableString.range(of: "Rewards")
        attributedContract.addAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: 16.0)!], range: rangeOfReward)
        let rangeOfCancellations = attributedContract.mutableString.range(of: "Cancellations")
        attributedContract.addAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: 16.0)!], range: rangeOfCancellations)
        
        self.contractLabel.attributedText = attributedContract
        
        UIUtils.apply(borderColor: UIColor(red: 121.0/255.0, green: 200.0/255.0, blue: 59.0/255.0, alpha: 1.0), toView: self.checkboxView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onAcceptButton(_ sender: Any) {
        self.accepted = !self.accepted
        self.acceptImageView.image = self.accepted ? #imageLiteral(resourceName: "terms_checkbox_checked") : nil
        self.checkboxView.isHidden = self.accepted ? true : false
    }
    @IBAction func onConfirmButton(_ sender: Any) {
        self.delegate?.termsCellDidConfirmAction()
    }
    
}
