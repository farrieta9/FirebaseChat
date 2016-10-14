//
//  ChatMessageCell.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/22/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
	
	static let blueColor = UIColor(r: 0, g: 137, b: 249)
	
	let textView: UITextView = {
		let tv = UITextView()
		tv.text = "Sample text"
		tv.font = UIFont.systemFont(ofSize: 16)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = UIColor.clear
		tv.textColor = UIColor.white
		return tv
	}()
	
	let bubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = blueColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true
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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(bubbleView)
		addSubview(textView)
		addSubview(profileImageView)
		
		// ios 9 constraints
		// needs x, y, width, height
		textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
		textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
		textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
		bubbleViewRigthAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
		bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
		bubbleViewWidthAnchor?.isActive = true
		bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
		profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
