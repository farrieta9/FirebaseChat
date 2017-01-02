//
//  ChatMessageCell.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/27/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let topTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample text top view"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let bottomTextView: UITextView = {
        let tv = UITextView()
        tv.text = "bottom view"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = blueColor
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = blueColor
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    var bubbleViewRigthAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var topViewHeightAnchor: NSLayoutConstraint?
    var bottomViewHeightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(bubbleView)
        bubbleView.addSubview(topView)
        bubbleView.addSubview(separatorView)
        bubbleView.addSubview(bottomView)
        topView.addSubview(topTextView)
        bottomView.addSubview(bottomTextView)
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewRigthAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        topView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        topViewHeightAnchor = topView.heightAnchor.constraint(equalToConstant: 100)
        topViewHeightAnchor?.isActive = true
        
        separatorView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        bottomViewHeightAnchor = bottomView.heightAnchor.constraint(equalToConstant: 100)
        bottomViewHeightAnchor?.isActive = true
        
        topTextView.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        topTextView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        topTextView.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
        topTextView.heightAnchor.constraint(equalTo: topView.heightAnchor, constant: 8).isActive = true
        
        bottomTextView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 8).isActive = true
        bottomTextView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        bottomTextView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        bottomTextView.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
