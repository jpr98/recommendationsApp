//
//  AddRecommendationToListViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/30/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import Cosmos

class AddRecommendationToListViewController: UIViewController, UITextViewDelegate {
	
	// MARK: Properties
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var ratingControl: CosmosView!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var cardView: UIView!
	
	var listAutoId: String?
	var recommendationToUpdate: Recommendation?
	
	// MARK: VC LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleTextField.delegate = self
		
		setUp()
		checkIfUpdate()
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.dismiss(animated: animated, completion: nil)
		super.dismiss(animated: animated, completion: nil)
	}
	
	func setUp() {
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		addButton.layer.cornerRadius = 6
	}
	
	func checkIfUpdate() {
		if let recommendation = recommendationToUpdate {
			titleTextField.text = recommendation.title
			descriptionTextView.text = recommendation.description
			ratingControl.rating = Double(recommendation.rating)
			addButton.setTitle("Save", for: .normal)
		} else {
			descriptionTextViewSetUp()
		}
	}
	
	// MARK: DescriptionTextView Delegate Placeholder
	func descriptionTextViewSetUp() {
		descriptionTextView.delegate = self
		descriptionTextView.text = "Description"
		descriptionTextView.textColor = UIColor.lightGray
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if descriptionTextView.textColor == UIColor.lightGray {
			descriptionTextView.text = nil
			descriptionTextView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if descriptionTextView.text.isEmpty {
			descriptionTextView.textColor = UIColor.lightGray
			descriptionTextView.text = "Description"
		}
	}
	
	// MARK: IBActions
	@IBAction func addButtonTapped(_ sender: UIButton) {
		print("add button tapped")
	}
	
	// MARK: Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		guard let listAutoId = listAutoId else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.confirmAdd where recommendationToUpdate == nil:
			ListService.addToList(categoryAutoId: listAutoId, title: titleTextField.text!, rating: Int(ratingControl.rating), description: descriptionTextView.text)
			print("confirm add to list")
		case Constants.SegueIdentifier.confirmAdd where recommendationToUpdate != nil:
			ListService.updateInList(listId: listAutoId, recommendation: Recommendation(title: titleTextField.text!, rating: Int(ratingControl.rating), description: descriptionTextView.text!, referencingId: (recommendationToUpdate?.referencingId)!))
			print("saved changes in recommendation")
		case "cancelAdd":
			print("canceled add to list")
		default:
			print("unexpected segue identifier")
		}
	}
}
// TextFieldDelegate
extension AddRecommendationToListViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		titleTextField.resignFirstResponder()
		return true
	}
}





