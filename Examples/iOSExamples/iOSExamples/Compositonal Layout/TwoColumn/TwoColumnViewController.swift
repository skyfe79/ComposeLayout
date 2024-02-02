//
//  TwoColumnViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/02.
//

import UIKit
import ComposeLayout

class TwoColumnViewController: UIViewController, Example {
    
    enum Sections {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension TwoColumnViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { environment in
            Section(id: Sections.main) {
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

extension TwoColumnViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(itemIdentifier)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
