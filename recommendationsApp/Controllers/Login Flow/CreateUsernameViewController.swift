//
//  CreateUsernameViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
	// MARK: Properties
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var takenLabel: UILabel!
	
	// MARK: Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		nextButton.layer.cornerRadius = 6
	}
	
	@IBAction func nextButtonTapped(_ sender: UIButton) {
		guard let firUser = Auth.auth().currentUser,
			let username = usernameTextField.text,
			!username.isEmpty else { return }
		
		UserService.checkRepeated(username: username) { (repeated) in
			if repeated {
				self.takenLabel.alpha = 1
			} else {
				self.takenLabel.alpha = 0
				UserService.create(firUser, username: username) { (user) in
					guard let user = user else { return }
					print("New user created: \(user.username)")
					
					User.setCurrent(user, writeToUserDefaults: true)
					
					let initialViewController = UIStoryboard.initialViewController(for: .main)
					self.view.window?.rootViewController = initialViewController
					self.view.window?.makeKeyAndVisible()
				}
			}
		}
		takenLabel.alpha = 0
	}
}













