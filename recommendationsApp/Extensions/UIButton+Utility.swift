//
//  UIButton+Utility.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

extension UIButton {
	
	// call this on addButton when adding recommendation to a specific list
	func addReminder(title: String, rating: Int, description: String) -> Recommendation {
		return Recommendation(title: title, rating: rating, description: description)
	}
	
	// need to check if category already exists, if ti does add recommendation to that list, else create new list with that category and recommendation
	func addList(title: String, rating: Int, description: String, category: String) -> List {
		return List(recommendations: [Recommendation(title: title, rating: rating, description: description)], category: category)
	}
}

