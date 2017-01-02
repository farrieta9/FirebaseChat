//
//  MessengerController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class MessengerController: UITableViewController {
    
    private let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoginIfNeeded()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "CreateNew-50.png"), style: .plain, target: self, action: #selector(handleNewMessage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        tableView.register(MessengerCell.self, forCellReuseIdentifier: cellId)
        observeMessages()
    }
    
    func observeMessages() {
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
    
    private func fetchMessageWithMessageId(_ messageId: String) {
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
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            // Decending order
            return (message1.timestamp?.int32Value)! > (message2.timestamp?.int32Value)!
        })
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    
    func showLoginIfNeeded() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            return
        }
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let results = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = results["username"] as? String
            }
            
        }, withCancel: nil)
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        UserDefaults.standard.setIsLoggedIn(value: false)

        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func handleNewMessage() {
        showNewMessengeController()
    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func showNewMessengeController() {
        let createMessageController = CreateMessageController()
        createMessageController.messageController = self
        let navController = UINavigationController(rootViewController: createMessageController)
        
        present(navController, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessengerCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let message = messages[indexPath.row]
        
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
