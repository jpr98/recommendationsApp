//
//  DisplayListViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class DisplayListViewController: UIViewController {

	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var listCatgoryLabel: UILabel!
	@IBOutlet weak var darkenView: UIView!
	
	var list = List(recommendations: [], category: "", listId: "")
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// set image of list
		imageView.image = UIImage(named:"bksncofee")
		// set title of list
		listCatgoryLabel.text = list.category
		
		// think about card shadow
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		
		addButton.layer.masksToBounds = true
		addButton.layer.cornerRadius = addButton.bounds.size.width * 0.5
		
		tableView.delegate = self
		tableView.dataSource = self
		
		// tap surrounding view to dismiss
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		darkenView.addGestureRecognizer(tap)
		darkenView.isUserInteractionEnabled = true
    }
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		performSegue(withIdentifier: Constants.SegueIdentifier.backToMyLists, sender: (Any).self)
	}
	
	@IBAction func addButtonTapped(_ sender: UIButton) {
		addButton.alpha = 0
		ListService.showSpecificList(list) { (lis) in
			print(lis)
		}
		performSegue(withIdentifier: Constants.SegueIdentifier.addToList, sender: (Any).self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.addToList:
			let destination = segue.destination as! AddRecommendationToListViewController
			destination.listAutoId = list.referencingId
			print("add to list button tapped")
		case Constants.SegueIdentifier.backToMyLists:
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
extension DisplayListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.recommendations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.RecommendationCell, for: indexPath) as! DisplayListTableViewCell
		cell.titleTextField.text = list.recommendations[indexPath.item].title
		cell.descriptionTextField.text = list.recommendations[indexPath.item].description
		
		return cell
	}
}









