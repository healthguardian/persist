//
//  PaymentCell.swift
//  ForceFit
//
//  Created by Eden on 18.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

protocol PaymentCellDelegate {
    func paymentCellDidSelectMonth()
    func paymentCellDidSelectYear()
    func paymentCellDidConfirmAction()
}

class PaymentCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, PaymentsDetailsCellDelegate, TermsCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: PaymentCellDelegate?
    
    var selectedMonth: String!
    var selectedYear: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTableView()
    }
    
    func hidePicker() {
        let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! PaymentDetailsCell
        cell.hidePicker()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func getCardName() -> String {
        guard let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? PaymentDetailsCell else { return "" }
        return cell.cardName
    }
    
    func getCardNumber() -> String {
        guard let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? PaymentDetailsCell else { return "" }
        return cell.cardNumber
    }
    
    func isAgreeWithTerms() -> Bool {
        let cell = self.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! TermsCell
        return cell.accepted
    }
    
    //MARK: - UITableViewDelegate/ DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 327.0
        } else {
            return 510.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentDetailsCell.reuseIdentifier()) as! PaymentDetailsCell
            if self.selectedMonth != nil {
                cell.monthLabel.text = self.selectedMonth
            }
            if self.selectedYear != nil {
                cell.yearLabel.text = self.selectedYear
            }
            
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TermsCell.reuseIdentifier())! as! TermsCell
            cell.delegate = self
            
            return cell
        }
    }
    
    //MARK: - PaymentsDetailsCellDelegate
    
    func paymentCellDidSelectYear() {
        self.delegate?.paymentCellDidSelectYear()
    }
    
    func paymentCellDidSelectMonth() {
        self.delegate?.paymentCellDidSelectMonth()
    }
    
    //MARK: - TermsCellDelegate
    
    func termsCellDidConfirmAction() {
        self.delegate?.paymentCellDidConfirmAction()
    }
    
    //MARK: - Private
    
    private func setupTableView() {
        self.tableView.register(PaymentDetailsCell.nib(), forCellReuseIdentifier: PaymentDetailsCell.reuseIdentifier())
        self.tableView.register(TermsCell.nib(), forCellReuseIdentifier: TermsCell.reuseIdentifier())
    }
}
