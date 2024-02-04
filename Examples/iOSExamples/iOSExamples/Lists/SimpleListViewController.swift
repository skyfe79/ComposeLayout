//
//  SimpleListViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/04.
//

import UIKit
import ComposeLayout

class SimpleListViewController: UIViewController, Example {
    
    enum Sections {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Sections, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureHierarchy()
        configureDataSource()
    }

}

extension SimpleListViewController {
    /// - Tag: List
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return ComposeLayout.list(using: config)
    }
}

extension SimpleListViewController {
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
