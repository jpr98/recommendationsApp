//
//  Storyboard+Utility.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

extension UIStoryboard {
	// StroyBoard Type
	enum SBType: String {
		case main
		case login
		
		var filename: String {
			return rawValue.capitalized
		}
	}
	
	convenience init(type: SBType, bundle: Bundle? = nil) {
		self.init(name: type.filename, bundle: bundle)
	}
	
	static func initialViewController(for type: SBType) -> UIViewController {
		let storyboard = UIStoryboard(type: type)
		guard let initialViewController = storyboard.instantiateInitialViewController() else {
			fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard")
		}
		
		return initialViewController
	}
}
