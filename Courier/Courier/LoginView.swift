//
//  LoginView.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class LoginView: UIView {
	
	let inputContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.whiteColor()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		view.layer.masksToBounds = true
		return view
	}()
	
	let emailTextField: UITextField = {
		let textfield = UITextField()
		textfield.placeholder = "Email"
		textfield.translatesAutoresizingMaskIntoConstraints = false
		textfield.autocapitalizationType = .None
		return textfield
	}()
	
	let nameSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let passwordTextField: UITextField = {
		let textfield = UITextField()
		textfield.placeholder = "Password"
		textfield.translatesAutoresizingMaskIntoConstraints = false
		textfield.secureTextEntry = true
		textfield.autocapitalizationType = .None
		return textfield
	}()
	
	let loginButton: UIButton = {
		let button = UIButton()
		button.setTitle("Login", forState: .Normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor(r: 20, g: 101, b: 161)
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		return button
	}()
	
	let signUpButton: UIButton = {
		let button = UIButton()
		button.setTitle("Sign Up", forState: .Normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(inputContainerView)
		addSubview(loginButton)
		addSubview(signUpButton)
		
		// need x, y, width, height
		inputContainerView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		inputContainerView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
		inputContainerView.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -24).active = true
		inputContainerView.heightAnchor.constraintEqualToConstant(100).active = true
		
		inputContainerView.addSubview(emailTextField)
		inputContainerView.addSubview(passwordTextField)
		inputContainerView.addSubview(nameSeparatorView)
		
		emailTextField.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
		emailTextField.topAnchor.constraintEqualToAnchor(inputContainerView.topAnchor, constant: 0).active = true
		emailTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, constant: -24).active = true
		emailTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/2).active = true
		
		nameSeparatorView.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
		nameSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
		nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
		nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
		
		passwordTextField.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
		passwordTextField.topAnchor.constraintEqualToAnchor(nameSeparatorView.bottomAnchor).active = true
		passwordTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, constant: -24).active = true
		passwordTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/2).active = true
		
		loginButton.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
		loginButton.topAnchor.constraintEqualToAnchor(inputContainerView.bottomAnchor, constant: 8).active = true
		loginButton.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
		loginButton.heightAnchor.constraintEqualToConstant(50).active = true
		
		signUpButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		signUpButton.topAnchor.constraintEqualToAnchor(loginButton.bottomAnchor, constant: 8).active = true
		signUpButton.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
		signUpButton.heightAnchor.constraintEqualToAnchor(loginButton.heightAnchor).active = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
