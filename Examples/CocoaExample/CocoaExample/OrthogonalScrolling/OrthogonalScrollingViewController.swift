//
//  OrthogonalScrollingViewController.swift
//  CocoaExample
//
//  Created by Sungcheol Kim on 2024/02/01.
//

import Cocoa
import ComposeLayout

class OrthogonalScrollingViewController: NSViewController {
    
    private enum Sections: Int, CaseIterable {
        case first
        case second
    }
    
    @IBOutlet private weak var collectionView: NSCollectionView!
    private var dataSource: NSCollectionViewDiffableDataSource<Sections, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension OrthogonalScrollingViewController {
    private func createLayout() -> NSCollectionViewLayout {
        let config = NSCollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        return ComposeLayout { sectionIndex, environment in
            Section {
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
                .width(.fractionalHeight(1.4))
                .height(.fractionalHeight(0.7))
                .contentInsets(leading: 0, top: 0, trailing: 0, bottom: 20)
            }
            .orthogonalScrollingBehavior(.continuous)
            
            Section {
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
                .height(.fractionalHeight(0.5))
            }
        }
        .using(configuration: config)
        .build()
    }
}

extension OrthogonalScrollingViewController {
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
        let itemsPerSection = 30
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        Sections.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
