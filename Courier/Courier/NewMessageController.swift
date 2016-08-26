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
	
	private let cellId = "cellId"
	var users = [User]()
	var messageController: MessageController? // parent
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
		tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
		
		fetchUser()
	}
	
	func fetchUser() {
		FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
			guard let results = snapshot.value as? [String: AnyObject] else {
				return
			}
			
			let user = User()

			user.setValuesForKeysWithDictionary(results)
			user.uid = snapshot.key
			self.users.append(user)
			
			dispatch_async(dispatch_get_main_queue(), { 
				self.tableView.reloadData()
			})
			
		}, withCancelBlock: nil)
	}
	
	func handleCancel() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
		cell.textLabel?.text = users[indexPath.row].username
		cell.detailTextLabel?.text = users[indexPath.row].email
		
		if let imageURL = users[indexPath.row].profileImageURL {
			cell.profileImageView.loadImageUsingURLString(imageURL)
		}
		
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 64
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		dismissViewControllerAnimated(true, completion: nil)
		let user = users[indexPath.row]
		messageController?.showChatControllerForUser(user)
	}
}