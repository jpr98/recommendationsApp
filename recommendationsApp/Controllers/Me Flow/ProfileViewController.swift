//
//  ProfileViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/8/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var feedbackButton: UIButton!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var copyrightLabel: UILabel!
	@IBOutlet weak var versionLabel: UILabel!
	
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	func setup() {
		let user = Auth.auth().currentUser
		if let user = user {
			guard let name = user.displayName else { return }
			guard let email = user.email else { return }
			usernameLabel.text = User.current.username
			nameLabel.text = name
			emailLabel.text = email
		}
		feedbackButton.layer.cornerRadius = 8.0
	}
	
	// MARK: IBActions
	@IBAction func optionsButtonTapped(_ sender: UIButton) {
		let logoutAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		logoutAlertController.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
		logoutAlertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
			self.handleLogout()
		}))
		present(logoutAlertController, animated: true, completion: nil)
	}
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
	}
	@IBAction func feedbackButtonTapped(_ sender: UIButton) {
		
	}
	
	// MARK: Logout
	func handleLogout() {
		do {
			try Auth.auth().signOut()
			let loginStoryboard = UIStoryboard(name: "Login", bundle: .main)
			if let initialViewController = loginStoryboard.instantiateInitialViewController() {
				self.view.window?.rootViewController = initialViewController
				self.view.window?.makeKeyAndVisible()
			}
		} catch let error {
			assertionFailure(error.localizedDescription)
		}
	}
}










