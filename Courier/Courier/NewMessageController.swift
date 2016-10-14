//
//  NewMessageController.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/21/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
	
	fileprivate let cellId = "cellId"
	var users = [User]()
	var messageController: MessageController? // parent
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
		
		fetchUser()
	}
	
	func fetchUser() {
		FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
			guard let results = snapshot.value as? [String: AnyObject] else {
				return
			}
			
			let user = User()

			user.setValuesForKeys(results)
			user.uid = snapshot.key
			self.users.append(user)
			
			DispatchQueue.main.async(execute: { 
				self.tableView.reloadData()
			})
			
		}, withCancel: nil)
	}
	
	func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
		cell.textLabel?.text = users[(indexPath as NSIndexPath).row].username
		cell.detailTextLabel?.text = users[(indexPath as NSIndexPath).row].email
		
		if let imageURL = users[(indexPath as NSIndexPath).row].profileImageURL {
			cell.profileImageView.loadImageUsingURLString(imageURL)
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dismiss(animated: true, completion: nil)
		let user = users[(indexPath as NSIndexPath).row]
		messageController?.showChatControllerForUser(user)
	}
}
