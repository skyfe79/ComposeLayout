//
//  NestedGroupsViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/03.
//

import UIKit
import ComposeLayout

class NestedGroupsViewController: UIViewController, Example {
    
    enum Sections {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nested Groups"
        configureHierarchy()
        configureDataSource()
    }
}

extension NestedGroupsViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            Section(id: Sections.main) {
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
                .width(.fractionalWidth(1.0))
                .height(.fractionalHeight(0.4))
            }
        }
        .build()
    }
}

extension NestedGroupsViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, identifier in
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title2)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<100))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
