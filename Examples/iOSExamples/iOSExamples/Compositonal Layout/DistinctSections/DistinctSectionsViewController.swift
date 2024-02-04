//
//  DistinctSectionsViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/02.
//

import UIKit
import ComposeLayout

class DistinctSectionsViewController: UIViewController, Example {
    
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
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }
    
}

extension DistinctSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension DistinctSectionsViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { index, environment in
            for section in SectionLayoutKind.allCases {
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
        }
        .build()
    }
}

extension DistinctSectionsViewController {
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
