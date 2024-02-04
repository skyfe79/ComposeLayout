//
//  EmojiExplorerViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class EmojiExplorerViewController: UIViewController, Example {
    
    enum Sections: Int, Hashable, CaseIterable, CustomStringConvertible {
        case recents, outline, list
        
        var description: String {
            switch self {
            case .recents: return "Recents"
            case .outline: return "Outline"
            case .list: return "List"
            }
        }
    }
    
    struct EmojiItem: Hashable {
        let title: String?
        let emoji: Emoji?
        let hasChildren: Bool
        init(emoji: Emoji? = nil, title: String? = nil, hasChildren: Bool = false) {
            self.emoji = emoji
            self.title = title
            self.hasChildren = hasChildren
        }
        private let identifier = UUID()
    }
    
    var starredEmojis = Set<EmojiItem>()
    
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

extension EmojiExplorerViewController {
    private func recentsSection() -> Section {
        Section {
            HGroup {
                Item()
                    .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
                    .width(.fractionalWidth(1.0))
                    .height(.fractionalHeight(1.0))
            }
            .width(.fractionalWidth(0.28))
            .height(.fractionalWidth(0.2))
        }
        .interGroupSpacing(10)
        .orthogonalScrollingBehavior(.continuousGroupLeadingBoundary)
        .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
    }
    
    private func outlineSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> Section {
        let section = Section.list(using: .init(appearance: .sidebar), layoutEnvironment: layoutEnvironment)
        return section.contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
    }
    
    private func listSectioin(layoutEnvironment: NSCollectionLayoutEnvironment) -> Section {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
            guard let self = self else { return nil }
            guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
            return self.leadingSwipeActionConfigurationForListCellItem(item)
        }
        return Section.list(using: configuration, layoutEnvironment: layoutEnvironment)
    }
    
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { [unowned self] sectionIndex, environment in
            let sectionKind = Sections(rawValue: sectionIndex)
            if sectionKind == .recents {
                self.recentsSection()
            }
            if sectionKind == .outline {
                self.outlineSection(layoutEnvironment: environment)
            }
            if sectionKind == .list {
                self.listSectioin(layoutEnvironment: environment)
            }
        }
        .build()
    }
}

extension EmojiExplorerViewController {
    
    func configureNavItem() {
        navigationItem.title = "Emoji Explorer"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func accessoriesForListCellItem(_ item: EmojiItem) -> [UICellAccessory] {
        let isStarred = self.starredEmojis.contains(item)
        var accessories = [UICellAccessory.disclosureIndicator()]
        if isStarred {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            accessories.append(.customView(configuration: .init(customView: star, placement: .trailing())))
        }
        return accessories
    }
    
    func leadingSwipeActionConfigurationForListCellItem(_ item: EmojiItem) -> UISwipeActionsConfiguration? {
        let isStarred = self.starredEmojis.contains(item)
        let starAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            // Don't check again for the starred state. We promised in the UI what this action will do.
            // If the starred state has changed by now, we do nothing, as the set will not change.
            if isStarred {
                self.starredEmojis.remove(item)
            } else {
                self.starredEmojis.insert(item)
            }
            
            // Reconfigure the cell of this item
            // Make sure we get the current index path of the item.
            if let currentIndexPath = self.dataSource.indexPath(for: item) {
                if let cell = self.collectionView.cellForItem(at: currentIndexPath) as? UICollectionViewListCell {
                    UIView.animate(withDuration: 0.2) {
                        cell.accessories = self.accessoriesForListCellItem(item)
                    }
                }
            }
            
            completion(true)
        }
        starAction.image = UIImage(systemName: isStarred ? "star.slash" : "star.fill")
        starAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [starAction])
    }
    
    func createGridCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Emoji> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Emoji> { (cell, indexPath, emoji) in
            var content = UIListContentConfiguration.cell()
            content.text = emoji.text
            content.textProperties.font = .boldSystemFont(ofSize: 38)
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            background.strokeWidth = 1.0 / cell.traitCollection.displayScale
            cell.backgroundConfiguration = background
        }
    }
    
    func createOutlineHeaderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, title) in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure(options: .init(style: .header))]
        }
    }
    
    func createOutlineCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Emoji> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Emoji> { (cell, indexPath, emoji) in
            var content = cell.defaultContentConfiguration()
            content.text = emoji.text
            content.secondaryText = emoji.title
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    /// - Tag: ConfigureListCell
    func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, EmojiItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, EmojiItem> { [weak self] (cell, indexPath, item) in
            guard let self = self, let emoji = item.emoji else { return }
            var content = UIListContentConfiguration.valueCell()
            content.text = emoji.text
            content.secondaryText = String(describing: emoji.category)
            cell.contentConfiguration = content
            cell.accessories = self.accessoriesForListCellItem(item)
        }
    }
    
    /// - Tag: DequeueCells
    func configureDataSource() {
        // create registrations up front, then choose the appropriate one to use in the cell provider
        let gridCellRegistration = createGridCellRegistration()
        let listCellRegistration = createListCellRegistration()
        let outlineHeaderCellRegistration = createOutlineHeaderCellRegistration()
        let outlineCellRegistration = createOutlineCellRegistration()
        
        // data source
        dataSource = UICollectionViewDiffableDataSource<Sections, EmojiItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Sections(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .recents:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item.emoji)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            case .outline:
                if item.hasChildren {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineHeaderCellRegistration, for: indexPath, item: item.title!)
                } else {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineCellRegistration, for: indexPath, item: item.emoji)
                }
            }
        }
    }
    
    /// - Tag: SectionSnapshot
    func applyInitialSnapshots() {

        // set the order for our sections

        let sections = Sections.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Sections, EmojiItem>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // recents (orthogonal scroller)
        
        let recentItems = Emoji.Category.recents.emojis.map { EmojiItem(emoji: $0) }
        var recentsSnapshot = NSDiffableDataSourceSectionSnapshot<EmojiItem>()
        recentsSnapshot.append(recentItems)
        dataSource.apply(recentsSnapshot, to: .recents, animatingDifferences: false)

        // list of all + outlines
        
        var allSnapshot = NSDiffableDataSourceSectionSnapshot<EmojiItem>()
        var outlineSnapshot = NSDiffableDataSourceSectionSnapshot<EmojiItem>()
        
        for category in Emoji.Category.allCases where category != .recents {
            // append to the "all items" snapshot
            let allSnapshotItems = category.emojis.map { EmojiItem(emoji: $0) }
            allSnapshot.append(allSnapshotItems)
            
            // setup our parent/child relations
            let rootItem = EmojiItem(title: String(describing: category), hasChildren: true)
            outlineSnapshot.append([rootItem])
            let outlineItems = category.emojis.map { EmojiItem(emoji: $0) }
            outlineSnapshot.append(outlineItems, to: rootItem)
        }
        
        dataSource.apply(recentsSnapshot, to: .recents, animatingDifferences: false)
        dataSource.apply(allSnapshot, to: .list, animatingDifferences: false)
        dataSource.apply(outlineSnapshot, to: .outline, animatingDifferences: false)
        
        // prepopulate starred emojis
        
        for _ in 0..<5 {
            if let item = allSnapshot.items.randomElement() {
                self.starredEmojis.insert(item)
            }
        }
    }
}

extension EmojiExplorerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emoji = self.dataSource.itemIdentifier(for: indexPath)?.emoji else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = EmojiDetailViewController(with: emoji)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
