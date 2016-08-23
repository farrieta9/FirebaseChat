//
//  LoginController.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
	
	let loginView: LoginView = {
		let view =  LoginView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(r: 100, g: 100, b: 100)
		
		self.navigationItem.title = "Login"
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.translucent = true
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() // Makes the back button white
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		
		setUpView()
		loginView.emailTextField.delegate = self
		loginView.passwordTextField.delegate = self
		loginView.loginButton.addTarget(self, action: #selector(handleLogin), forControlEvents: .TouchUpInside)
		loginView.signUpButton.addTarget(self, action: #selector(self.handleRegisterButton), forControlEvents: .TouchUpInside)
		hideKeyboardWhenTappedAround()
	}
	
	func setUpView() {
		view.addSubview(loginView)
		
		// need x, y, width, height
		loginView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		loginView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
		loginView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		loginView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	func handleLogin() {
		guard let email = loginView.emailTextField.text, password = loginView.passwordTextField.text else {
			return
		}
		
		if email.isEmpty || password.isEmpty {
			return
		}
		
		FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
			if error != nil {
				print(error)
				self.displayAlert("Error with email or password")
				print(error?.userInfo)
				return
			} else {
				self.dismissViewControllerAnimated(true, completion: nil)
			}
		})
	}
	
	func handleRegisterButton() {
		let registerController = RegisterController()
		navigationController?.pushViewController(registerController, animated: true)
	}
	
	private func displayAlert(message: String) {
		let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .Alert)
		
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertController.addAction(defaultAction)
		presentViewController(alertController, animated: true, completion: nil)
	}
}

extension LoginController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		handleLogin()
		return true
	}
}







