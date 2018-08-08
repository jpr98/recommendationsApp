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
	
	// This function saves a mixed stack to be shared with different users
	// it puts all recommendations shared from a user to other in the same list.
	// Im leaving the category of complete lists attached just in firebase for later possible use
	// in filtering or searching, saving date just as a future proof feature
	static func send(to users: [User], stack: [Any], named shareTitle: String) {
		let currentUser = User.current
		for user in users {
			let ref = Database.database().reference().child("received").child(user.uid).childByAutoId()
			let dateShared = Date()
			let formatter = DateFormatter()
			formatter.dateFormat = "MMMM d"
			let value: [String: Any] = ["share_title":shareTitle, "date":formatter.string(from: dateShared), "from":currentUser.username]
			ref.updateChildValues(value) { (error, dateValue) in
				if let error = error {
					assertionFailure(error.localizedDescription)
				}
			}
			for item in stack {
				if let list = item as? List {
					// code for sharing a list of recommendations
					for reco in list.recommendations {
						let recoRef = ref.child("recommendations").childByAutoId()
						let recoValues: [String: Any] = ["title":reco.title, "rating":reco.rating, "description":reco.description, "category":list.category]
						recoRef.updateChildValues(recoValues) { (error, recoRef) in
							if let error = error {
								assertionFailure(error.localizedDescription)
							}
						}
					}
				} else if let recommendation = item as? Recommendation {
					// code for sharing a single recommendation
					let recoRef = ref.child("recommendations").childByAutoId()
					let values: [String: Any] = ["title":recommendation.title, "rating":recommendation.rating, "description":recommendation.description]
					recoRef.updateChildValues(values) { (error, recoRef) in
						if let error = error {
							assertionFailure(error.localizedDescription)
						}
					}
				}
			}
		}
	}
	
	static func receive(completion: @escaping ([List]) -> Void) {
		let currentUser = User.current
		let ref = Database.database().reference().child("received").child(currentUser.uid)
		var returnArray: [List] = []
		ref.observeSingleEvent(of: .value) { (snapshot) in
			
			// -looping through shared lists
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				if let value = snap.value as? [String: Any] {
					guard let category = value["share_title"] as? String,
						let username = value["from"] as? String else { return }
					
					// creating list to be filled and returned in array
					let listOfUser: List = List(recommendations: [], category: category, listId: snap.key, isPrivate: false)
					// this are the recommendations inside list being filled
					var list = [Recommendation]()
					
					if let recommendations = value["recommendations"] as? [String: Any] {
						
						// --looping through recommendations in a list
						for (key,_) in recommendations {
							// CHECK HERE
							if let reco = recommendations[key] as? [String: Any] {
								list.append(Recommendation(title: reco["title"] as! String, rating: reco["rating"] as! Int, description: reco["description"] as! String, referencingId: key))
							}
						}
						// --end of recommendations loop
						
						listOfUser.recommendations = list
						listOfUser.from = username
						returnArray.append(listOfUser)
					}
				}
			}
			if returnArray.count > 0 {
				print(returnArray)
				completion(returnArray)
			} else {
				completion([])
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// need to upadate this (check slack for ideas)
	// share lists to a set of users (can be just one of each or multiple)
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
	
	// get all lists shared with current user
	static func getReceivedLists(completion: @escaping ([List]) -> Void) {
		let currentUser = User.current
		let ref = Database.database().reference().child("received").child(currentUser.uid)
		var lists = [List]()
		ref.observeSingleEvent(of: .value) { (snapshot) in
			print("snapshot!!!!\(snapshot)")
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				print("snap!!!!\(snap)")
				if let value = snap.value as? [String:Any] {
					let category = value["title"] as! String
					var list = [Recommendation]()
					if let recommendations = value["recommendations"] as? [String:Any] {
						for (key,_) in recommendations {
							if let reco = recommendations[key] as? [String: Any] {
								list.append(Recommendation(title: reco["title"] as! String, rating: reco["rating"] as! Int, description: reco["description"] as! String, referencingId: key))
							}
						}
						lists.append(List(recommendations: list, category: category, listId: snap.key, isPrivate: false))
					} else {
						lists.append(List(recommendations: [], category: category, listId: snap.key, isPrivate: false))
					}
				}
			}
			if lists.count > 0 {
				completion(lists)
			} else {
				completion([])
			}
		}
	}
	
}










