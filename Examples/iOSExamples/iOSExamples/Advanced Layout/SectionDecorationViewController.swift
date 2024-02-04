//
//  SectionDecorationViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/03.
//

import UIKit
import ComposeLayout

class SectionDecorationViewController: UIViewController, Example {
    
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }

}

extension SectionDecorationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension SectionDecorationViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            Section {
                HGroup {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(1.0))
                .height(.absolute(44))
            }
            .interGroupSpacing(5)
            .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
            .decorationItems {
                DecorationItem(elementKind: Self.sectionBackgroundDecorationElementKind)
                    .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
            }
        }
        .register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: Self.sectionBackgroundDecorationElementKind)
        .build()
    }
}

extension SectionDecorationViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let numberOfItemsInSection = self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)
            let isLastCell = indexPath.item + 1 == numberOfItemsInSection
            cell.label.text = "\(indexPath.section),\(indexPath.item)"
            cell.seperatorView.isHidden = isLastCell
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        let itemsPerSection = 5
        let sections = Array(0..<5)
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            currentSnapshot.appendSections([$0])
            currentSnapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}
