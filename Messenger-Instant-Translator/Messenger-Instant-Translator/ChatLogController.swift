//
//  ChatLogController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var messages = [Message]()
    private let cellId = "cellId"
    
    lazy var inputContainerView: InputContainerView = {
        let contentView = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        return contentView
    }()
    
    lazy var languageController: LanguageController = {
        let controller = LanguageController()
        controller.chatLogController = self
        return controller
    }()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.username
            observeMessages()
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    lazy var heightOfNavigationBar: CGFloat = self.navigationController!.navigationBar.frame.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.alwaysBounceVertical = true
        inputContainerView.inputTextField.delegate = self
        inputContainerView.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(handleSetLanguage))
    }
    
    func handleSetLanguage() {
        inputContainerView.isHidden = true
        languageController.showLanguages()
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
    
    func handleSend() {
        guard let fromId = FIRAuth.auth()?.currentUser?.uid, let toId = user?.uid, let message = inputContainerView.inputTextField.text else {
            return
        }
        
        if message.isEmpty {
            return
        }
        
        inputContainerView.inputTextField.text = nil
        let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        let translatedText = "Some translated text, maybe hold?"
        let value = ["message": message, "toId": toId, "fromId": fromId, "timestamp": timestamp, "translatedText": translatedText] as [String : Any]
        
        FIRDatabase.database().reference().child("messages").childByAutoId().updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let messageId = ref.key
            FIRDatabase.database().reference().child("users-messages").child(fromId).child(toId).updateChildValues([messageId: 1])
            FIRDatabase.database().reference().child("users-messages").child(toId).child(fromId).updateChildValues([messageId: 1])
        }
    }
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // height is something large
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        var heightTop: CGFloat = 5
        var heightBottom: CGFloat = 5
        
        if let text = messages[indexPath.item].translatedText {
            heightTop = estimateFrameForText(text).height + 16
        }
        
        if let text = messages[indexPath.item].message {
            heightBottom = estimateFrameForText(text).height + 16
        }
        
        height = heightTop + heightBottom
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.topTextView.text = message.translatedText
        cell.bottomTextView.text = message.message
        setUpCell(cell, message: message)
        let widthTop: CGFloat = estimateFrameForText(message.translatedText!).width + 32
        let widthBottom: CGFloat = estimateFrameForText(message.message!).width + 32
        let width: CGFloat = max(widthTop, widthBottom)
        
        cell.bubbleViewWidthAnchor?.constant = width
        
        var heightTop: CGFloat = 100
        var heightBottom: CGFloat = 100
        
        if let text = messages[indexPath.item].translatedText {
            heightTop = estimateFrameForText(text).height + 16
        }
        
        if let text = messages[indexPath.item].message {
            heightBottom = estimateFrameForText(text).height + 16
        }
    
        cell.topViewHeightAnchor?.constant = heightTop
        cell.bottomViewHeightAnchor?.constant = heightBottom

        return cell
    }
    
    private func setUpCell(_ cell: ChatMessageCell, message: Message) {
        
        if let profileImageURL = user?.profileImageURL {
            cell.profileImageView.loadImageUsingURLString(profileImageURL)
        }
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            // Outgoing message
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.topView.backgroundColor = ChatMessageCell.blueColor
            cell.bottomView.backgroundColor = ChatMessageCell.blueColor
            cell.topTextView.textColor = .white
            cell.bottomTextView.textColor = .white
            // Turn off contraint first because activating another one to not have warning
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRigthAnchor?.isActive = true
            cell.profileImageView.isHidden = true
            
        } else {
            // incoming message
            let color = UIColor(r: 240, g: 240, b: 240)
            cell.topView.backgroundColor = color
            cell.bottomView.backgroundColor = color
            cell.topTextView.textColor = .black
            cell.bottomTextView.textColor = .black
            cell.bubbleViewRigthAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
}

extension ChatLogController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        handleSend()
        return true
    }
}
