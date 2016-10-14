//
//  RegisterController.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
	
	let registerView: RegisterView = {
		let view = RegisterView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(r: 100, g: 100, b: 100)
		
		setUpView()
		registerView.emailTextField.delegate = self
		registerView.passwordTextField.delegate = self
		registerView.usernameTextField.delegate = self
		registerView.signUpButton.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
		hideKeyboardWhenTappedAround()
	}
	
	func handleSignUpButton() {
		
		guard let email = registerView.emailTextField.text, let password = registerView.passwordTextField.text?.lowercased(), let username = registerView.usernameTextField.text?.lowercased() else {
			return
		}
		
		FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
			if error != nil {
				print(error)
				return
			} else {
				
				guard let uid = user?.uid else {
					return
				}
				
				// Successfully created user in firebase
				let values = ["username": username, "email": email]
					FIRDatabase.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
						if error != nil {
							print(error)
							self.displayAlert("Error")
							
						} else {
							self.navigationController?.popViewController(animated: true)
						}
					})
			}
		})
	}
	
	func setUpView() {
		view.addSubview(registerView)
		registerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		registerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		registerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		registerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
	}
	
	fileprivate func displayAlert(_ message: String) {
		let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
		
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(defaultAction)
		present(alertController, animated: true, completion: nil)
	}
}

extension RegisterController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		handleSignUpButton()
		return true
	}
}
