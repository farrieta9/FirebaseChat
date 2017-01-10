//
//  LoginController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let loginView: LoginView = {
        let login = LoginView()
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onkeyboardShown), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHidden), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func onkeyboardShown() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func onKeyboardHidden() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func handleLogin() {
        if isValidForm() == false {
            return
        }
        
        guard let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                self.displayAlert("Error with email or password")
                return
            }
            
            self.finishLogginIn()
        })
    }
    
    func finishLogginIn() {
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        
        self.loginView.emailTextField.text = ""
        self.loginView.passwordTextField.text = ""
        self.showMessengerController()
    }
    
    func showMessengerController() {        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else {
            return
        }
        
        mainNavigationController.viewControllers = [MessengerController()]
        
        dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func isValidForm() -> Bool {
        guard let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text else {
            return false
        }
        
        if email.isEmpty || password.isEmpty {
            displayAlert("All entries must be filled")
            return false
        }
        
        if password.characters.count < 6 {
            displayAlert("Password must be 6 characters or more")
            return false
        }
        
        return true
    }
    
    func handleRegister() {
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
    
    private func setupView() {
        view.addSubview(loginView)
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
