//
//  OrthogonalScrollingViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class OrthogonalScrollingViewController: UIViewController, Example {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Sections"
        configureHierarchy()
        configureDataSource()
    }
    
}

extension OrthogonalScrollingViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            Section {
                HGroup {
                    Item()
                        .width(.fractionalWidth(0.7))
                        .height(.fractionalHeight(1.0))
                        .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
                    
                    VGroup(repeatItems: 2) {
                        Item()
                            .width(.fractionalWidth(1.0))
                            .height(.fractionalHeight(0.3))
                            .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
                    }
                    .width(.fractionalWidth(0.3))
                    .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(0.85))
                .height(.fractionalHeight(0.4))
            }
            .orthogonalScrollingBehavior(.continuous)
        }
        .build()
    }
}

extension OrthogonalScrollingViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, identifier in
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 30
        for section in 0..<5 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
