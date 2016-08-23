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
		registerView.signUpButton.addTarget(self, action: #selector(handleSignUpButton), forControlEvents: .TouchUpInside)
		hideKeyboardWhenTappedAround()
	}
	
	func handleSignUpButton() {
		
		guard let email = registerView.emailTextField.text, password = registerView.passwordTextField.text?.lowercaseString, username = registerView.usernameTextField.text?.lowercaseString else {
			return
		}
		
		FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
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
							self.navigationController?.popViewControllerAnimated(true)
						}
					})
			}
		})
	}
	
	func setUpView() {
		view.addSubview(registerView)
		registerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		registerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
		registerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		registerView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
	}
	
	private func displayAlert(message: String) {
		let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .Alert)
		
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertController.addAction(defaultAction)
		presentViewController(alertController, animated: true, completion: nil)
	}
}

extension RegisterController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		handleSignUpButton()
		return true
	}
}
