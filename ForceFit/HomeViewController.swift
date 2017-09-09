//
//  HomeViewController.swift
//  ForceFit
//
//  Created by Eden on 8/10/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - IBActions
    
    @IBAction func onSignUpBtnClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
}

