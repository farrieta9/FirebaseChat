//
//  RegisterView.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class RegisterView: UIView {
	
	let inputContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		view.layer.masksToBounds = true
		return view
	}()
	
	let usernameTextField: UITextField = {
		let textfield = UITextField()
		textfield.placeholder = "Username"
		textfield.translatesAutoresizingMaskIntoConstraints = false
		textfield.autocorrectionType = .no
		textfield.keyboardType = .default
		textfield.autocapitalizationType = .none
		return textfield
	}()
	
	let emailTextField: UITextField = {
		let textfield = UITextField()
		textfield.placeholder = "Email"
		textfield.translatesAutoresizingMaskIntoConstraints = false
		textfield.autocorrectionType = .no
		textfield.keyboardType = .emailAddress
		textfield.autocapitalizationType = .none
		return textfield
	}()
	
	let emailSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
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
		textfield.isSecureTextEntry = true
		textfield.keyboardType = .default
		textfield.autocorrectionType = .no
		textfield.autocapitalizationType = .none
		return textfield
	}()
	
	let signUpButton: UIButton = {
		let button = UIButton()
		button.setTitle("Sign Up", for: UIControlState())
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(UIColor.white, for: UIControlState())
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(inputContainerView)
		addSubview(signUpButton)
		
		// need x, y, width, height
		inputContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		inputContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		inputContainerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
		inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
		
		inputContainerView.addSubview(usernameTextField)
		inputContainerView.addSubview(nameSeparatorView)
		inputContainerView.addSubview(emailTextField)
		inputContainerView.addSubview(emailSeparatorView)
		inputContainerView.addSubview(passwordTextField)
		
		usernameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		usernameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
		usernameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
		usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
		
		nameSeparatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		nameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
		nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
		emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
		emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
		
		emailSeparatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
		emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
		passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
		passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true

		signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		signUpButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
		signUpButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
