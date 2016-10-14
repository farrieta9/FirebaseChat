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
				
				FIRDatabase.database().reference().child("users").child(chartPartnerId).observeSingleEvent(of: .value, with: { (snapshot) in
					
					guard let results = snapshot.value as? [String: AnyObject] else {
						return
					}
					
					if let profileImageURL = results["profileImageURL"] as? String {
						self.profileImageView.loadImageUsingURLString(profileImageURL)
					}
					
					self.textLabel?.text = results["username"] as? String
					
					}, withCancel: nil)
			}
			
			self.detailTextLabel?.text = message?.message
			if let seconds = message?.timestamp?.doubleValue {
				let timestampDate = Date(timeIntervalSince1970: seconds)
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				timeLabel.text = dateFormatter.string(from: timestampDate)
			}
		}
	}
	
	
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "default_profile.png")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 25
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 13)
		label.textColor = UIColor.darkGray
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .right
		return label
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textLabel?.frame = CGRect(x: profileImageView.frame.width + 16, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRect(x: profileImageView.frame.width + 16, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		
		addSubview(profileImageView)
		addSubview(timeLabel)
		
		// need x, y, width, height
		profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
		profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
		timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16).isActive = true
		timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
