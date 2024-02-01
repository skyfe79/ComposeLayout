//
//  SectionHeaderFooterViewController.swift
//  CocoaExample
//
//  Created by codingmax on 2024/02/01.
//

import Cocoa
import ComposeLayout

class SectionHeaderFooterViewController: NSViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    @IBOutlet private weak var collectionView: NSCollectionView!
    private var dataSource: NSCollectionViewDiffableDataSource<Int, Int>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension SectionHeaderFooterViewController {
    private func createLayout2() -> NSCollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerFooterSize,
//            elementKind: Self.sectionHeaderElementKind,
//            alignment: .top)
//        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerFooterSize,
//            elementKind: Self.sectionFooterElementKind,
//            alignment: .bottom)
//        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = NSCollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func createLayout() -> NSCollectionViewLayout {
        return ComposeLayout { environment in
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            Section(id: "section") {
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
