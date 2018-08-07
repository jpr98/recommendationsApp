//
//  Constants.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation

struct Constants {
	
	struct UserDefaults {
		static let currentUser = "currentUser"
	}
	
	struct SegueIdentifier {
		static let toCreateUsername = "toCreateUsername"
		static let showList = "showList"
		static let addList = "addList"
		static let addToList = "addToList"
		static let updateInList = "updateInList"
		static let confirmAdd = "confirmAdd"
		static let backToMyListsFromDisplay = "backToMyListsFromDisplay"
		static let toShare = "toShare"
		static let backToMyListsFromShare = "backToMyListsFromShare"
	}
	
	struct CellIdentifier {
		static let MyListCell = "MyListCell"
		static let RecommendationCell = "RecommendationCell"
		static let userCell = "userCell" // not in use
		static let usernameCell = "usernameCell"
	}
	
}
