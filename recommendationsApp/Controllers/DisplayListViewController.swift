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
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var listCatgoryLabel: UILabel!
	@IBOutlet weak var darkenView: UIView!
	@IBOutlet weak var optionsButton: UIButton!
	@IBOutlet weak var selectButton: UIButton!
	
	
	var list = List(recommendations: [], category: "", listId: "", isPrivate: false)
	
	// MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// set image of list
		imageView.image = UIImage(named:"bksncofee")
		// set title of list
		if list.isPrivate {
			listCatgoryLabel.text = list.category + ""
		} else {
			listCatgoryLabel.text = list.category
		}
		
		// think about card shadow
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		
		addButton.layer.masksToBounds = false
		addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
		addButton.layer.shadowRadius = 5
		addButton.layer.shadowColor = UIColor.black.cgColor
		addButton.layer.shadowOpacity = 0.75
		addButton.layer.shadowOffset = CGSize(width: 0.6, height: 0.3)
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.tableFooterView = UIView()
		
		// tap surrounding view to dismiss
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		darkenView.addGestureRecognizer(tap)
		darkenView.isUserInteractionEnabled = true
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		//super.viewWillDisappear(animated)
		self.dismiss(animated: animated, completion: nil)
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		performSegue(withIdentifier: Constants.SegueIdentifier.backToMyListsFromDisplay, sender: (Any).self)
	}
	
	// MARK: IBActions
	@IBAction func selectButtonTapped(_ sender: UIButton) {
	}
	
	@IBAction func addButtonTapped(_ sender: UIButton) {
		addButton.alpha = 0
		ListService.showSpecificList(list) { (list) in
			print(list)
		}
		performSegue(withIdentifier: Constants.SegueIdentifier.addToList, sender: (Any).self)
	}
	
	// MARK: Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.addToList:
			let destination = segue.destination as! AddRecommendationToListViewController
			destination.listAutoId = list.referencingId
			print("add to list button tapped")
		case Constants.SegueIdentifier.updateInList:
			guard let indexPath = tableView.indexPathForSelectedRow else { return }
			let destination = segue.destination as! AddRecommendationToListViewController
			destination.listAutoId = list.referencingId
			destination.recommendationToUpdate = list.recommendations[indexPath.row]
			print("update in list, cell tapped")
		case Constants.SegueIdentifier.backToMyListsFromDisplay:
			print("back to my lists segue")
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
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			ListService.delete(recommendation: list.recommendations[indexPath.item], from: list)
			list.recommendations.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: Constants.SegueIdentifier.updateInList, sender: (Any).self)
	}
	
}









