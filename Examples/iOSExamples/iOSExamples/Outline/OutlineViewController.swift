//
//  OutlineViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/02.
//

import UIKit
import ComposeLayout

class OutlineViewController: UIViewController, CollectionViewProvider, DiffableDataSourceProvider {

    enum Sections {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, OutlineItem>!
    
    private lazy var gettingStarted: OutlineItem = {
        OutlineItem(title: "Getting Started", subitems: [
            OutlineItem(title: "Grid", viewController: GridViewController.self),
            OutlineItem(title: "Inset Items Grid", viewController: InsetItemsGridViewController.self),
            OutlineItem(title: "Two-Column Grid", viewController: TwoColumnViewController.self),
            OutlineItem(title: "Per-Section Layout", subitems: [
                OutlineItem(title: "Distinct Sections", viewController: DistinctSectionsViewController.self),
                OutlineItem(title: "Adaptive Sections", viewController: AdaptiveSectionsViewController.self)
            ])
        ])
    }()
    
    private lazy var advancedLayouts: OutlineItem = {
        OutlineItem(title: "Advanced Layouts", subitems: [
            OutlineItem(title: "Supplementary Views", subitems: [
                OutlineItem(title: "Item Badges", viewController: ItemBadgeSupplementaryViewController.self),
                OutlineItem(title: "Section Headers/Footers", viewController: SectionHeadersFootersViewController.self),
                OutlineItem(title: "Pinned Section Headers", viewController: PinnedSectionHeaderFooterViewController.self)
            ]),
            OutlineItem(title: "Section Background Decoration", viewController: SectionDecorationViewController.self),
            OutlineItem(title: "Nested Groups", viewController: NestedGroupsViewController.self),
            OutlineItem(title: "Orthogonal Sections", subitems: [
                OutlineItem(title: "Orthogonal Sections", viewController: OrthogonalScrollingViewController.self),
                OutlineItem(title: "Orthogonal Section Behaviors", viewController: OrthogonalScrollBehaviorViewController.self)
            ])
        ])
    }()
    
    private lazy var conferenceAppLayouts: OutlineItem = {
        OutlineItem(title: "Conference App", subitems: [
            OutlineItem(title: "Videos", viewController: ConferenceVideoSessionsViewController.self),
            OutlineItem(title: "News", viewController: ConferenceNewsFeedViewController.self)
        ])
    }()
    
    private lazy var diffableDataSource: OutlineItem = {
        OutlineItem(title: "Diffable Data Source", subitems: [
            OutlineItem(title: "Mountains Search", viewController: MountainsViewController.self),
            OutlineItem(title: "Insertion Sort Visualization", viewController: InsertionSortViewController.self)
        ])
    }()
    
    private lazy var listsLayout: OutlineItem = {
        OutlineItem(title: "Lists", subitems: [
            OutlineItem(title: "Simple List", viewController: SimpleListViewController.self),
            OutlineItem(title: "Reorderable List", viewController: ReorderableListViewController.self),
            OutlineItem(title: "List Appearances", viewController: ListAppearancesViewController.self),
            OutlineItem(title: "List with Custom Cells", viewController: CustomCellListViewController.self)
        ])
    }()
    
    private lazy var outlines: OutlineItem = {
        OutlineItem(title: "Emoji", subitems: [
            OutlineItem(title: "Emoji Explorer", viewController: EmojiExplorerViewController.self),
            OutlineItem(title: "Emoji Explorer - List", viewController: EmojiExplorerListViewController.self)
        ])
    }()
    
    private lazy var cellConfiguration: OutlineItem = {
        OutlineItem(title: "Cell Configurations", subitems: [
            OutlineItem(title: "Custom Configurations", viewController: CustomConfigurationViewController.self)
        ])
    }()
    
    private lazy var customVisibleItemsInvalidateHandler: OutlineItem = {
        OutlineItem(title: "Visible Items Invalidate Handler", subitems: [
            OutlineItem(title: "Custom Effect", viewController: CustomVisibleItemsInvalidationHandlerViewController.self)
        ])
    }()
    
    private lazy var development: OutlineItem = {
        OutlineItem(title: "Development", subitems: [
            OutlineItem(title: "Testbed", viewController: DevViewController.self)
        ])
    }()
    
    private lazy var menuItems: [OutlineItem] = {
        return [
            OutlineItem(title: "Compositional Layout", subitems: [
                self.gettingStarted,
                self.advancedLayouts,
                self.conferenceAppLayouts
            ]),
            self.diffableDataSource,
            self.listsLayout,
            self.outlines,
            self.cellConfiguration,
            self.customVisibleItemsInvalidateHandler,
            self.development
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Modern Collection Views"
        configureCollectionView()
        configureDataSource()
    }
    
}

extension OutlineViewController {
    func generateLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        return ComposeLayout.list(using: configuration)
    }
}

extension OutlineViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        self.collectionView = collectionView
        collectionView.delegate = self
    }
}

extension OutlineViewController {
    func configureDataSource() {
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, OutlineItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return if item.subitems.isEmpty {
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            } else {
                collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
            }
        })
        
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
    
    func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        
        func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
            snapshot.append(menuItems, to: parent)
            for menuItem in menuItems where !menuItem.subitems.isEmpty {
                addItems(menuItem.subitems, to: menuItem)
            }
        }
        
        addItems(menuItems, to: nil)
        return snapshot
    }
}

extension OutlineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let menuItem = self.dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let viewControllerClass = menuItem.outlineViewController {
            let vc = viewControllerClass.init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
