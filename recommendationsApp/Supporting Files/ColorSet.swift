//
//  ColorSet.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/8/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import Foundation
import UIKit

struct ColorSet {
	static let mainColor = UIColor(red: 254/255, green: 195/255, blue: 110/255, alpha: 1.0)
	static let blueColor = UIColor(red: 56/255, green: 153/255, blue: 203/255, alpha: 1.0)
	static let greenColor = UIColor(red: 74/255, green: 196/255, blue: 102/255, alpha: 1.0)
	static let orangeColor = UIColor(red: 255/255, green: 129/255, blue: 61/255, alpha: 1.0)
	static let purpleColor = UIColor(red: 126/255, green: 47/255, blue: 55/255, alpha: 1.0)
	static let colorArray = [UIColor(red: 56/255, green: 153/255, blue: 203/255, alpha: 1.0),
							 UIColor(red: 74/255, green: 196/255, blue: 102/255, alpha: 1.0),
							 UIColor(red: 255/255, green: 129/255, blue: 61/255, alpha: 1.0),
							 UIColor(red: 126/255, green: 47/255, blue: 55/255, alpha: 1.0)]
}

extension UIColor {
	var rgba: [CGFloat] {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return ([red,green,blue,alpha])
	}
}


