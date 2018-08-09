//
//  DisplaySharedTableViewCell.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/7/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import Cosmos

class DisplayShareTableViewCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var ratingControl: CosmosView!
}
