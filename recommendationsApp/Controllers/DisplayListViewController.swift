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

	var list: List = List(recommendations: [Recommendation(title: "Harry Potter", rating: 5, description: "My first book!"),Recommendation(title: "Elon Musk", rating: 4, description: "Good for entrepreneuers")], category: "Books")
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// set image of list
		imageView.image = UIImage(named:"bksncofee")
		// set title of list
		listCatgoryLabel.text = list.category
		
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 8
		addButton.layer.masksToBounds = true
		addButton.layer.cornerRadius = addButton.bounds.size.width * 0.5
		
		tableView.delegate = self
		tableView.dataSource = self
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








