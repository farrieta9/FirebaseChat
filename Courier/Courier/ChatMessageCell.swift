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
		tv.font = UIFont.systemFontOfSize(16)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = UIColor.clearColor()
		tv.textColor = UIColor.whiteColor()
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
		imageView.contentMode = .ScaleAspectFill
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
		textView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
		textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
		textView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
		textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
		
		bubbleViewLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8)
		bubbleViewRigthAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -8)
		bubbleViewWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
		bubbleViewWidthAnchor?.active = true
		bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
		bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
		
		profileImageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
		profileImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		profileImageView.widthAnchor.constraintEqualToConstant(32).active = true
		profileImageView.heightAnchor.constraintEqualToConstant(32).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
