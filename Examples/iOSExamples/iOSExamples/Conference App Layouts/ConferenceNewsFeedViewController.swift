//
//  ConferenceNewsFeedViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class ConferenceNewsFeedViewController: UIViewController, Example {
    enum Sections {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, ConferenceNewsController.NewsFeedItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Conference News Feed"
        configureHierarchy()
        configureDataSource()
    }

}

extension ConferenceNewsFeedViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            Section {
                HGroup {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.estimated(100))
                }
                .width(.fractionalWidth(1.0))
                .height(.estimated(100))
            }
            .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
            .interGroupSpacing(10)
        }
        .build()
    }
}

extension ConferenceNewsFeedViewController {
    func configureDataSource() {
        let newsController = ConferenceNewsController()
        
        let cellRegistration = UICollectionView.CellRegistration<ConferenceNewsFeedCell, ConferenceNewsController.NewsFeedItem> { (cell, indexPath, newsItem) in
            // Populate the cell with our item description.
            cell.titleLabel.text = newsItem.title
            cell.bodyLabel.text = newsItem.body

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.dateLabel.text = dateFormatter.string(from: newsItem.date)
            cell.showsSeparator = indexPath.item != newsController.items.count - 1
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, ConferenceNewsController.NewsFeedItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ConferenceNewsController.NewsFeedItem) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        
        // load our data
        let newsItems = newsController.items
        var snapshot = NSDiffableDataSourceSnapshot<Sections, ConferenceNewsController.NewsFeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newsItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
