//
//  PaymentDetailsCell.swift
//  ForceFit
//
//  Created by Eden on 18.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

protocol PaymentsDetailsCellDelegate {
    func paymentCellDidSelectMonth()
    func paymentCellDidSelectYear()
}

class PaymentDetailsCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var borderedViews: [UIView]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthArrow: UIImageView!
    @IBOutlet weak var yearArrow: UIImageView!
    
    var cardName: String {
        get {
            if self.nameTextField.text == "" {
                return ""
            } else {
                return self.nameTextField.text!
            }
        }
        
        set {
            self.nameTextField.text = newValue
        }
    }
    var cardNumber: String {
        get {
            if self.cardNumberTextField.text == "Card number" {
                return ""
            } else {
                return self.cardNumberTextField.text!
            }
        }
        
        set {
            self.cardNumberTextField.text = newValue
        }
    }
    
    var delegate: PaymentsDetailsCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        for view in self.borderedViews {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor(red: 233.0/255.0, green: 236.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        }
        
        self.nameTextField.delegate = self
        self.cardNumberTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hidePicker() {
        self.monthArrow.transform = CGAffineTransform(rotationAngle: 0.0)
        self.yearArrow.transform = CGAffineTransform(rotationAngle: 0.0)
    }
    
    //MARK: - IBAction
    
    @IBAction func onMonthButton() {
        self.delegate?.paymentCellDidSelectMonth()
        if self.monthArrow.transform == CGAffineTransform(rotationAngle: CGFloat.pi) {
            self.monthArrow.transform = CGAffineTransform(rotationAngle: 0.0)
        } else {
            self.yearArrow.transform = CGAffineTransform(rotationAngle: 0.0)
            self.monthArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    @IBAction func onYearButton() {
        self.delegate?.paymentCellDidSelectYear()
        if self.yearArrow.transform == CGAffineTransform(rotationAngle: CGFloat.pi) {
            self.yearArrow.transform = CGAffineTransform(rotationAngle: 0.0)
        } else {
            self.yearArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.monthArrow.transform = CGAffineTransform(rotationAngle: 0.0)
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nameTextField {
            if textField.text == "Name on card" {
               textField.text = ""
            }
        } else {
            if textField.text == "Card number" {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameTextField {
            if textField.text == "" {
                textField.text = "Name on card"
            }
        } else {
            if textField.text == "" {
                textField.text = "Card number"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
