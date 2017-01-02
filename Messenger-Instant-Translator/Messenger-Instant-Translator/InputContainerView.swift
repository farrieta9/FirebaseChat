//
//  InputContainerView.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/26/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class InputContainerView: UIView {
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "upload_image_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        addSubview(inputTextField)
        addSubview(sendButton)
        addSubview(seperatorView)
        addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        seperatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
