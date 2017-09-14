//
//  ContractViewController.swift
//  ForceFit
//
//  Created by Eden on 16.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class ContractViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var penaltyLabel: UILabel!
    @IBOutlet weak var modifyContractLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupTableView()
        self.setupContractView()
        
        subsribeToNotifications()
        
        WorkoutsManager.shared.prepare()
    }

    private func subsribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContractViewController.workoutsUpdated), name: WorkoutsManager.shared.workoutsChangedNotification, object: WorkoutsManager.shared)
    }
    
    //MARK: Actions
    
    @IBAction private func trackPressed() {
        WorkoutsManager.shared.addWorkout()
    }
    
    //MARK: - UITableViewDelegate/DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreviousWeekCell.reuseIdentifier()) as! PreviousWeekCell
        return cell
    }
    
    //MARK: - Private
    
    private func setupNavigationBar() {
        self.navigationItem.title = "MY WORKOUTS".localized
    }
    
    private func setupContractView() {
        self.completedLabel.text = "0/" + String(UserSource.sharedInstance.currentUser()!.exercisesPerWeek)
        self.totalLabel.text = "0"
        self.rewardLabel.text = "$0.00"
        self.penaltyLabel.text = "You pay".localized + " $\(UserSource.sharedInstance.currentUser()!.penalty).00 " + "per missed workout.".localized
        self.modifyContractLabel.attributedText = NSAttributedString(string: self.modifyContractLabel.attributedText!.string, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
    }
    
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(PreviousWeekCell.nib(), forCellReuseIdentifier: PreviousWeekCell.reuseIdentifier())
    }
    
    @objc func workoutsUpdated() {
        updateCompleted()
    }
    
    private func updateCompleted() {
        self.completedLabel.text = String(WorkoutsManager.shared.workouts.count) + "/" + String(UserSource.sharedInstance.currentUser()!.exercisesPerWeek)
    }
}
