//
//  EmojiExplorerListViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class EmojiExplorerListViewController: UIViewController, Example {
    
    typealias Sections = Emoji.Category
    struct EmojiItem: Hashable {
        let title: String
        let emoji: Emoji
        init(emoji: Emoji, title: String) {
            self.emoji = emoji
            self.title = title
        }
        private let identifier = UUID()
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, EmojiItem>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItem()
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshots()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
            if let coordinator = self.transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.collectionView.deselectItem(at: indexPath, animated: true)
                }) { (context) in
                    if context.isCancelled {
                        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    }
                }
            } else {
                self.collectionView.deselectItem(at: indexPath, animated: animated)
            }
        }
    }
}

extension EmojiExplorerListViewController {
    
    func configureNavItem() {
        navigationItem.title = "Emoji Explorer - List"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return ComposeLayout.list(using: configuration)
    }
    
    /// - Tag: ValueCellConfiguration
    func configureDataSource() {

        // list cell
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Emoji> { (cell, indexPath, emoji) in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = emoji.text
            contentConfiguration.secondaryText = String(describing: emoji.category)
            cell.contentConfiguration = contentConfiguration

            cell.accessories = [.disclosureIndicator()]
        }
        
        // data source
        dataSource = UICollectionViewDiffableDataSource<Sections, EmojiItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item.emoji)
        }
    }
    
    func applyInitialSnapshots() {
        for category in Emoji.Category.allCases.reversed() {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<EmojiItem>()
            let items = category.emojis.map { EmojiItem(emoji: $0, title: String(describing: category)) }
            sectionSnapshot.append(items)
            dataSource.apply(sectionSnapshot, to: category, animatingDifferences: false)
        }
    }
}

extension EmojiExplorerListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emoji = self.dataSource.itemIdentifier(for: indexPath)?.emoji else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = EmojiDetailViewController(with: emoji)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

