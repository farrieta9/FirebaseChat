//
//  ChatLogController.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/21/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	private var cellId = "cellId"
	var user: User? {
		didSet {
			navigationItem.title = user?.username
			observeMessages()
		}
	}
	
	var messages = [Message]()
	
	lazy var inputContainerView: InputContainerView = {
		let contentView = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
		return contentView
	}()
	
	override var inputAccessoryView: UIView? {
		get {
			return inputContainerView
		}
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = UIColor.whiteColor()
		inputContainerView.inputTextField.delegate = self
		inputContainerView.sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
		collectionView?.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
		collectionView?.alwaysBounceVertical = true
		collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		collectionView?.keyboardDismissMode = .OnDrag
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		collectionView?.collectionViewLayout.invalidateLayout()
	}
	
	func handleSend() {

		guard let fromId = FIRAuth.auth()?.currentUser?.uid, toId = user?.uid, message = inputContainerView.inputTextField.text else {
			return
		}
		
		if message.isEmpty {
			return
		}
		
		inputContainerView.inputTextField.text = nil
		let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
		let value = ["message": message, "toId": toId, "fromId": fromId, "timestamp": timestamp]

		FIRDatabase.database().reference().child("messages").childByAutoId().updateChildValues(value) { (error, ref) in
			if error != nil {
				print(error)
				return
			}
				
			let messageId = ref.key
			FIRDatabase.database().reference().child("users-messages").child(fromId).child(toId).updateChildValues([messageId: 1])
			FIRDatabase.database().reference().child("users-messages").child(toId).child(fromId).updateChildValues([messageId: 1])
			
		}
	}
	
	func observeMessages() {
		guard let uid = FIRAuth.auth()?.currentUser?.uid, toId = user?.uid else {
			return
		}
		
		FIRDatabase.database().reference().child("users-messages").child(uid).child(toId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
			
			let messageId = snapshot.key
			FIRDatabase.database().reference().child("messages").child(messageId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
				
				guard let dictionary = snapshot.value as? [String: AnyObject] else {
					return
				}
				
				let message = Message()
				message.setValuesForKeysWithDictionary(dictionary)
				
				self.messages.append(message)
				dispatch_async(dispatch_get_main_queue(), {
					self.collectionView?.reloadData()
				})
				
			}, withCancelBlock: nil)
			
		}, withCancelBlock: nil)
	}
	
	private func estimateFrameForText(text:String) -> CGRect {
		let size = CGSize(width: 200, height: 1000) // height is something large
		let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
		
		return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
	}
}

extension ChatLogController {
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatMessageCell
		let message = messages[indexPath.row]
		
		cell.textView.text = message.message
		setUpCell(cell, message: message)
		cell.bubbleViewWidthAnchor?.constant = estimateFrameForText(message.message!).width + 32
		
		return cell
	}
	
	
	private func setUpCell(cell: ChatMessageCell, message: Message) {
		
		if let profileImageURL = user?.profileImageURL {
			cell.profileImageView.loadImageUsingURLString(profileImageURL)
		}
		
		if message.fromId == FIRAuth.auth()?.currentUser?.uid {
			// Outgoing message
			cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
			cell.textView.textColor = UIColor.whiteColor()
			// Turn off contraint first because activating another one to not have warning
			cell.bubbleViewLeftAnchor?.active = false
			cell.bubbleViewRigthAnchor?.active = true
			cell.profileImageView.hidden = true
			
		} else {
			// incoming message
			cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
			cell.textView.textColor = UIColor.blackColor()
			cell.bubbleViewRigthAnchor?.active = false
			cell.bubbleViewLeftAnchor?.active = true
			cell.profileImageView.hidden = false
		}
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		var height: CGFloat = 80
		
		if let text = messages[indexPath.item].message {
			height = estimateFrameForText(text).height + 20
		}
		let width = UIScreen.mainScreen().bounds.width
		return CGSize(width: width, height: height)
	}
}

extension ChatLogController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if textField.text!.isEmpty {
			return true
		}
		
		handleSend()
		textField.text = nil
		
		return true
	}
}
