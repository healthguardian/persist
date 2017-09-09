//
//  ContractViewController.swift
//  ForceFit
//
//  Created by Eden on 16.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class ContractSetupViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PaymentCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var contractProgressImageViews: [UIImageView]!
    @IBOutlet var contractProgressLabels: [UILabel]!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    enum PickerType {
        case month, year, initial
    }
    
    @IBOutlet weak var paymentPickerView: UIPickerView!
    @IBOutlet weak var paymentPickerViewBottomConstraint: NSLayoutConstraint!
    
    var pickerType: PickerType = .initial
    let months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let years = ["2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025"]
    var selectedMonth: String!
    var selectedYear: String!
    
    let selectedPageColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 29.0/255.0, alpha: 1.0)
    let deselectedPageColor = UIColor(red: 134.0/255.0, green: 142.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.isHidden = true
        
        self.setupNavigationBar()
        self.setupCollectionView()
        
        self.paymentPickerView.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.reloadData()
    }
    
    //MARK: - IBAction
    
    @IBAction func onNextButton(_ sender: Any) {
        if self.currentPage == 0 {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! ContractCell
            UserSource.sharedInstance.setExercisesPerWeek(count: cell.exercisesCount)
        }
        
        if self.currentPage == 1 {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! PenaltyCell
            UserSource.sharedInstance.setPenalty(count: cell.penalty)
        }
        
        if self.currentPage == 2 {
            
        } else {
            self.currentPage += 1
            self.select(tab: self.currentPage)
        }
        
        if self.currentPage != 0 {
            self.backButton.isHidden = false
        } else {
            self.backButton.isHidden = true
        }
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.currentPage -= 1
        self.select(tab: self.currentPage)
    }
    
    @IBAction func onFirstButton(_ sender: Any) {
        self.currentPage = 0
        self.select(tab: self.currentPage)
    }
    
    @IBAction func onSecondTab(_ sender: Any) {
        self.currentPage = 1
        self.select(tab: self.currentPage)
    }
    
    @IBAction func onThirdTab(_ sender: Any) {
        self.currentPage = 2
        self.select(tab: self.currentPage)
    }
    
    @IBAction func onPaymentPickerDoneButton(_ sender: Any) {
        let cell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! PaymentCell
        cell.hidePicker()
        self.pickerType = .initial
        self.hidePickerView(animated: true)
    }
    
    //MARK: - UICollectionViewDelegate/DataSource/FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ContractCell.reuseIdentifier(), for: indexPath)
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: PenaltyCell.reuseIdentifier(), for: indexPath)
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCell.reuseIdentifier(), for: indexPath) as! PaymentCell
            cell.selectedYear = self.selectedYear
            cell.selectedMonth = self.selectedMonth
            cell.delegate = self
            cell.reloadData()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize()
    }
    
    //MARK: - PaymentCellDelegate
    
    func paymentCellDidSelectMonth() {
        if self.selectedMonth == nil {
            self.selectedMonth = self.months.first
            self.collectionView.reloadData()
        }
        if self.pickerType == .month {
            self.pickerType = .initial
            self.hidePickerView(animated: false)
        } else {
            self.pickerType = .month
            self.paymentPickerView.reloadAllComponents()
            self.hidePickerView(animated: false)
            self.showPickerView()
        }
    }
    
    func paymentCellDidSelectYear() {
        if self.selectedYear == nil {
            self.selectedYear = self.years.first
            self.collectionView.reloadData()
        }
        if self.pickerType == .year {
            self.pickerType = .initial
            self.hidePickerView(animated: false)
        } else {
            self.pickerType = .year
            self.paymentPickerView.reloadAllComponents()
            self.hidePickerView(animated: false)
            self.showPickerView()
        }
    }
    
    func paymentCellDidConfirmAction() {
        let cell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! PaymentCell
        let cardName = cell.getCardName()
        let cardNumber = cell.getCardNumber()
        let month = cell.selectedMonth
        let year = cell.selectedYear
        
        if cardName == "" {
            self.showErrorAlert(title: "Error", message: "Name on card field shouldn't be empty!", okCompletion: nil)
            return
        }
        if cardNumber == "" {
            self.showErrorAlert(title: "Error", message: "Card number field shouldn't be empty!", okCompletion: nil)
            return
        }
        if month == nil  {
            self.showErrorAlert(title: "Error", message: "Month field shouldn't be empty!", okCompletion: nil)
            return
        }
        if year == nil {
            self.showErrorAlert(title: "Error", message: "Year field shouldn't be empty!", okCompletion: nil)
            return
        }
        if !cell.isAgreeWithTerms() {
            self.showErrorAlert(title: "Error", message: "You must agree with thees terms!", okCompletion: nil)
            return
        }
        
        let card = Card(name: cardName, number: cardNumber, month: month!, year: year!)
        UserDefaults.standard.set(true, forKey: contractDidSetUpKey)
        self.showLoader()
        StripeManager.sharedInstance.createToken(with: card, completion: { (token, error) in
            guard token != nil else {
                self.hideLoader()
                self.showErrorAlert(title: "Error", message: error?.localizedDescription, okCompletion: nil)
                return
            }
            
            UserSource.sharedInstance.addCardToken(cardToken: token!)
            let user = UserSource.sharedInstance.currentUser()!
            FirebaseManager.sharedInstance.saveContract(exercises: user.exercisesPerWeek, penalty: user.penalty, cardToken: token!, cardName: cardName, cardNumber: cardNumber, completion: {
                self.hideLoader()
                Coordinator.presentContractViewController()
            })
        })
    }
    
    //MARK: - UIPickerViewDelegate/DataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerType == .month {
            return self.months.count
        } else if self.pickerType == .year {
            return self.years.count
        } else {
            return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.pickerType == .month {
            return self.months[row]
        } else if self.pickerType == .year {
            return self.years[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.pickerType == .month {
            self.selectedMonth = self.months[row]
        } else {
            self.selectedYear = self.years[row]
        }
        
        self.collectionView.reloadData()
    }
    
    //MARK: - Private
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCollectionView() {
        self.collectionView.register(ContractCell.nib(), forCellWithReuseIdentifier: ContractCell.reuseIdentifier())
        self.collectionView.register(PenaltyCell.nib(), forCellWithReuseIdentifier: PenaltyCell.reuseIdentifier())
        self.collectionView.register(PaymentCell.nib(), forCellWithReuseIdentifier: PaymentCell.reuseIdentifier())
    }
    
    private func updateNextButton() {
        self.nextButton.isHidden = self.currentPage == 2
        self.collectionViewBottomConstraint.constant = self.currentPage == 2 ? -72.0 : 0.0
        self.collectionView.reloadData()
        
        /*
        if self.currentPage == 2 {
            self.nextButton.setTitle("CONFIRM", for: .normal)
            self.nextButton.backgroundColor = UIColor(red: 121.0/255.0, green: 200.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            self.nextButtonLeadingConstraint.constant = 16.0
            self.nextButtonTrailingConstraint.constant = 16.0
            self.nextButtonBottomConstraint.constant = 16.0
            self.nextButtonTopConstraint.constant = 16.0
        } else {
            self.nextButton.setTitle("NEXT", for: .normal)
            self.nextButton.backgroundColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 29.0/255.0, alpha: 1.0)
            self.nextButtonLeadingConstraint.constant = 0.0
            self.nextButtonTrailingConstraint.constant = 0.0
            self.nextButtonBottomConstraint.constant = 0.0
            self.nextButtonTopConstraint.constant = 0.0
        }
         */
    }
    
    private func showPickerView(animated: Bool = true) {
        self.paymentPickerView.selectRow(0, inComponent: 0, animated: false)
        self.paymentPickerViewBottomConstraint.constant = -56.0
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            self.view.layoutSubviews()
        }
    }
    
    private func hidePickerView(animated: Bool = true) {
        self.paymentPickerViewBottomConstraint.constant = -236.0 - 56.0
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            self.view.layoutSubviews()
        }
        
        UIView.animate(withDuration: duration, animations: { 
            self.view.layoutSubviews()
        }) { (completed) in
            if completed {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func select(tab: Int) {
        
        self.collectionView.scrollToItem(at: IndexPath(item: tab, section: 0), at: .centeredHorizontally, animated: true)
        
        for imageView in self.contractProgressImageViews {
            imageView.image = #imageLiteral(resourceName: "contract_progress_point_deselected")
        }
        
        for i in 0..<3 {
            if i == self.currentPage {
                self.contractProgressImageViews[i].image = #imageLiteral(resourceName: "contract_progress_point_selected")
                self.contractProgressLabels[i].textColor = self.selectedPageColor
            } else {
                self.contractProgressImageViews[i].image = #imageLiteral(resourceName: "contract_progress_point_deselected")
                self.contractProgressLabels[i].textColor = self.deselectedPageColor
            }
        }
        
        if self.currentPage == 0 {
            self.backButton.isHidden = true
        } else {
            self.backButton.isHidden = false
        }
        
        self.updateNextButton()
    }
    
    private func itemSize() -> CGSize {
        let navigationBarHeight: CGFloat = 64.0
        let bottomSpacing: CGFloat = 16.0
        let nextButtonHeight: CGFloat = self.currentPage == 2 ? 0.0 : 56.0
        let collectionViewHeight = UIScreen.main.bounds.height - navigationBarHeight - bottomSpacing - nextButtonHeight
        let cellSize = CGSize(width: UIScreen.main.bounds.width, height: collectionViewHeight)
        
        return cellSize
    }
}
