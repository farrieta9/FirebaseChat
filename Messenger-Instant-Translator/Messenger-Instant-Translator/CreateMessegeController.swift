//
//  CreateMessegeController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class CreateMessageController: UITableViewController {
    
    // for the time being, display all users. Later add searching for user instead
    
    var users = [User]()
    private let cellId = "cellId"
    var messageController: MessengerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(MessengerCell.self, forCellReuseIdentifier: cellId)
        fetchUsers()
    }
    
    func fetchUsers() {
        // retrieves all users
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessengerCell
        cell.textLabel?.text = users[indexPath.row].username
//        cell.detailTextLabel?.text = users[indexPath.row].email
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCancel()
        let user = users[indexPath.row]
        messageController?.showChatControllerForUser(user)
    }
}
