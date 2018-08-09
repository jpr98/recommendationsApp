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

	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
		setSelecting()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		addButton.alpha = 1
		shareButton.alpha = 1
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
		
		//shareButton.layer.backgroundColor = UIColor.gray.cgColor
		shareButton.layer.masksToBounds = false
		shareButton.layer.cornerRadius = 0.5 * shareButton.bounds.size.width
		shareButton.layer.shadowRadius = 5
		shareButton.layer.shadowColor = UIColor.black.cgColor
		shareButton.layer.shadowOpacity = 0.75
		shareButton.layer.shadowOffset = CGSize(width: 0.6, height: 0.3)
		
		if SharingStack.toBeSharedCounter > 0{
			shareButton.setTitle("Send \(SharingStack.toBeSharedCounter)", for: .normal)
		} else {
			shareButton.setTitle("Share", for: .normal)
		}
		
		deleteButton.alpha = 0
	}
	
	func setSelecting() {
		selecting = false
		collectionView.allowsMultipleSelection = selecting
		collectionView.allowsSelection = !selecting
		selectButton.setTitle("Select", for: .normal)
		deleteButton.alpha = 0
		if SharingStack.toBeSharedCounter > 0{
			shareButton.setTitle("Send \(SharingStack.toBeSharedCounter)", for: .normal)
		} else {
			shareButton.setTitle("Share", for: .normal)
		}
	}
	
	// MARK: Buttons
	@IBAction func selectButtonTapped(_ sender: UIButton) {
		if !selecting {
			selecting = true
			collectionView.allowsMultipleSelection = selecting
			selectButton.setTitle("Done", for: .normal)
			deleteButton.alpha = 1
			shareButton.setTitle("\(SharingStack.toBeSharedCounter)", for: .normal)
			shareButton.isEnabled = false
		} else {
			selecting = false
			collectionView.allowsMultipleSelection = selecting
			selectButton.setTitle("Select", for: .normal)
			selectedArray.removeAll()
			deleteButton.alpha = 0
			
			if SharingStack.toBeSharedCounter == 0 {
				shareButton.setTitle("Share", for: .normal)
			} else {
				shareButton.setTitle("Send \(SharingStack.toBeSharedCounter)", for: .normal)
			}
			
			shareButton.isEnabled = true
			ListService.showAllLists { (lists) in
				self.myLists = lists
				self.collectionView.reloadData()
			}
		}
	}
	
	@IBAction func deleteButtonTapped(_ sender: UIButton) {
		ListService.deleteLists(lists: selectedArray.map { myLists[$0.item] })
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
	}
	
	@IBAction func shareButtonTapped(_ sender: UIButton) {
		performSegue(withIdentifier: Constants.SegueIdentifier.toShare, sender: (Any).self)
		shareButton.alpha = 0
	}
	
	@IBAction func addButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: Constants.SegueIdentifier.addList, sender: (Any).self)
		addButton.alpha = 0
	}
	
	// MARK: Segues
	@IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
		addButton.alpha = 1
		shareButton.alpha = 1
		ListService.showAllLists { (lists) in
			self.myLists = lists
			self.collectionView.reloadData()
		}
		if SharingStack.toBeSharedCounter > 0 {
			shareButton.setTitle("Send \(SharingStack.toBeSharedCounter)", for: .normal)
		} else {
			shareButton.setTitle("Share", for: .normal)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		switch identifier {
		case Constants.SegueIdentifier.showList:
			if let destination = segue.destination as? DisplayListViewController,
				let selected = collectionView.indexPathsForSelectedItems {
				let listToShow = selected[0].item
				destination.list = myLists[listToShow]
			}
		case Constants.SegueIdentifier.toShare:
			if let destination = segue.destination as? ShareViewController {
				SharingStack.readyToShare()
				destination.shareStack = SharingStack.toBeShared
			}
		default:
			print("unexpected segue identifier")
		}
	}
}
extension MyListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myLists.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.MyListCell, for: indexPath) as! MyListCollectionViewCell
		cell.colorView.alpha = 0
		cell.listCategoryLabel.text = myLists[indexPath.item].category
		
		// format cell
		cell.layer.backgroundColor = myLists[indexPath.item].color?.cgColor
		cell.layer.borderWidth = 1
		cell.layer.borderColor = UIColor.black.cgColor
		cell.layer.masksToBounds = true
		cell.layer.cornerRadius = 9.0
		cell.layer.shadowColor = UIColor.black.cgColor
		cell.layer.shadowRadius = 20
		cell.layer.shadowOpacity = 0.5
		
		// selection
		if selectedArray.contains(indexPath) || SharingStack.listsToShare.contains(where: { (list) -> Bool in
			return list.referencingId == myLists[indexPath.item].referencingId
		}) {
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
				SharingStack.delete(list: myLists[indexPath.item])
				shareButton.setTitle("\(SharingStack.toBeSharedCounter)", for: .normal)
				return
			}
			selectedArray.append(indexPath)
			SharingStack.add(list: myLists[indexPath.item])
			shareButton.setTitle("\(SharingStack.toBeSharedCounter)", for: .normal)
			collectionView.reloadItems(at: [indexPath])
			cell.hasBeenSelected = true
		} else {
			performSegue(withIdentifier: Constants.SegueIdentifier.showList, sender: (Any).self)
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
				self.addButton.alpha = 0
				self.shareButton.alpha = 0
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

















