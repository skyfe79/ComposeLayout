//
//  PinnedSectionHeaderFooterViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/03.
//

import UIKit
import ComposeLayout

class PinnedSectionHeaderFooterViewController: UIViewController, Example {

    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Section Headers/Footers"
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }

}

extension PinnedSectionHeaderFooterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension PinnedSectionHeaderFooterViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
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
            .contentInsets(leading: 10, top: 0, trailing: 10, bottom: 0)
            .boundarySupplementaryItems {
                BoundarySupplementaryItem(elementKind: Self.sectionHeaderElementKind)
                    .alignment(.top)
                    .size(headerFooterSize)
                    .pinToVisibleBounds(true)
                    .zIndex(2)
                BoundarySupplementaryItem(elementKind: Self.sectionFooterElementKind)
                    .alignment(.bottom)
                    .size(headerFooterSize)
            }
        }
        .build()
    }
}

extension PinnedSectionHeaderFooterViewController {

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Int> { cell, indexPath, identifier in
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: Self.sectionHeaderElementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = "\(elementKind) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: Self.sectionFooterElementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = "\(elementKind) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = { (view, elementKind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: elementKind == Self.sectionHeaderElementKind ? headerRegistration : footerRegistration, for: indexPath)
        }

        // initial data
        let itemsPerSection = 5
        let sections = Array(0..<5)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}
