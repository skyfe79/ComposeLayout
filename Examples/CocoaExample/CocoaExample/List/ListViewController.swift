//
//  ListViewController.swift
//  CocoaExample
//
//  Created by codingmax on 2024/02/01.
//

import Cocoa
import ComposeLayout

class ListViewController: NSViewController {
    
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

extension ListViewController {
    private func createLayout() -> NSCollectionViewLayout {
        ComposeLayout { environment in
            Section(id: Sections.main) {
                HGroup {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(1.0))
                .height(.absolute(20))
            }
        }
        .build()
    }
}

extension ListViewController {
    private func configureHierarchy() {
        let itemNib = NSNib(nibNamed: "ListItem", bundle: nil)
        collectionView.register(itemNib, forItemWithIdentifier: ListItem.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        collectionView.isSelectable = true
    }
    
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView, itemProvider: { collectionView, indexPath, identifier in
            let item = collectionView.makeItem(withIdentifier: ListItem.reuseIdentifier, for: indexPath)
            item.textField?.stringValue = "\(identifier)"
            return item
        })
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
