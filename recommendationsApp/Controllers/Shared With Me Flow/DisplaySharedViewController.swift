//
//  DisplaySharedViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/7/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class DisplaySharedViewController: UIViewController {
	
	@IBOutlet weak var optionsButton: UIButton!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var shareTitleLabel: UILabel!
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var darkenView: UIView!
	
	var list: List = List(recommendations: [], category: "", listId: "", isPrivate: false)
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		setup()
		// tap surrounding view to dismiss
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		darkenView.addGestureRecognizer(tap)
		darkenView.isUserInteractionEnabled = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.dismiss(animated: animated, completion: nil)
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		performSegue(withIdentifier: Constants.SegueIdentifier.backToSharedWithMe, sender: (Any).self)
	}
	
	func setup() {
		shareTitleLabel.text = list.category
		if let from = list.from {
			fromLabel.text = "From: \(from)"
		}
		if let date = list.dateReceived {
			dateLabel.text = date
		}
		
		cardView.layer.masksToBounds = true
		
		let randomIndex = Int(arc4random_uniform(UInt32(ColorSet.colorArray.count)))
		let listColor = ColorSet.colorArray[randomIndex]
		cardView.layer.backgroundColor = listColor.cgColor
		cardView.layer.cornerRadius = 8
		
		tableView.tableFooterView = UIView()
	}
	
	// MARK: IBActions
	@IBAction func optionsButtonTapped(_ sender: UIButton) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
			ShareService.report(list: self.list)
			let confirmationController = UIAlertController(title: "Your report has been sent", message: nil, preferredStyle: .alert)
			confirmationController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
				//ShareService.delete(list: self.list)
				self.performSegue(withIdentifier: Constants.SegueIdentifier.backToSharedWithMe, sender: self)
			}))
			self.present(confirmationController, animated: true, completion: nil)
		}))
		alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
			ShareService.delete(list: self.list)
			self.performSegue(withIdentifier: Constants.SegueIdentifier.backToSharedWithMe, sender: self)
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}
extension DisplaySharedViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.recommendations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.DisplayShareTableViewCell, for: indexPath) as! DisplayShareTableViewCell
		
		cell.titleLabel.text = list.recommendations[indexPath.row].title
		cell.descriptionLabel.text = list.recommendations[indexPath.row].description
		cell.ratingControl.rating = Double(list.recommendations[indexPath.row].rating)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			ShareService.delete(recommendation: list.recommendations[indexPath.row], from: list)
			list.recommendations.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
}





