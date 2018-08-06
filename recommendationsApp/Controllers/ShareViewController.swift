//
//  ShareViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/6/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var usernamesTableView: UITableView!
	@IBOutlet weak var shareTitle: UITextField!
	@IBOutlet weak var shareButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var darkenView: UIView!
	
	var allUsers: [User] = []
	var filteredUsers: [User] = []
	var shareStack: [Any] = []
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UserService.getAll { (users) in
			self.allUsers = users
			self.usernamesTableView.reloadData()
		}
		
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		shareButton.layer.cornerRadius = 6
		
		usernamesTableView.alpha = 0
		usernamesTableView.delegate = self
		usernamesTableView.dataSource = self
		
		searchBar.delegate = self
		shareTitle.delegate = self
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}
	
	// MARK: Buttons actions
	@IBAction func shareButtonTapped(_ sender: UIButton) {
	}
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
	}
	
	// MARK: Segues
}
// UITableView Delegate and DataSource
extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredUsers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = usernamesTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.usernameCell, for: indexPath) as! UsernameSearchTableViewCell
		cell.usernameLabel.text = filteredUsers[indexPath.row].username
		
		return cell
	}
}
// UISearchBar
extension ShareViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard !searchText.isEmpty else {
			filteredUsers = allUsers
			usernamesTableView.reloadData()
			return
		}
		filteredUsers = allUsers.filter({ (user) -> Bool in
			guard let text = searchBar.text else { return false }
			return user.username.lowercased().contains(text.lowercased())
		})
		usernamesTableView.reloadData()
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		usernamesTableView.alpha = 1
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.view.endEditing(true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.view.endEditing(true)
		usernamesTableView.alpha = 0
	}
}
//
extension ShareViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		shareTitle.resignFirstResponder()
		return true
	}
	
}









