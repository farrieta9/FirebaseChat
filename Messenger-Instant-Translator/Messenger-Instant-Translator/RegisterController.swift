//
//  RegisterController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/26/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    let registerView: RegisterView = {
        let rv = RegisterView()
        rv.translatesAutoresizingMaskIntoConstraints = false
        return rv
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
    
    func setupView() {
        view.addSubview(registerView)
        registerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        registerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        registerView.usernameTextField.delegate = self
        registerView.emailTextField.delegate = self
        registerView.passwordTextField.delegate = self
        
        registerView.registerButton.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        registerView.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
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
    
    func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegisterButton() {
        
        if valideForm() == false {
            return
        }
        
        guard let email = registerView.emailTextField.text, let password = registerView.passwordTextField.text?.lowercased(), let username = registerView.usernameTextField.text?.lowercased() else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            } else {
                guard let uid = user?.uid else {
                    return
                }
                
                // Successfully created user in firebase
                let values = ["username": username, "email": email]
                FIRDatabase.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        self.displayAlert("Error")
                    } else {
                        self.handleBackButton()
                    }
                })
            }
        })
    }
    
    func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func valideForm() -> Bool {
        
        guard let email = registerView.emailTextField.text, let password = registerView.passwordTextField.text, let username = registerView.usernameTextField.text else {
            return false
        }
        
        if email.isEmpty || password.isEmpty || username.isEmpty {
            displayAlert("All entries must be filled")
            return false
        }
        
        if password.characters.count < 6 {
            displayAlert("Password must be 6 characters or more")
            return false
        }
        
        return true
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
