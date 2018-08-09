//
//  MyListCollectionViewCell.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class MyListCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var listCategoryLabel: UILabel!
	@IBOutlet weak var shadowView: UIView!
	
	var hasBeenSelected: Bool!
}
