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
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func createButtonTapped(_ sender: UIButton) {
		print("create button tapped")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case "create":
			print("list created?")
		case "cancel":
			print("create list canceled")
		default:
			print("unexpected segue identifier")
		}
	}
}
