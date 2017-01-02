//
//  MainNavigationController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/28/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        if isLoggedIn() {
            let messengerController = MessengerController()
            viewControllers = [messengerController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.1)
        }
    }
    
    func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
}
