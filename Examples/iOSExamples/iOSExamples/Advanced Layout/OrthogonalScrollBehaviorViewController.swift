//
//  OrthogonalScrollBehaviorViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/04.
//

import UIKit
import ComposeLayout

class OrthogonalScrollBehaviorViewController: UIViewController, Example {

    static let headerElementKind = "header-element-kind"
    
    enum SectionKind: Int, CaseIterable {
        case continuous
        case continuousGroupLeadingBoundary
        case paging
        case groupPaging
        case groupPagingCentered
        case none
        
        var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .none:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.none
            case .continuous:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
            case .continuousGroupLeadingBoundary:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary
            case .paging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.paging
            case .groupPaging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
            case .groupPagingCentered:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Section Behaviors"
        configureHierarchy()
        configureDataSource()
    }
    
}

extension OrthogonalScrollBehaviorViewController {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return ComposeLayout { sectionIndex, environment in
            let sectionKind = SectionKind(rawValue: sectionIndex) ?? .none
            let orthogonallyScrolls = sectionKind.orthogonalScrollingBehavior != .none
            Section(id: sectionIndex) {
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
                .width(orthogonallyScrolls ? .fractionalWidth(0.85) : .fractionalWidth(1.0))
                .height(.fractionalHeight(0.4))
            }
            .orthogonalScrollingBehavior(sectionKind.orthogonalScrollingBehavior)
            .boundarySupplementaryItems {
                BoundarySupplementaryItem(elementKind: Self.headerElementKind)
                    .alignment(.top)
                    .width(.fractionalWidth(1.0))
                    .height(.estimated(44))
            }
        }
        .using(configuration: config)
        .build()
    }
}

extension OrthogonalScrollBehaviorViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
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
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: Self.headerElementKind) {
            (supplementaryView, string, indexPath) in
            let sectionKind = SectionKind(rawValue: indexPath.section)!
            supplementaryView.label.text = "." + String(describing: sectionKind)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 18
        SectionKind.allCases.forEach {
            snapshot.appendSections([$0.rawValue])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
