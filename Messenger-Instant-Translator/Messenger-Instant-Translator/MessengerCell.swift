//
//  MessengerCell.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class MessengerCell: UITableViewCell{
    
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
//            if let seconds = message?.timestamp?.doubleValue {
//                let timestampDate = Date(timeIntervalSince1970: seconds)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm:ss a"
//                timeLabel.text = dateFormatter.string(from: timestampDate)
//            }
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "default_profile.png")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: profileImageView.frame.width + 16, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: profileImageView.frame.width + 16, y: detailTextLabel!.frame.origin.y, width: UIScreen.main.bounds.width - profileImageView.frame.width - 50, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant:  8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textLabel?.text = "sample text"
        detailTextLabel?.text = "sample detail text"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
