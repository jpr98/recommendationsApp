//
//  CreateListViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/30/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class CreateListViewController: UIViewController {
	
	@IBOutlet weak var categoryTextField: UITextField!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var privateSwitch: UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		categoryTextField.delegate = self
		
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		createButton.layer.cornerRadius = 6
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)

	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.dismiss(animated: animated, completion: nil)
	}
	
	// this can be deleted because of prepare for segue function below does action when button tapped
	@IBAction func createButtonTapped(_ sender: UIButton) {
		print("create button tapped")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case "create":
			ListService.create(category: categoryTextField.text!, isPrivate: privateSwitch.isOn)
			print("list created?")
		case "cancel":
			print("create list canceled")
		default:
			print("unexpected segue identifier")
		}
	}
}
extension CreateListViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		categoryTextField.resignFirstResponder()
		return true
	}
}
