//
//  AddRecommendationToListViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/30/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class AddRecommendationToListViewController: UIViewController {
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func addButtonTapped(_ sender: UIButton) {
		print("add button tapped")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.confirmAdd:
			print("confirm add to list")
		case "cancel":
			print("canceled add to list")
		default:
			print("unexpected segue identifier")
		}
	}
}
