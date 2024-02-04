//
//  TwoColumnsGridViewController.swift
//  CocoaExample
//
//  Created by Sungcheol Kim on 2024/02/01.
//

import Cocoa
import ComposeLayout

class TwoColumnsGridViewController: NSViewController {
    
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


extension TwoColumnsGridViewController {
    private func createLayout() -> NSCollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            Section {
                HGroup(repeatItems: 2) {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                }
                .interItemSpacing(.fixed(10))
                .width(.fractionalWidth(1.0))
                .height(.absolute(44))
            }
            .interGroupSpacing(10)
            .contentInsets(leading: 10, top: 0, trailing: 10, bottom: 0)
        }
        .build()
    }
}

extension TwoColumnsGridViewController {
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
