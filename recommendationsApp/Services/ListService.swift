//
//  ListService.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/27/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ListService {

	// create list
	static func create(category: String, isPrivate: Bool) {
		let currentUser = User.current
		
		let ref = Database.database().reference().child("lists").child(currentUser.uid).childByAutoId()
	
		let values: [String: Any] = ["category": category, "recommendations":[], "isPrivate":isPrivate]
		ref.updateChildValues(values) { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
				return
			}
		}
	}
	
	// delete list (later)
	static func deleteLists(lists: [List]) {
		let currentUser = User.current
		
		for list in lists {
			let ref = Database.database().reference().child("lists").child(currentUser.uid).child(list.referencingId)
			ref.removeValue()
		}
	}
	
	// add to list
	static func addToList(categoryAutoId: String, title: String, rating: Int, description: String) {
		let currentUser = User.current
		
		let ref = Database.database().reference().child("lists").child(currentUser.uid).child(categoryAutoId).child("recommendations").childByAutoId()
		
		let values: [String: Any] = ["title":title, "rating":rating, "description":description]
		
		ref.updateChildValues(values) { (error, ref) in
			if let error = error {
				assertionFailure(error.localizedDescription)
				return
			}
		}
	}
	
	// delete from list (later)
	static func delete(recommendation: Recommendation, from list: List) {
		let currentUser = User.current
		let ref = Database.database().reference().child("lists").child(currentUser.uid).child(list.referencingId).child("recommendations").child(recommendation.referencingId)
		ref.removeValue { error, _ in
			if let error = error {
				print(error.localizedDescription)
			}
		}
	}
	
	// show all lists
	static func showAllLists(completion: @escaping([List]) -> Void) {
		let currentUser = User.current
		var lists: [List] = []
		let ref = Database.database().reference().child("lists").child(currentUser.uid)
		
		ref.observeSingleEvent(of: .value) { (snapshot) in
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				if let value = snap.value as? [String:Any] {
					let category = value["category"] as! String
					let isPrivate = value["isPrivate"] as! Bool
					var list = [Recommendation]()
					if let recommendations = value["recommendations"] as? [String:Any] {
						for (key,_) in recommendations {
							if let reco = recommendations[key] as? [String: Any] {
								list.append(Recommendation(title: reco["title"] as! String, rating: reco["rating"] as! Int, description: reco["description"] as! String, referencingId: key))
							}
						}
						lists.append(List(recommendations: list, category: category, listId: snap.key, isPrivate: isPrivate))
					} else {
						lists.append(List(recommendations: [], category: category, listId: snap.key, isPrivate: isPrivate))
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
	
	// show specific list
	static func showSpecificList(_ list: List, completion: @escaping(List) -> Void) {
		let currentUser = User.current
		let ref = Database.database().reference().child("lists").child(currentUser.uid).child(list.referencingId).child("recommendations")
		let newList = List(recommendations: [], category: list.category, listId: list.referencingId, isPrivate: list.isPrivate)
		
		ref.observeSingleEvent(of: .value) { (snapshot) in
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				if let value = snap.value as? [String: Any] {
					let recommendation = Recommendation(title: value["title"] as! String, rating: value["rating"] as! Int, description: value["description"] as! String, referencingId: snap.key)
					newList.recommendations.append(recommendation)
				}
			}
			completion(newList)
		}
	}
	
	//  save changes
}
