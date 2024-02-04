//
//  ItemBadgeSupplementaryViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/02.
//

import UIKit
import ComposeLayout

class ItemBadgeSupplementaryViewController: UIViewController, Example {
    
    static let badgeElementKind = "badge-element-kind"
    enum Sections {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, BadgeModel>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Item Badges"
        configureHierarchy()
        configureDataSource()
    }
    
}

extension ItemBadgeSupplementaryViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            Section(id: Sections.main) {
                HGroup {
                    Item()
                        .width(.fractionalWidth(0.25))
                        .height(.fractionalHeight(1.0))
                        .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
                        .supplementaryItems {
                            SupplementaryItem(elementKind: Self.badgeElementKind)
                                .width(.absolute(20))
                                .height(.absolute(20))
                                .containerAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
                        }
                }
                .width(.fractionalWidth(1.0))
                .height(.fractionalWidth(0.2))
            }
            .contentInsets(leading: 20, top: 20, trailing: 20, bottom: 20)
        }
        .build()
    }
}

extension ItemBadgeSupplementaryViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, BadgeModel> { (cell, indexPath, model) in
            // Populate the cell with our item description.
            cell.label.text = model.title
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<BadgeSupplementaryView>(elementKind: ItemBadgeSupplementaryViewController.badgeElementKind) {
            (badgeView, string, indexPath) in
            guard let model = self.dataSource.itemIdentifier(for: indexPath) else { return }
            let hasBadgeCount = model.badgeCount > 0
            // Set the badge count as its label (and hide the view if the badge count is zero).
            badgeView.label.text = "\(model.badgeCount)"
            badgeView.isHidden = !hasBadgeCount
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, BadgeModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: BadgeModel) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        
        dataSource.supplementaryViewProvider = {
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: $2)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, BadgeModel>()
        snapshot.appendSections([.main])
        let models = (0..<100).map { BadgeModel(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
