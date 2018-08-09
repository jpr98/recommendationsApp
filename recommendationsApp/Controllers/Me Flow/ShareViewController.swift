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
	@IBOutlet weak var usernamesTableView: SelfSizedTableView!
	@IBOutlet weak var shareTitleTextField: UITextField!
	@IBOutlet weak var shareButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var darkenView: UIView!
	@IBOutlet weak var trashButton: UIButton!
	
	var allUsers: [User] = []
	var filteredUsers: [User] = []
	var selectedUsers: [User] = []
	var usernames: [String] = [] // check to see if necesary
	var shareStack: [Any] = []
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UserService.getAll { (users) in
			self.allUsers = users
			self.usernamesTableView.reloadData()
		}
		
		if shareStack.count == 0 {
			shareButton.backgroundColor = UIColor.gray
			shareButton.isEnabled = false
		}
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		shareButton.layer.cornerRadius = 6
		
		usernamesTableView.alpha = 0
		usernamesTableView.delegate = self
		usernamesTableView.dataSource = self
		usernamesTableView.maxHeight = 160
		
		searchBar.delegate = self
		shareTitleTextField.delegate = self
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}
	
	// MARK: Buttons actions
	@IBAction func shareButtonTapped(_ sender: UIButton) {
		if (shareTitleTextField.text?.isEmpty)! {
			shareTitleTextField.text = ""
			shareTitleTextField.layer.borderColor = UIColor.red.cgColor
		} else if shareStack.count > 0 {
			ShareService.send(to: selectedUsers, stack: shareStack, named: shareTitleTextField.text!)
			performSegue(withIdentifier: Constants.SegueIdentifier.backToMyListsFromShare, sender: (Any).self)
			SharingStack.reset()
		}
	}
	
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
	}
	
	@IBAction func trashButtonTapped(_ sender: UIButton) {
		let alertController = UIAlertController(title: "Delete Sharing Card", message: "Do you want to delete this share card?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
			SharingStack.reset()
			self.shareStack.removeAll()
			self.performSegue(withIdentifier: Constants.SegueIdentifier.backToMyListsFromShare, sender: self)
		}))
		alertController.addAction(UIAlertAction(title: "Keep", style: .cancel, handler: { (action) in
			return
		}))
		self.present(alertController, animated: true, completion: nil)
	}
	
	@IBAction func selectUser(_ sender: UIButton) {
		let cell = sender.superview?.superview as! UsernameSearchTableViewCell
		if !cell.isSharing {
			if let indexPath = usernamesTableView.indexPath(for: cell) {
				selectedUsers.append(filteredUsers[indexPath.item])
				cell.selectButton.setTitle("Deselect", for: .normal)
				cell.isSharing = true
			}
		} else {
			if usernamesTableView.indexPath(for: cell) != nil {
				selectedUsers = selectedUsers.filter { $0.username != cell.usernameLabel.text }
				cell.selectButton.setTitle("Select", for: .normal)
				cell.isSharing = false
			}
		}
	}
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
		shareTitleTextField.resignFirstResponder()
		return true
	}
	
}

class SelfSizedTableView: UITableView {
	var maxHeight: CGFloat = UIScreen.main.bounds.size.height
	
	override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
		self.layoutIfNeeded()
	}
	
	override var intrinsicContentSize: CGSize {
		let height = min(contentSize.height, maxHeight)
		return CGSize(width: contentSize.width, height: height)
	}
}









