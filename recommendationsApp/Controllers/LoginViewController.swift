//
//  LoginViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/24/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
	// MARK: Properties
	
//	let providers: [FUIAuthProvider] = [
//		FUIFacebookAuth()
//	]
	// MARK: Methods
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func loginButtonTapped(_ sender: UIButton) {
		guard let authUI = FUIAuth.defaultAuthUI()
			else { return }
		
		authUI.delegate = self
//		authUI.providers = providers
		let authViewController = authUI.authViewController()
		present(authViewController, animated: true)
		
	}
}
extension LoginViewController: FUIAuthDelegate {
	func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
		if let error = error {
			assertionFailure("Error signing in: \(error.localizedDescription)")
			return
		}
		
		guard let user = authDataResult?.user
			else { return }
		
		UserService.show(forUID: user.uid) { (user) in
			if let user = user {
				User.setCurrent(user)

				let initialViewController = UIStoryboard.initialViewController(for: .main)
				self.view.window?.rootViewController = initialViewController
				self.view.window?.makeKeyAndVisible()
			} else {
				self.performSegue(withIdentifier: Constants.SegueIdentifier.toCreateUsername, sender: self)
			}
		}
	}
}















