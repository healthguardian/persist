//
//  LoginViewController.swift
//  ForceFit
//
//  Created by Eden on 15.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet var textViews: [UIView]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIUtils.addShadow(to: self.loginButton, shadowColor: self.loginButton.backgroundColor!, yOffset: 2.0)
        UIUtils.addShadow(to: self.facebookView, shadowColor: self.facebookView.backgroundColor!, yOffset: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction
    
    @IBAction func onLoginButton(_ sender: Any) {
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
        
        self.showLoader()
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
    
    @IBAction func onForgotPasswordButton(_ sender: Any) {
        self.presentForgotPasswordAlert()
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
            placeholderText = "Enter your password"
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
            placeholderText = "Enter your password"
        }
        
        if textField.text == "" {
            if textField == self.passwordTextField {
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
    
    private func setupLoginView() {
        let borderColor = UIColor(red: 233.0/255.0, green: 236.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        UIUtils.apply(borderColor: borderColor, toView: self.loginView)
        for view in self.textViews {
            UIUtils.apply(borderColor: borderColor, toView: view)
        }
    }
    
    private func presentForgotPasswordAlert() {
        let alertController = UIAlertController(title: "Forgot password?", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Email Address"
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            guard let email = alertController.textFields?.first?.text else { return }
            AuthManager.sharedInstance.resetPassword(with: email, completion: { (error) in
                if error != nil {
                    self.showErrorAlert(title: "Error", message: "", okCompletion: nil)
                } else {
                    self.showErrorAlert(title: "Success", message: "", okCompletion: nil)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
