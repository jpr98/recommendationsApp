//
//  MyListsViewController.swift
//  recommendationsApp
//
//  Created by Juan Pablo Ramos on 7/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import IGListKit

class MyListsViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!
	lazy var adapter: ListAdapter = {
		let updater = ListAdapterUpdater()
		let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 1)
		adapter.collectionView = collectionView
		adapter.dataSource = ListDataSource()
		return adapter
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		_ = adapter
	}
}
