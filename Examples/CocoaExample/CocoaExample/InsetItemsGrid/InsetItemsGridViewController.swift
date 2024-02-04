//
//  InsetItemsGridViewController.swift
//  CocoaExample
//
//  Created by Sungcheol Kim on 2024/02/01.
//

import Cocoa
import ComposeLayout

class InsetItemsGridViewController: NSViewController {
    
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

extension InsetItemsGridViewController {
    private func createLayout() -> NSCollectionViewCompositionalLayout {
        ComposeLayout { sectionIndex, environment in
            Section {
                HGroup {
                    Item()
                        .width(.fractionalWidth(0.2))
                        .height(.fractionalHeight(1.0))
                        .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
                }
                .width(.fractionalWidth(1.0))
                .height(.fractionalWidth(0.2))
            }
        }
        .build()
    }
}

extension InsetItemsGridViewController {
    private func configureHierarchy() {
        let itemNib = NSNib(nibNamed: "TextItem", bundle: nil)
        collectionView.register(itemNib, forItemWithIdentifier: TextItem.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        collectionView.isSelectable = true
    }
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView, itemProvider: {
                (collectionView: NSCollectionView, indexPath: IndexPath, identifier: Int) -> NSCollectionViewItem? in
            let item = collectionView.makeItem(withIdentifier: TextItem.reuseIdentifier, for: indexPath)
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
