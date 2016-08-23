//
//  Message.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/21/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
	var toId: String?
	var fromId: String?
	var timestamp: NSNumber?
	var message: String?
	
	func getChatPartnerId() -> String? {
		return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
	}
}
