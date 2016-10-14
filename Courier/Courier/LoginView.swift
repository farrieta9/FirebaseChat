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
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		view.layer.masksToBounds = true
		return view
	}()
	
	let emailTextField: UITextField = {
		let textfield = UITextField()
		textfield.placeholder = "Email"
		textfield.translatesAutoresizingMaskIntoConstraints = false
		textfield.autocapitalizationType = .none
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
		textfield.isSecureTextEntry = true
		textfield.autocapitalizationType = .none
		return textfield
	}()
	
	let loginButton: UIButton = {
		let button = UIButton()
		button.setTitle("Login", for: UIControlState())
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor(r: 20, g: 101, b: 161)
		button.setTitleColor(UIColor.white, for: UIControlState())
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		return button
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
		addSubview(loginButton)
		addSubview(signUpButton)
		
		// need x, y, width, height
		inputContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		inputContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		inputContainerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
		inputContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		
		inputContainerView.addSubview(emailTextField)
		inputContainerView.addSubview(passwordTextField)
		inputContainerView.addSubview(nameSeparatorView)
		
		emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		emailTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 0).isActive = true
		emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
		emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
		
		nameSeparatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		nameSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
		nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
		passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
		passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
		
		loginButton.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
		loginButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
		loginButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8).isActive = true
		signUpButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		signUpButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor).isActive = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
