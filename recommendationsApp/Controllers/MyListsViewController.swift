//
//  MyListsViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit

class MyListsViewController: UIViewController {
	
	// MARK: Properties
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!
	
	var selecting: Bool = false
	
	var myLists: [List] = []
	var selectedArray: [IndexPath] = []
	
	let images = [
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail"),
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail"),
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail"),
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail"),
		UIImage(named: "bksncofee"),
		UIImage(named: "travel"),
		UIImage(named: "course"),
		UIImage(named: "retail")
	]
	
	// MARK: ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.allowsMultipleSelection = true
		setupLayout()
		//setSelecting()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		//super.viewWillDisappear(animated)
		self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
		setSelecting()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		addButton.alpha = 1
		//setSelecting()
		dismiss(animated: animated, completion: nil)
	}
	
	func setupLayout() {
		let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.sectionInset = UIEdgeInsetsMake(12, 8, 5, 8)
		layout.minimumInteritemSpacing = 7
		layout.itemSize = CGSize(width: (self.collectionView.frame.size.width) / 2.2, height: 80)
		
		addButton.alpha = 1
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
		
		deleteButton.alpha = 0
	}
	
	func setSelecting() {
		selecting = false
		collectionView.allowsMultipleSelection = selecting
		collectionView.allowsSelection = !selecting
		selectButton.setTitle("Select", for: .normal)
		deleteButton.alpha = 0
		
	}
	
	// MARK: Buttons
	@IBAction func selectButtonTapped(_ sender: UIButton) {
		if !selecting {
			selecting = true
			collectionView.allowsMultipleSelection = selecting
			selectButton.setTitle("Done", for: .normal)
			deleteButton.alpha = 1
		} else {
			selecting = false
			collectionView.allowsMultipleSelection = selecting
			selectButton.setTitle("Select", for: .normal)
			selectedArray.removeAll()
			deleteButton.alpha = 0
			ListService.showAllLists { (lists) in
				self.myLists = lists
				self.collectionView.reloadData()
			}
		}
	}
	
	@IBAction func deleteButtonTapped(_ sender: UIButton) {
		// delete selected cells
		ListService.deleteLists(lists: selectedArray.map { myLists[$0.item] })
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
	}
	
	@IBAction func shareButtonTapped(_ sender: UIButton) {
	}
	
	@IBAction func addButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: Constants.SegueIdentifier.addList, sender: (Any).self)
		addButton.alpha = 0
	}
	
	// MARK: Segues
	@IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
		addButton.alpha = 1
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
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

extension MyListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
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
		cell.layer.cornerRadius = 9.0
		cell.layer.shadowColor = UIColor.black.cgColor
		cell.layer.shadowRadius = 20
		cell.layer.shadowOpacity = 0.5
		//		cell.backgroundImage.image = cell.backgroundImage.image?.tint(UIColor(red: 57, green: 198, blue: 20, alpha: 0.5))
		
		// selection
		if selectedArray.contains(indexPath) {
			cell.hasBeenSelected = true
			cell.layer.borderColor = UIColor.blue.cgColor
			cell.layer.borderWidth = 1.5
		} else {
			cell.hasBeenSelected = false
			cell.layer.borderWidth = 1
			cell.layer.borderColor = UIColor.black.cgColor
		}
		
		return cell
	}
	
	// SELECT CELL
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! MyListCollectionViewCell
		if selecting {
			if cell.hasBeenSelected{
				deselectCell(indexPath: indexPath)
				return
			}
			selectedArray.append(indexPath)
			collectionView.reloadItems(at: [indexPath])
			cell.hasBeenSelected = true
		} else {
			performSegue(withIdentifier: Constants.SegueIdentifier.showList, sender: (Any).self)
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
				self.addButton.alpha = 0
			}
		}
	}
	
	// Deselect Cell
	func deselectCell(indexPath: IndexPath) {
		selectedArray = selectedArray.filter { $0 != indexPath }
		collectionView.reloadItems(at: [indexPath])
		let cell = collectionView.cellForItem(at: indexPath) as! MyListCollectionViewCell
		cell.layer.borderWidth = 1
		cell.layer.borderColor = UIColor.black.cgColor
		cell.hasBeenSelected = false
	}
}


















