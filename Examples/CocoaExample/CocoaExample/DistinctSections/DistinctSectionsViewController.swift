//
//  DistinctSectionsViewController.swift
//  CocoaExample
//
//  Created by Sungcheol Kim on 2024/02/01.
//

import Cocoa
import ComposeLayout

class DistinctSectionsViewController: NSViewController {
    
    enum SectionLayoutKind: Int, CaseIterable {
        case list
        case grid5
        case grid3
     
        var columnCount: Int {
            switch self {
            case .grid3:
                return 3
            case .grid5:
                return 5
            case .list:
                return 1
            }
        }
    }
    
    @IBOutlet private weak var collectionView: NSCollectionView!
    private var dataSource: NSCollectionViewDiffableDataSource<SectionLayoutKind, Int>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension DistinctSectionsViewController {
    private func createLayout() -> NSCollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            let section = SectionLayoutKind.allCases[sectionIndex]
            let columns = section.columnCount
            Section {
                HGroup(repeatItems: columns) {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                        .contentInsets(leading: 2, top: 2, trailing: 2, bottom: 2)
                }
                .height(columns == 1 ? .absolute(44) : .fractionalWidth(0.2))
                .width(.fractionalWidth(1.0))
            }
            .contentInsets(leading: 20, top: 20, trailing: 20, bottom: 20)
        }
        .build()
    }
}


extension DistinctSectionsViewController {
    private func configureHierarchy() {
        let textItemNib = NSNib(nibNamed: "TextItem", bundle: nil)
        collectionView.register(textItemNib, forItemWithIdentifier: TextItem.reuseIdentifier)

        let listItemNib = NSNib(nibNamed: "ListItem", bundle: nil)
        collectionView.register(listItemNib, forItemWithIdentifier: ListItem.reuseIdentifier)

        collectionView.collectionViewLayout = createLayout()
        collectionView.isSelectable = true
    }
    
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) {
                (collectionView: NSCollectionView, indexPath: IndexPath, identifier: Int) -> NSCollectionViewItem? in

            guard
                let section = SectionLayoutKind(rawValue: indexPath.section)
            else {
                return nil
            }
            
            if section == .list {
                if let item = collectionView.makeItem(withIdentifier: ListItem.reuseIdentifier, for: indexPath) as? ListItem {
                    item.textField?.stringValue = "\(identifier)"
                    return item
                } else {
                    fatalError("Cannot create new item")
                }
            } else {
                if let item = collectionView.makeItem(withIdentifier: TextItem.reuseIdentifier, for: indexPath) as? TextItem {
                    item.textField?.stringValue = "\(identifier)"
                    if let box = item.view as? NSBox {
                        box.cornerRadius = section == .grid5 ? 8 : 0
                    }
                    return item
                } else {
                    fatalError("Cannot create new item")
                }
            }
        }

        // initial data
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
