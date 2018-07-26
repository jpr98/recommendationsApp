//
//  Recommendation.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation

class Recommendation {
	// MARK: Properties
	let title: String
	let rating: Int
	let description: String
	
	init(title: String, rating: Int, description: String) {
		self.title = title
		self.rating = rating
		self.description = description
	}
}
