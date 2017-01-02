//
//  LoginView.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(r: 20, g: 101, b: 161)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor(r: 100, g: 100, b: 100)
        
        addSubview(inputContainerView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(separatorView)
        inputContainerView.addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
        
        inputContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 4/5).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/7, constant: 0).isActive = true
        
        emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor, constant: 0).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 0).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        separatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        separatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2, constant: 0).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecodejr: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
