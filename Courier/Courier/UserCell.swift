//
//  UserCell.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/21/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
	
	var message: Message? {
		didSet {
			if let chartPartnerId = message?.getChatPartnerId() {
				
				FIRDatabase.database().reference().child("users").child(chartPartnerId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
					
					guard let results = snapshot.value as? [String: AnyObject] else {
						return
					}
					
					if let profileImageURL = results["profileImageURL"] as? String {
						self.profileImageView.loadImageUsingURLString(profileImageURL)
					}
					
					self.textLabel?.text = results["username"] as? String
					
					}, withCancelBlock: nil)
			}
			
			self.detailTextLabel?.text = message?.message
			if let seconds = message?.timestamp?.doubleValue {
				let timestampDate = NSDate(timeIntervalSince1970: seconds)
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				timeLabel.text = dateFormatter.stringFromDate(timestampDate)
			}
		}
	}
	
	
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "default_profile.png")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .ScaleAspectFill
		imageView.layer.cornerRadius = 25
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFontOfSize(13)
		label.textColor = UIColor.darkGrayColor()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .Right
		return label
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textLabel?.frame = CGRectMake(profileImageView.frame.width + 16, textLabel!.frame.origin.y, textLabel!.frame.width, textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRectMake(profileImageView.frame.width + 16, detailTextLabel!.frame.origin.y, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
		
		addSubview(profileImageView)
		addSubview(timeLabel)
		
		// need x, y, width, height
		profileImageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
		profileImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
		profileImageView.widthAnchor.constraintEqualToConstant(50).active = true
		profileImageView.heightAnchor.constraintEqualToConstant(50).active = true
		
		timeLabel.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -8).active = true
		timeLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: -16).active = true
		timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
		timeLabel.heightAnchor.constraintEqualToAnchor(textLabel?.heightAnchor).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
