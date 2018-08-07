//
//  ShareService.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/6/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ShareService {
	
	// need to upadate this (check slack for ideas)
	static func sendTo(users: [User], lists: [List]) {
		let currentUser = User.current
		for user in users {
			for list in lists {
				let ref = Database.database().reference().child("received").child(user.uid).childByAutoId()
				let values: [String: Any] = ["title": list.category, "recommendations":[], "from": currentUser.username]
				ref.updateChildValues(values) { (error, ref) in
					if let error = error {
						assertionFailure(error.localizedDescription)
					}
				}
				for recommendation in list.recommendations {
					let recoRef = ref.child("recommendations").childByAutoId()
					let recoValues: [String: Any] = ["title": recommendation.title, "rating": recommendation.rating, "description": recommendation.description]
					recoRef.updateChildValues(recoValues) { (error, recoRef) in
						if let error = error {
							assertionFailure(error.localizedDescription)
						}
					}
				}
			}
		}
	}
}

