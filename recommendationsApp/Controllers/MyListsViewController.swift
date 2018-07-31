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
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!
	
	
	
	var myLists: [List] = []
	
	let images = [
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail")
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.sectionInset = UIEdgeInsetsMake(12, 8, 5, 8)
		layout.minimumInteritemSpacing = 4
		layout.itemSize = CGSize(width: (self.collectionView.frame.size.width) / 2, height: 80)
		
		addButton.layer.masksToBounds = true
		addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
	}
	
	@IBAction func selectButtonTapped(_ sender: UIButton) {
	}
	
	@IBAction func deleteButtonTapped(_ sender: UIButton) {
	}
	
	@IBAction func shareButtonTapped(_ sender: UIButton) {
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
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		cell?.layer.borderColor = UIColor.blue.cgColor
		cell?.layer.borderWidth = 1.5
		performSegue(withIdentifier: Constants.SegueIdentifier.showList, sender: (Any).self)
		addButton.alpha = 0
	}
	
	@IBAction func addButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: Constants.SegueIdentifier.addList, sender: (Any).self)
		addButton.alpha = 0
	}
	
	@IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
		addButton.alpha = 1
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
	}
	
	func transferIndexPath(indexPath: IndexPath) -> List {
		return myLists[indexPath.item]
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Constants.SegueIdentifier.showList,
			let destination = segue.destination as? DisplayListViewController,
			let selected = collectionView.indexPathsForSelectedItems{
			let listToShow = selected[0].item
			destination.list = myLists[listToShow]
		}
	}
}



















