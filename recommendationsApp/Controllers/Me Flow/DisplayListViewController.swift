//
//  DisplayListViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import Cosmos

class DisplayListViewController: UIViewController {

	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var listCatgoryLabel: UILabel!
	@IBOutlet weak var darkenView: UIView!
	@IBOutlet weak var optionsButton: UIButton!
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var colorView: UIView!
	
	var isSelecting: Bool = false
	var selectedArray: [IndexPath] = []
	
	var list = List(recommendations: [], category: "", listId: "", isPrivate: false)
	
	// MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.reloadData()
		// set image of list
		colorView.layer.backgroundColor = list.color?.cgColor
		// set title of list
		if list.isPrivate {
			listCatgoryLabel.text = list.category + ""
		} else {
			listCatgoryLabel.text = list.category
		}
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		isSelecting = false
		
		setup()
		
		// tap surrounding view to dismiss
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		darkenView.addGestureRecognizer(tap)
		darkenView.isUserInteractionEnabled = true
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if SharingStack.toBeSharedCounter > 0 {
			shareButton.setTitle("Send \(SharingStack.toBeSharedCounter)", for: .normal)
		} else {
			shareButton.setTitle("Share", for: .normal)
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		//super.viewWillDisappear(animated)
		self.dismiss(animated: animated, completion: nil)
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		performSegue(withIdentifier: Constants.SegueIdentifier.backToMyListsFromDisplay, sender: (Any).self)
	}
	
	func setup() {
		// think about card shadow
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		
		addButton.layer.masksToBounds = false
		addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
		addButton.layer.shadowRadius = 5
		addButton.layer.shadowColor = UIColor.black.cgColor
		addButton.layer.shadowOpacity = 0.75
		addButton.layer.shadowOffset = CGSize(width: 0.6, height: 0.3)
		
		shareButton.layer.masksToBounds = false
		shareButton.layer.cornerRadius = 0.5 * shareButton.bounds.size.width
		shareButton.layer.shadowRadius = 5
		shareButton.layer.shadowColor = UIColor.black.cgColor
		shareButton.layer.shadowOpacity = 0.75
		shareButton.layer.shadowOffset = CGSize(width: 0.6, height: 0.3)
	}
	
	// MARK: IBActions
	@IBAction func selectButtonTapped(_ sender: UIButton) {
		if !isSelecting {
			isSelecting = true
			selectButton.setTitle("Done", for: .normal)
			tableView.allowsMultipleSelection = isSelecting
			shareButton.setTitle("\(SharingStack.toBeSharedCounter)", for: .normal)
		} else {
			isSelecting = false
			selectButton.setTitle("Select", for: .normal)
			tableView.allowsMultipleSelection = isSelecting
			if SharingStack.toBeSharedCounter == 0 {
				shareButton.setTitle("Share", for: .normal)
			} else {
				shareButton.setTitle("Send \(SharingStack.toBeSharedCounter)", for: .normal)
			}
			selectedArray = []
			tableView.reloadData()
		}
	}
	
	@IBAction func addButtonTapped(_ sender: UIButton) {
		addButton.alpha = 0
		ListService.showSpecificList(list) { (list) in
			print(list)
		}
		performSegue(withIdentifier: Constants.SegueIdentifier.addToList, sender: (Any).self)
	}
	
	@IBAction func shareButtonTapped(_ sender: UIButton) {
		performSegue(withIdentifier: Constants.SegueIdentifier.toShareFromDisplay, sender: (Any).self)
	}
	
