//
//  SharingStack.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/8/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation

struct SharingStack {
	static var toBeShared: [Any] = []
	static var toBeSharedCounter: Int = 0
	static var listsToShare: [List] = []
	static var recommendationsToShare: [Recommendation] = []
	
	// this method should be called when adding whole lists
	static func add(list: List) {
		var found: Bool = false
		for listInStack in listsToShare {
			if list.referencingId == listInStack.referencingId {
				found = true
			}
		}
		if !found {
			listsToShare.append(list)
			toBeSharedCounter += list.recommendations.count
		}
	}
	
	// this method should be called to delete a whole list
	static func delete(list: List) {
		var counter: Int = 0
		for listInStack in listsToShare {
			if list.referencingId == listInStack.referencingId {
				listsToShare.remove(at: counter)
				toBeSharedCounter -= list.recommendations.count
			}
			counter += 1
		}
	}
	
	// this method should be called when adding specific recommendations
	static func add(recommendation: Recommendation) {
		var found: Bool = false
		for reco in recommendationsToShare {
			if recommendation.referencingId == reco.referencingId {
				found = true
				// test
				self.delete(recommendation: recommendation)
			}
		}
		if !found {
			toBeSharedCounter += 1
			recommendationsToShare.append(recommendation)
		}
	}
	
	// this method should be called when removing a recommendation from stack
	static func delete(recommendation: Recommendation) {
		var counter: Int = 0
		for reco in recommendationsToShare {
			if recommendation.referencingId == reco.referencingId {
				recommendationsToShare.remove(at: counter)
				toBeSharedCounter -= 1
			}
			counter += 1
		}
	}
	
	static func readyToShare() {
		for item in listsToShare {
			toBeShared.append(item)
		}
		for item in recommendationsToShare {
			toBeShared.append(item)
		}
	}
	
	static func reset() {
		recommendationsToShare.removeAll()
		listsToShare.removeAll()
		toBeShared.removeAll()
		toBeSharedCounter = 0
	}
}
