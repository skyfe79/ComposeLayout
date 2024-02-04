//
//  InsetItemsGridViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/02.
//

import UIKit
import ComposeLayout

class InsetItemsGridViewController: UIViewController, Example {
    
    enum Sections {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension InsetItemsGridViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            Section {
                HGroup {
                    Item()
                        .width(.fractionalWidth(0.2))
                        .height(.fractionalHeight(1.0))
                        .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
                }
                .width(.fractionalWidth(1.0))
                .height(.fractionalWidth(0.2))
            }
        }
        .build()
    }
}

extension InsetItemsGridViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
