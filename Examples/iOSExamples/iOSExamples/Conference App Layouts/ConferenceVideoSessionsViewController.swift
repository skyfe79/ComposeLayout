//
//  ConferenceVideoSessionsViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/04.
//

import UIKit
import ComposeLayout

class ConferenceVideoSessionsViewController: UIViewController, Example {
    
    static let titleElementKind = "title-element-kind"
    
    let videosController = ConferenceVideoController()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Conference Videos"
        configureHierarchy()
        configureDataSource()
    }
    
}

extension ConferenceVideoSessionsViewController {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        return ComposeLayout { sectionIndex, environment in
            Section {
                let groupFractionalWidth = CGFloat(environment.container.effectiveContentSize.width > 500 ? 0.425 : 0.85)
                HGroup {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(groupFractionalWidth))
                .height(.absolute(250))
            }
            .contentInsets(leading: 20, top: 0, trailing: 20, bottom: 0)
            .orthogonalScrollingBehavior(.continuous)
            .interGroupSpacing(20)
            .boundarySupplementaryItems {
                BoundarySupplementaryItem(elementKind: Self.titleElementKind)
                    .alignment(.top)
                    .width(.fractionalWidth(1.0))
                    .height(.estimated(44))
            }
        }
        .using(configuration: config)
        .build()
    }
}

extension ConferenceVideoSessionsViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ConferenceVideoCell, ConferenceVideoController.Video> { (cell, indexPath, video) in
            // Populate the cell with our item description.
            cell.titleLabel.text = video.title
            cell.categoryLabel.text = video.category
        }
        
        dataSource = UICollectionViewDiffableDataSource<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, video: ConferenceVideoController.Video) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: video)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: ConferenceVideoSessionsViewController.titleElementKind) {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                // Populate the view with our section's description.
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = videoCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>()
        videosController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.videos)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}
