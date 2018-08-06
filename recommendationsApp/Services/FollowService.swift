//
//  FollowService.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/2/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FollowService {
	
	private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
		let currentUser = User.current
		let followData = [ "followers/\(user.uid)/\(currentUser.uid)": true,
						   "following/\(currentUser.uid)/\(user.uid)": true]
		
		let ref = Database.database().reference()
		ref.updateChildValues(followData) { (error, _) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
			success(error == nil)
		}
	}
	
	private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
		let currentUser = User.current
		let unfollowData = ["followers/\(user.uid)/\(currentUser.uid)": NSNull(),
							"following/\(currentUser.uid)/\(user.uid)": NSNull()]
		
		let ref = Database.database().reference()
		ref.updateChildValues(unfollowData) { (error, _) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
			success(error == nil)
		}
		
	}
	
	static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
		if isFollowing {
			followUser(followee, forCurrentUserWithSuccess: success)
		} else {
			unfollowUser(followee, forCurrentUserWithSuccess: success)
		}
	}
	
	static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
		let currentUser = User.current
		let ref = Database.database().reference().child("followers").child(user.uid)
		
		ref.queryEqual(toValue: nil, childKey: currentUser.uid).observeSingleEvent(of: .value) { (snapshot) in
			if let _ = snapshot.value as? [String: Bool] {
				completion(true)
			} else {
				completion(false)
			}
		}
	}
}








