//
//  Message.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/26/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
    var toId: String?
    var fromId: String?
    var timestamp: NSNumber?
    var message: String?
    var translatedText: String?
    
    func getChatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
