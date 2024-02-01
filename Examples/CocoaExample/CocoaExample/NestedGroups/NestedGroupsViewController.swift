//
//  NestedGroupsViewController.swift
//  CocoaExample
//
//  Created by codingmax on 2024/02/01.
//

import Cocoa
import ComposeLayout

class NestedGroupsViewController: NSViewController {
    
    private enum Sections {
        case main
    }
    
    @IBOutlet private weak var collectionView: NSCollectionView!
    private var dataSource: NSCollectionViewDiffableDataSource<Sections, Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension NestedGroupsViewController {
    private func createLayout() -> NSCollectionViewLayout {
        ComposeLayout { environment in
            Section(id: Sections.main) {
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
                .width(.fractionalWidth(1.0))
                .height(.fractionalHeight(0.4))
            }
        }
        .build()
    }
}

extension NestedGroupsViewController {
    private func configureHierarchy() {
        let textItemNib = NSNib(nibNamed: "TextItem", bundle: nil)
        collectionView.register(textItemNib, forItemWithIdentifier: TextItem.reuseIdentifier)
        
        let listItemNib = NSNib(nibNamed: "ListItem", bundle: nil)
        collectionView.register(listItemNib, forItemWithIdentifier: ListItem.reuseIdentifier)
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.isSelectable = true
    }
    
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView, itemProvider: {
            (collectionView: NSCollectionView, indexPath: IndexPath, identifier: Int) -> NSCollectionViewItem? in
            if let item = collectionView.makeItem(withIdentifier: TextItem.reuseIdentifier, for: indexPath) as? TextItem {
                item.textField?.stringValue = "\(indexPath.section), \(indexPath.item)"
                if let box = item.view as? NSBox {
                    box.cornerRadius = 8
                }
                return item
            } else {
                fatalError("Cannot create new item")
            }
        })
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<100))
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
