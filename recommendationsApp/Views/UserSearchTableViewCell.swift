//
//  UserSearchTableViewCell.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/2/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

protocol UserSearchTableViewCellDelegate: class {
	func didTapFollowButton(_ followButton: UIButton, on cell: UserSearchTableViewCell)
}

class UserSearchTableViewCell: UITableViewCell {
	
	weak var delegate: UserSearchTableViewCellDelegate?
	
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var followButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		followButton.layer.borderColor = UIColor(red: 230, green: 90, blue: 90, alpha: 1).cgColor
		followButton.layer.borderWidth = 1
		followButton.layer.cornerRadius = 6
		followButton.clipsToBounds = true
		
		followButton.setTitle("Follow", for: .normal)
		followButton.setTitle("Following", for: .selected)
	}
	
	@IBAction func followButtonTapped(_ sender: UIButton) {
		delegate?.didTapFollowButton(sender, on: self)
		print("follow button tapped")
	}
}










