//
//  AddRecommendationToListViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/30/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class AddRecommendationToListViewController: UIViewController {
	
	// MARK: Properties
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var cardView: UIView!
	
	var listAutoId: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8

	}
	
	// this may be deleted because prepare for segue function below does the same when button tapped
	@IBAction func addButtonTapped(_ sender: UIButton) {
		print("add button tapped")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.confirmAdd:
			ListService.addToList(categoryAutoId: listAutoId!, title: titleTextField.text!, rating: ratingSegmentedControl.selectedSegmentIndex, description: descriptionTextView.text)
			print("confirm add to list")
		case "cancelAdd":
			print("canceled add to list")
		default:
			print("unexpected segue identifier")
		}
	}
}
