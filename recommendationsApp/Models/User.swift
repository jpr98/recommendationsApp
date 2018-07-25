//
//  User.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/24/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
	// MARK: Properties
	let uid: String
	let username: String
	
	// MARK: Singleton
	private static var _current: User?
	
	static var current: User {
		
		guard let currentUser = _current else {
			fatalError("Error: current user doesn't exist")
		}
		
		return currentUser
	}
	
	// MARK: Initializers
	init(uid: String, username: String) {
		self.uid = uid
		self.username = username
	}
	
	init?(snapshot: DataSnapshot) {
		guard let dict = snapshot.value as? [String: Any],
			let username = dict["username"] as? String 
			else { return nil }
		self.uid = snapshot.key
		self.username = username
	}
	
	// MARK: Methods
	static func setCurrent(_ user: User) {
		_current = user 
	}
}
