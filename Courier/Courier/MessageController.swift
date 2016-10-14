//
//  MessageController.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MessageController: UITableViewController {
	
	fileprivate let cellId = "cellId"
	var messages = [Message]()
	var messagesDictionary = [String: Message]()
	var timer: Timer?
	
	lazy var settingsLauncher: SettingsController = {
		let launcher = SettingsController()
		launcher.messageController = self
		return launcher
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeUserMessages()
		checkIfUserIsSignedIn()
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu-50"), style: .plain, target: self, action: #selector(handleSettings))
		
		let image = UIImage(named: "CreateNew-50")
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
		tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
	}
	
	func handleSettings() {
		settingsLauncher.showSettings()
	}
	
	func handleNewMessage() {
		let newMessageController = NewMessageController()
		newMessageController.messageController = self
		let navController = UINavigationController(rootViewController: newMessageController)
		present(navController, animated: true, completion: nil)
	}
	
	func checkIfUserIsSignedIn() {
		if FIRAuth.auth()?.currentUser?.uid == nil {
			// To remove error 'Unbalanced calls to begin end appearance transitions for UINavCtrl
			perform(#selector(handleLogout), with: nil, afterDelay: 0)
		} else {
			
			let uid = FIRAuth.auth()?.currentUser?.uid
			FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

				if let results = snapshot.value as? [String: AnyObject] {
					self.navigationItem.title = results["username"] as? String
				}
				
			}, withCancel: nil)
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
		present(navController, animated: true, completion: nil)		
	}
	
	func observeUserMessages() {
		messages.removeAll()
		messagesDictionary.removeAll()
		
		guard let uid = FIRAuth.auth()?.currentUser?.uid else {
			return
		}
		
		FIRDatabase.database().reference().child("users-messages").child(uid).observe(.childAdded, with: { (snapshot) in
			
			let userId = snapshot.key
			FIRDatabase.database().reference().child("users-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
				
				let messageId = snapshot.key
				self.fetchMessageWithMessageId(messageId)
				
			}, withCancel: nil)
		}, withCancel: nil)
	}
	
	func handleReloadTable() {
		self.messages = Array(self.messagesDictionary.values)
		self.messages.sort(by: { (message1, message2) -> Bool in
			// Decending order
			return message1.timestamp?.int32Value > message2.timestamp?.int32Value
		})
		DispatchQueue.main.async(execute: {
			self.tableView.reloadData()
		})
	}
	
	func showChatControllerForUser(_ user: User) {
		let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
		chatLogController.user = user
		navigationController?.pushViewController(chatLogController, animated: true)
	}
	
	fileprivate func attemptReloadTable() {
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
	}
	
	fileprivate func fetchMessageWithMessageId(_ messageId: String) {
		FIRDatabase.database().reference().child("messages").child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
			
			guard let results = snapshot.value as? [String: AnyObject] else {
				return
			}
			
			let message = Message()
			message.setValuesForKeys(results)
			
			if let chatPartnerId = message.getChatPartnerId() {
				self.messagesDictionary[chatPartnerId] = message
			}
			
			self.attemptReloadTable()
			
			}, withCancel: nil)
	}
	
}

extension MessageController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
		
		let message = messages[(indexPath as NSIndexPath).row]
		cell.message = message
		
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let message = messages[(indexPath as NSIndexPath).row]
		
		guard let chatPartnerId = message.getChatPartnerId() else {
			return
		}
		
		FIRDatabase.database().reference().child("users").child(chatPartnerId).observeSingleEvent(of: .value, with: { (snapshot) in
			
			guard let results = snapshot.value as? [String: AnyObject] else {
				return
			}
			
			let user = User()
			user.uid = chatPartnerId
			user.setValuesForKeys(results)
			self.showChatControllerForUser(user)
			
		}, withCancel: nil)
	}
}

extension MessageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
			return
		}
		
		uploadUserImageToFirebase(image)
		dismiss(animated: true, completion: nil)
	}
	
	fileprivate func uploadUserImageToFirebase(_ image: UIImage) {
		
		guard let uploadImage = UIImageJPEGRepresentation(image, 0.1), let uid = FIRAuth.auth()?.currentUser?.uid  else {
			return
		}
		
		FIRStorage.storage().reference().child("users-images").child(uid).put(uploadImage, metadata: nil) { (metadata, error) in
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
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func launchImagePicker(_ sourceType: UIImagePickerControllerSourceType) {
		if UIImagePickerController.isSourceTypeAvailable(sourceType) {
			let picker = UIImagePickerController()
			picker.sourceType = sourceType
			picker.allowsEditing = false
			picker.delegate = self
			present(picker, animated: true, completion: nil)
		}
	}
}
