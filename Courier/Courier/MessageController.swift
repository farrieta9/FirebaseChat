//
//  MessageController.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
	
	private let cellId = "cellId"
	var messages = [Message]()
	var messagesDictionary = [String: Message]()
	var timer: NSTimer?
	
	lazy var settingsLauncher: SettingsController = {
		let launcher = SettingsController()
		launcher.messageController = self
		return launcher
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeUserMessages()
		checkIfUserIsSignedIn()
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu-50"), style: .Plain, target: self, action: #selector(handleSettings))
		
		let image = UIImage(named: "CreateNew-50")
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(handleNewMessage))
		tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
	}
	
	func handleSettings() {
		settingsLauncher.showSettings()
	}
	
	func handleNewMessage() {
		let newMessageController = NewMessageController()
		newMessageController.messageController = self
		let navController = UINavigationController(rootViewController: newMessageController)
		presentViewController(navController, animated: true, completion: nil)
	}
	
	func checkIfUserIsSignedIn() {
		if FIRAuth.auth()?.currentUser?.uid == nil {
			// To remove error 'Unbalanced calls to begin end appearance transitions for UINavCtrl
			performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
		} else {
			
			let uid = FIRAuth.auth()?.currentUser?.uid
			FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in

				if let results = snapshot.value as? [String: AnyObject] {
					self.navigationItem.title = results["username"] as? String
				}
				
			}, withCancelBlock: nil)
		}
	}
	
	func handleLogout() {
		
		do {
			try FIRAuth.auth()?.signOut()
		} catch let error {
			print(error)
		}
		
		let loginController = LoginController()
		let navController = UINavigationController(rootViewController: loginController)
		presentViewController(navController, animated: true, completion: nil)		
	}
	
	func observeUserMessages() {
		messages.removeAll()
		messagesDictionary.removeAll()
		
		guard let uid = FIRAuth.auth()?.currentUser?.uid else {
			return
		}
		
		FIRDatabase.database().reference().child("users-messages").child(uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
			
			let userId = snapshot.key
			FIRDatabase.database().reference().child("users-messages").child(uid).child(userId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
				
				let messageId = snapshot.key
				self.fetchMessageWithMessageId(messageId)
				
			}, withCancelBlock: nil)
		}, withCancelBlock: nil)
	}
	
	func handleReloadTable() {
		self.messages = Array(self.messagesDictionary.values)
		self.messages.sortInPlace({ (message1, message2) -> Bool in
			// Decending order
			return message1.timestamp?.intValue > message2.timestamp?.intValue
		})
		dispatch_async(dispatch_get_main_queue(), {
			self.tableView.reloadData()
		})
	}
	
	func showChatControllerForUser(user: User) {
		let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
		chatLogController.user = user
		navigationController?.pushViewController(chatLogController, animated: true)
	}
	
	private func attemptReloadTable() {
		self.timer?.invalidate()
		self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
	}
	
	private func fetchMessageWithMessageId(messageId: String) {
		FIRDatabase.database().reference().child("messages").child(messageId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
			
			guard let results = snapshot.value as? [String: AnyObject] else {
				return
			}
			
			let message = Message()
			message.setValuesForKeysWithDictionary(results)
			
			if let chatPartnerId = message.getChatPartnerId() {
				self.messagesDictionary[chatPartnerId] = message
			}
			
			self.attemptReloadTable()
			
			}, withCancelBlock: nil)
	}
	
}

extension MessageController {
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
		
		let message = messages[indexPath.row]
		cell.message = message
		
		
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let message = messages[indexPath.row]
		
		guard let chatPartnerId = message.getChatPartnerId() else {
			return
		}
		
		FIRDatabase.database().reference().child("users").child(chatPartnerId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
			
			guard let results = snapshot.value as? [String: AnyObject] else {
				return
			}
			
			let user = User()
			user.uid = chatPartnerId
			user.setValuesForKeysWithDictionary(results)
			self.showChatControllerForUser(user)
			
		}, withCancelBlock: nil)
	}
}

extension MessageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
			return
		}
		
		uploadUserImageToFirebase(image)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	private func uploadUserImageToFirebase(image: UIImage) {
		
		guard let uploadImage = UIImageJPEGRepresentation(image, 0.1), uid = FIRAuth.auth()?.currentUser?.uid  else {
			return
		}
		
		FIRStorage.storage().reference().child("users-images").child(uid).putData(uploadImage, metadata: nil) { (metadata, error) in
			if error != nil {
				print(error)
				return
			}
			
			guard let imageURLString = metadata?.downloadURL()?.absoluteString else {
				return
			}
			
			let values = ["profileImageURL": imageURLString]
			FIRDatabase.database().reference().child("users").child(uid).updateChildValues(values)
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func launchImagePicker(sourceType: UIImagePickerControllerSourceType) {
		if UIImagePickerController.isSourceTypeAvailable(sourceType) {
			let picker = UIImagePickerController()
			picker.sourceType = sourceType
			picker.allowsEditing = false
			picker.delegate = self
			presentViewController(picker, animated: true, completion: nil)
		}
	}
}
