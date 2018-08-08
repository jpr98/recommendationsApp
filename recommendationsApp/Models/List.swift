//
//  List.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class List {
	// MARK: Properites
	var recommendations: [Recommendation]
	let category: String
	let referencingId: String
	var isPrivate: Bool
	var from: String?
	
	init(recommendations: [Recommendation], category: String, listId: String, isPrivate: Bool) {
		self.recommendations = recommendations
		self.category = category
		self.referencingId = listId
		self.isPrivate = isPrivate
	}
}
