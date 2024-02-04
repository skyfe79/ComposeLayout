//
//  SectionHeaderFooterViewController.swift
//  CocoaExample
//
//  Created by Sungcheol Kim on 2024/02/01.
//

import Cocoa
import ComposeLayout

class SectionHeaderFooterViewController: NSViewController {
    
    private static let sectionHeaderElementKind = "section-header-element-kind"
    private static let sectionFooterElementKind = "section-footer-element-kind"
    private enum Sections {
        case shared
    }
    
    @IBOutlet private weak var collectionView: NSCollectionView!
    private var dataSource: NSCollectionViewDiffableDataSource<Int, Int>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension SectionHeaderFooterViewController {
    private func createLayout() -> NSCollectionViewLayout {
        return ComposeLayout { sectionIndex, environment in
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            Section {
                HGroup {
                    Item(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
                }
                .width(.fractionalWidth(1.0))
                .height(.absolute(44))
            }
            .interGroupSpacing(5)
            .contentInsets(leading: 10, top: 0, trailing: 10, bottom: 0)
            .boundarySupplementaryItems {
                BoundarySupplementaryItem(elementKind: Self.sectionHeaderElementKind)
                    .size(headerFooterSize)
                    .alignment(.top)
                    .pinToVisibleBounds(true)
                BoundarySupplementaryItem(elementKind: Self.sectionFooterElementKind)
                    .size(headerFooterSize)
                    .alignment(.bottom)
            }
        }
        .build()
    }
}

extension SectionHeaderFooterViewController {
    private func configureHierarchy() {
        let itemNib = NSNib(nibNamed: "TextItem", bundle: nil)
        collectionView.register(itemNib, forItemWithIdentifier: TextItem.reuseIdentifier)

        let titleSupplementaryNib = NSNib(nibNamed: "TitleSupplementaryView", bundle: nil)
        collectionView.register(titleSupplementaryNib,
                    forSupplementaryViewOfKind: Self.sectionHeaderElementKind,
                    withIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.register(titleSupplementaryNib,
                    forSupplementaryViewOfKind: Self.sectionFooterElementKind,
                    withIdentifier: TitleSupplementaryView.reuseIdentifier)

        collectionView.collectionViewLayout = createLayout()
    }
    
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
                (collectionView: NSCollectionView, indexPath: IndexPath, identifier: Int) -> NSCollectionViewItem? in
            let item = collectionView.makeItem(withIdentifier: TextItem.reuseIdentifier, for: indexPath)
            item.textField?.stringValue = "\(indexPath.section),\(indexPath.item)"
            return item
        }
        dataSource.supplementaryViewProvider = {
            (collectionView: NSCollectionView, kind: String, indexPath: IndexPath) -> (NSView & NSCollectionViewElement)? in
            if let supplementaryView = collectionView.makeSupplementaryView(
                ofKind: kind,
                withIdentifier: TitleSupplementaryView.reuseIdentifier,
                for: indexPath) as? TitleSupplementaryView {
                let viewKind = kind == Self.sectionHeaderElementKind ? Self.sectionHeaderElementKind : Self.sectionFooterElementKind
                supplementaryView.label.stringValue = "\(viewKind) for section \(indexPath.section)"
                return supplementaryView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        // initial data
        let itemsPerSection = 5
        let sections = Array(0..<5)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
