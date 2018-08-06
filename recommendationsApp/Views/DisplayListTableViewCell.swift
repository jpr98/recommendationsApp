//
//  DisplayListTableViewCell.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import Cosmos
class DisplayListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBOutlet weak var ratingControl: CosmosView!
}

