//
//  SignUpViewController.swift
//  ForceFit
//
//  Created by Eden on 8/11/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet var createAccountView: UIView!
    @IBOutlet var textViews: [UIView]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var facebookView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCreateAccountView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIUtils.addShadow(to: self.createButton, shadowColor: self.createButton.backgroundColor!)
        UIUtils.addShadow(to: self.facebookView, shadowColor: self.facebookView.backgroundColor!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction
    
    @IBAction func onCreateButton(_ sender: Any) {
        let emailValidationError = ValidationManager.validate(email: self.emailTextField.text)
        guard emailValidationError == nil else {
            self.showErrorAlert(title: "Error", message: emailValidationError, okCompletion: nil)
            return
        }
        let email = self.emailTextField.text!
        
        let passwordValidationError = ValidationManager.validate(password: self.passwordTextField.text)
        guard passwordValidationError == nil else {
            self.showErrorAlert(title: "Error", message: passwordValidationError, okCompletion: nil)
            return
        }
        let password = self.passwordTextField.text!
        
        let passwordConfirmationError = ValidationManager.confirm(passwords: password, confirmation: self.confirmTextField.text)
        guard passwordConfirmationError == nil else {
            self.showErrorAlert(title: "Error", message: passwordConfirmationError, okCompletion: nil)
            return
        }
        
        self.showLoader()
        AuthManager.sharedInstance.createNewUser(email: email, password: password) { (user, error) in
            guard nil != user else {
                self.hideLoader()
                self.showErrorAlert(title: "Error", message: error?.localizedDescription, okCompletion: nil)
                return
            }
            
            AuthManager.sharedInstance.loginWithEmail(email: email, password: password) { (user, error) in
                self.hideLoader()
                guard user != nil else {
                    self.showErrorAlert(title: "Error", message: error?.localizedDescription, okCompletion: nil)
                    return
                }
                
                UserSource.sharedInstance.setCurrentUser(user: user!)
                Coordinator.presentContractViewController()
            }
        }
    }
    
    @IBAction func onFacebookButton(_ sender: Any) {
        self.showLoader()
        AuthManager.sharedInstance.loginWithFacebook(from: self.navigationController!) { (user, error) in
            self.hideLoader()
            guard nil != user else {
                return
            }
            
            UserSource.sharedInstance.setCurrentUser(user: user!)
            Coordinator.presentContractViewController()
        }
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var placeholderText = ""
        
        if textField == self.emailTextField {
            placeholderText = "Enter your email"
        }
        
        if textField == self.passwordTextField {
            textField.isSecureTextEntry = true
            placeholderText = "Create your password"
        }
        
        if textField == self.confirmTextField {
            textField.isSecureTextEntry = true
            placeholderText = "Confirm your password"
        }
        
        if textField.text == placeholderText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var placeholderText = ""
        
        if textField == self.emailTextField {
            placeholderText = "Enter your email"
        }
        
        if textField == self.passwordTextField {
            placeholderText = "Create your password"
        }
        
        if textField == self.confirmTextField {
            placeholderText = "Confirm your password"
        }
        
        if textField.text == "" {
            if textField == self.passwordTextField || textField == self.confirmTextField {
                textField.isSecureTextEntry = false
            }
            
            textField.text = placeholderText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Private
    
    private func setupCreateAccountView() {
        let borderColor = UIColor(red: 233.0/255.0, green: 236.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        UIUtils.apply(borderColor: borderColor, toView: self.createAccountView)
        for view in self.textViews {
            UIUtils.apply(borderColor: borderColor, toView: view)
        }
    }
}
