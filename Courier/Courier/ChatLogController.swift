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
	
	fileprivate var cellId = "cellId"
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
	
	override var canBecomeFirstResponder : Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = UIColor.white
		inputContainerView.inputTextField.delegate = self
		inputContainerView.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
		collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
		collectionView?.alwaysBounceVertical = true
		collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		collectionView?.keyboardDismissMode = .onDrag
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		collectionView?.collectionViewLayout.invalidateLayout()
	}
	
	func handleSend() {

		guard let fromId = FIRAuth.auth()?.currentUser?.uid, let toId = user?.uid, let message = inputContainerView.inputTextField.text else {
			return
		}
		
		if message.isEmpty {
			return
		}
		
		inputContainerView.inputTextField.text = nil
        let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
		let value = ["message": message, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]

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
		guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.uid else {
			return
		}
		
		FIRDatabase.database().reference().child("users-messages").child(uid).child(toId).observe(.childAdded, with: { (snapshot) in
			
			let messageId = snapshot.key
			FIRDatabase.database().reference().child("messages").child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
				
				guard let dictionary = snapshot.value as? [String: AnyObject] else {
					return
				}
				
				let message = Message()
				message.setValuesForKeys(dictionary)
				
				self.messages.append(message)
				DispatchQueue.main.async(execute: {
					self.collectionView?.reloadData()
				})
				
			}, withCancel: nil)
			
		}, withCancel: nil)
	}
	
	fileprivate func estimateFrameForText(_ text:String) -> CGRect {
		let size = CGSize(width: 200, height: 1000) // height is something large
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		
		return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
	}

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
//	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
//		let message = messages[(indexPath as NSIndexPath).row]
//		
//		cell.textView.text = message.message
//		setUpCell(cell, message: message)
//		cell.bubbleViewWidthAnchor?.constant = estimateFrameForText(message.message!).width + 32
//		
//		return cell
//	}
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.message
        setUpCell(cell, message: message)
        cell.bubbleViewWidthAnchor?.constant = estimateFrameForText(message.message!).width + 32
        
        return cell
    }
	
	
	fileprivate func setUpCell(_ cell: ChatMessageCell, message: Message) {
		
		if let profileImageURL = user?.profileImageURL {
			cell.profileImageView.loadImageUsingURLString(profileImageURL)
		}
		
		if message.fromId == FIRAuth.auth()?.currentUser?.uid {
			// Outgoing message
			cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
			cell.textView.textColor = UIColor.white
			// Turn off contraint first because activating another one to not have warning
			cell.bubbleViewLeftAnchor?.isActive = false
			cell.bubbleViewRigthAnchor?.isActive = true
			cell.profileImageView.isHidden = true
			
		} else {
			// incoming message
			cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
			cell.textView.textColor = UIColor.black
			cell.bubbleViewRigthAnchor?.isActive = false
			cell.bubbleViewLeftAnchor?.isActive = true
			cell.profileImageView.isHidden = false
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 80
		
        if let text = messages[indexPath.item].message {
            height = estimateFrameForText(text).height + 20
        }
		let width = UIScreen.main.bounds.width
		return CGSize(width: width, height: height)
	}
}

extension ChatLogController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if textField.text!.isEmpty {
			return true
		}
		
		handleSend()
		textField.text = nil
		
		return true
	}
}
