//
//  AdaptiveSectionsViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/02.
//

import UIKit
import ComposeLayout

class AdaptiveSectionsViewController: UIViewController, Example {
    
    enum SectionLayoutKind: Int, CaseIterable {
        case list
        case grid5
        case grid3
        
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 400
            switch self {
            case .grid3:
                return wideMode ? 6 : 3
                
            case .grid5:
                return wideMode ? 10 : 5
                
            case .list:
                return wideMode ? 2 : 1
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }
    
}

extension AdaptiveSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension AdaptiveSectionsViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { environment in
            for section in SectionLayoutKind.allCases {
                let columns = section.columnCount(for: environment.container.effectiveContentSize.width)
                Section(id: section) {
                    HGroup(repeatItems: columns) {
                        Item()
                            .width(.fractionalWidth(0.2))
                            .height(.fractionalHeight(1.0))
                            .contentInsets(leading: 2, top: 2, trailing: 2, bottom: 2)
                    }
                    .height(section == .list ? .absolute(44) : .fractionalWidth(0.2))
                    .width(.fractionalWidth(1.0))
                }
                .contentInsets(leading: 20, top: 20, trailing: 20, bottom: 20)
            }
        }
        .build()
    }
}

extension AdaptiveSectionsViewController {
    func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<ListCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(identifier)"
        }
        
        let textCellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = SectionLayoutKind(rawValue: indexPath.section)! == .grid5 ? 8 : 0
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return SectionLayoutKind(rawValue: indexPath.section)! == .list ?
            collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: identifier) :
            collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: identifier)
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
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
