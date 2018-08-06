//
//  ExploreViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/2/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
	
	// MARK: Properties
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var userArray: [User] = []
	var currentUserArray: [User] = []
	
	// Mark: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
//		tableView.tableFooterView = UIView()
		tableView.rowHeight = 71
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		UserService.getAll { [ unowned self ] (users) in
			self.userArray = users
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		currentUserArray = userArray
	}
}
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currentUserArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.userCell, for: indexPath) as? UserSearchTableViewCell else { return UserSearchTableViewCell() }
		configure(cell: cell, atIndexPath: indexPath)
		
		return cell
	}
	
	func configure(cell: UserSearchTableViewCell, atIndexPath indexPath: IndexPath) {
		let user = currentUserArray[indexPath.item]
		
		cell.usernameLabel.text = user.username
		cell.followButton.isSelected = user.isFollowed
	}
}
extension ExploreViewController: UserSearchTableViewCellDelegate {
	func didTapFollowButton(_ followButton: UIButton, on cell: UserSearchTableViewCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		
		followButton.isUserInteractionEnabled = false
		let followee = currentUserArray[indexPath.row]
		
		FollowService.setIsFollowing(!followee.isFollowed, fromCurrentUserTo: followee) { (success) in
			defer {
				followButton.isUserInteractionEnabled = true
			}
			
			guard success else { return }
			
			followee.isFollowed = !followee.isFollowed
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}
	}
}





