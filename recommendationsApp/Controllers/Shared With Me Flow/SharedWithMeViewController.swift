//
//  SharedWithMeViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/6/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class SharedWithMeViewController: UIViewController {
	
	
	@IBOutlet weak var tableView: UITableView!
	
	
	var receivedLists: [List] = []
	
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(SharedWithMeViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
		refreshControl.tintColor = UIColor(red: 254/255.0, green: 95/255.0, blue: 10/255.0, alpha: 1.0)
		return refreshControl
	}()
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		ShareService.receive { (lists) in
			self.receivedLists = lists
			self.tableView.reloadData()
		}

		tableView.dataSource = self
		tableView.delegate = self
		tableView.addSubview(self.refreshControl)
		tableView.tableFooterView = UIView()
		tableView.separatorColor = UIColor.clear
	}
	
	// MARK: UI setup functions
	func setup(cell: SharedWithMeTableViewCell) {
		cell.background.layer.backgroundColor = UIColor.white.cgColor
		cell.contentView.layer.backgroundColor = UIColor.clear.cgColor
		cell.background.layer.cornerRadius = 4.0
		cell.background.layer.masksToBounds = false
		cell.background.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
		cell.background.layer.shadowOffset = CGSize(width: 0, height: 1)
		cell.background.layer.shadowOpacity = 0.8
	}
	
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		ShareService.receive { (lists) in
			self.receivedLists = lists
			self.tableView.reloadData()
			refreshControl.endRefreshing()
		}
	}
	
	// MARK: Segues
	@IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		switch identifier {
		case Constants.SegueIdentifier.toDisplaySharedList:
			//stuff to send the info of the list to next vc
			print("segue to display a specific list")
		default:
			print("unexpected segue identifier")
		}
	}
}
extension SharedWithMeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return receivedLists.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 110
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.sharedWithMeTableViewCell, for: indexPath) as! SharedWithMeTableViewCell
		
		setup(cell: cell)
		cell.usernameLabel.text = receivedLists[indexPath.row].from!
		cell.shareTitleLabel.text = receivedLists[indexPath.row].category
		cell.dateLabel.text = receivedLists[indexPath.row].dateReceived!
		
		return cell
	}
}









