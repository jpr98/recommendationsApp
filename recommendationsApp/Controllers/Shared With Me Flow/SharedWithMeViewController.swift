//
//  SharedWithMeViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 8/6/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class SharedWithMeViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var receivedLists: [List] = []
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		ShareService.receive { (lists) in
			self.receivedLists = lists
			self.collectionView.reloadData()
		}
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
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
extension SharedWithMeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return receivedLists.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.sharedWithMeCell, for: indexPath) as! SharedWithMeCollectionViewCell
		
		cell.nameLabel.text = receivedLists[indexPath.item].from
		
		return cell
	}
}
