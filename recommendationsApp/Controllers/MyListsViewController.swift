//
//  MyListsViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class MyListsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var addButton: UIButton!
	
	// Load from firebase database in the future
	let myLists: [List] = [List(recommendations: [], category: "Books"), List(recommendations: [], category: "Travel"), List(recommendations: [], category: "Online Courses"), List(recommendations: [], category: "Shopping")]
	let images = [
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail")
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.dataSource = self
		collectionView.delegate = self
		
		let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.sectionInset = UIEdgeInsetsMake(12, 8, 5, 8)
		layout.minimumInteritemSpacing = 4
		layout.itemSize = CGSize(width: (self.collectionView.frame.size.width) / 2, height: 80)
		
		addButton.layer.masksToBounds = true
		addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myLists.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.MyListCell, for: indexPath) as! MyListCollectionViewCell
		
		cell.listCategoryLabel.text = myLists[indexPath.item].category
		cell.backgroundImage.image = images[indexPath.item]
		
		// format cell
		cell.layer.borderWidth = 1
		cell.layer.borderColor = UIColor.black.cgColor
		cell.layer.masksToBounds = true
		cell.layer.cornerRadius = 6
		
		return cell
	}
	
	// SELECT CELL
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		let cell = collectionView.cellForItem(at: indexPath)
//		print("selected")
//		cell?.layer.borderColor = UIColor.blue.cgColor
//		cell?.layer.borderWidth = 1.5
//	}
}



