	@IBAction func optionsButtonTapped(_ sender: UIButton) {
		let actionSheetController = UIAlertController(title: "\(list.category) Options", message: nil, preferredStyle: .actionSheet)
		if list.isPrivate {
			actionSheetController.addAction(UIAlertAction(title: "Make Public", style: .default, handler: { (action) in
				self.list.isPrivate = false
			}))
		} else {
			actionSheetController.addAction(UIAlertAction(title: "Make Private", style: .default, handler: { (action) in
				self.list.isPrivate = true
			}))
		}
		actionSheetController.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (action) in
			let renameAlertController = UIAlertController(title: "Rename List", message: "Enter a new name for this list", preferredStyle: .alert)
			renameAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			renameAlertController.addTextField(configurationHandler: { textField in
				textField.text = self.list.category
			})
			renameAlertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
				if let newTitle = renameAlertController.textFields?.first?.text {
					ListService.rename(list: self.list, newTitle: newTitle)
					self.listCatgoryLabel.text = newTitle
				}
			}))
			self.present(renameAlertController, animated: true, completion: nil)
		}))
		actionSheetController.addAction(UIAlertAction(title: "Delete List", style: .destructive, handler: { (action) in
			let confirmDeleteAlertController = UIAlertController(title: "Delete \(self.list.category)", message: "This action can't be undone", preferredStyle: .alert)
			confirmDeleteAlertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
				self.performSegue(withIdentifier: Constants.SegueIdentifier.backToMyListsFromDisplay, sender: self)
				ListService.deleteLists(lists: [self.list])
			}))
			confirmDeleteAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(confirmDeleteAlertController, animated: true, completion: nil)
		}))
		actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(actionSheetController, animated: true, completion: nil)
	}
	
	// MARK: Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.addToList:
			let destination = segue.destination as! AddRecommendationToListViewController
			destination.listAutoId = list.referencingId
		case Constants.SegueIdentifier.updateInList:
			guard let indexPath = tableView.indexPathForSelectedRow else { return }
			let destination = segue.destination as! AddRecommendationToListViewController
			destination.listAutoId = list.referencingId
			destination.recommendationToUpdate = list.recommendations[indexPath.row]
		case Constants.SegueIdentifier.backToMyListsFromDisplay:
			print("back to my lists segue")
		case Constants.SegueIdentifier.toShareFromDisplay:
			let destination = segue.destination as! ShareViewController
			SharingStack.readyToShare()
			destination.shareStack = SharingStack.toBeShared
		default:
			print("unexpected segue identifier")
		}
	}
	
	@IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
		addButton.alpha = 1
		ListService.showSpecificList(list) { (updatedList) in
			self.list = updatedList
			self.tableView.reloadData()
		}
	}
}

// MARK: TableView
extension DisplayListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.recommendations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.RecommendationCell, for: indexPath) as! DisplayListTableViewCell
		cell.titleLabel.text = list.recommendations[indexPath.item].title
		cell.descriptionLabel.text = list.recommendations[indexPath.item].description
		cell.ratingControl.rating = Double(list.recommendations[indexPath.item].rating)
		
		if selectedArray.contains(indexPath) || SharingStack.recommendationsToShare.contains(where: { (reco) -> Bool in
			return reco.referencingId == list.recommendations[indexPath.row].referencingId
		}) {
			cell.layer.backgroundColor = UIColor.blue.cgColor
		} else {
			cell.layer.backgroundColor = UIColor.white.cgColor
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			ListService.delete(recommendation: list.recommendations[indexPath.item], from: list)
			list.recommendations.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			
		}
	}
	
	// Selecting Cells
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! DisplayListTableViewCell
		if isSelecting {
			if cell.hasBeenSelected {
				SharingStack.delete(recommendation: list.recommendations[indexPath.row])
				shareButton.setTitle("\(SharingStack.toBeSharedCounter)", for: .normal)
				deselect(indexPath: indexPath)
				return 
			}
			selectedArray.append(indexPath)
			SharingStack.add(recommendation: list.recommendations[indexPath.row])
			shareButton.setTitle("\(SharingStack.toBeSharedCounter)", for: .normal)
			tableView.reloadData()
			cell.hasBeenSelected = true
		} else {
			performSegue(withIdentifier: Constants.SegueIdentifier.updateInList, sender: (Any).self)
		}
	}
	
	func deselect(indexPath: IndexPath) {
		selectedArray = selectedArray.filter { $0 != indexPath }
		tableView.reloadData()
		let cell = tableView.cellForRow(at: indexPath) as! DisplayListTableViewCell
		cell.hasBeenSelected = false
		cell.layer.backgroundColor = UIColor.white.cgColor
	}
	
}









