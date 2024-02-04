//
//  ListAppearancesViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/04.
//

import UIKit
import ComposeLayout

class ListAppearancesViewController: UIViewController, Example {
    
    struct Item: Hashable {
        let title: String?
        private let identifier = UUID()
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    var collectionView: UICollectionView!
    
    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List Appearances"
        configureHierarchy()
        configureDataSource()
        updateBarButtonItem()
    }
}

extension ListAppearancesViewController {
    @objc
    private func changeListAppearance() {
        switch appearance {
        case .plain:
            appearance = .sidebarPlain
        case .sidebarPlain:
            appearance = .sidebar
        case .sidebar:
            appearance = .grouped
        case .grouped:
            appearance = .insetGrouped
        case .insetGrouped:
            appearance = .plain
        default:
            break
        }
        let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first
        dataSource.apply(dataSource.snapshot(), animatingDifferences: false)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        updateBarButtonItem()
    }
    
    private func updateBarButtonItem() {
        var title: String? = nil
        switch appearance {
        case .plain: 
            title = "Plain"
        case .sidebarPlain: 
            title = "Sidebar Plain"
        case .sidebar: 
            title = "Sidebar"
        case .grouped: 
            title = "Grouped"
        case .insetGrouped: 
            title = "Inset Grouped"
        default: break
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeListAppearance))
    }
}


extension ListAppearancesViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            var config = UICollectionLayoutListConfiguration(appearance: self.appearance)
            Section.list(using: config, layoutEnvironment: environment)
        }
        .build()
    }
}

extension ListAppearancesViewController {
    func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            switch self.appearance {
            case .sidebar, .sidebarPlain:
                cell.accessories = []
            default:
                cell.accessories = [.disclosureIndicator()]
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        let sections = Array(0..<5)
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            let headerItem = Item(title: "Section \(section)")
            sectionSnapshot.append([headerItem])
            let items = Array(0..<3).map { Item(title: "Item \($0)") }
            sectionSnapshot.append(items, to: headerItem)
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }
    }
}
