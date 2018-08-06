//
//  UserService.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct UserService {
	
	static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
		let userAttrs = ["username": username]
		
		let ref = Database.database().reference().child("users").child(firUser.uid)
		
		ref.setValue(userAttrs) { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
				return completion(nil)
			}
			
			ref.observeSingleEvent(of: .value, with: { (snapshot) in
				let user = User(snapshot: snapshot)
				completion(user)
			})
		}
	}
	
	static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
		let ref = Database.database().reference().child("users").child(uid)
		ref.observeSingleEvent(of: .value) { (snapshot) in
			guard let user = User(snapshot: snapshot) else {
				return completion(nil)
			}
			completion(user)
		}
	}
	
	static func getAll(completion: @escaping ([User]) -> Void) {
		let currentUser = User.current
		let ref = Database.database().reference().child("users")
		
		ref.observeSingleEvent(of: .value) { (snapshot) in
			guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
				else { return }
			
			let users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }
			
			let dispatchGroup = DispatchGroup()
			users.forEach({ (user) in
				dispatchGroup.enter()
				
				FollowService.isUserFollowed(user, byCurrentUserWithCompletion: { (isFollowed) in
					user.isFollowed = isFollowed
					dispatchGroup.leave()
				})
			})
			
			dispatchGroup.notify(queue: .main, execute: {
				completion(users)
			})
		}
	}
}







