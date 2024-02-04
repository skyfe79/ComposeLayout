//
//  Example.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/02.
//

import Foundation
import UIKit

protocol Example: CollectionViewProvider, DiffableDataSourceProvider {
    func createLayout() -> UICollectionViewLayout
    func configureHierarchy() -> Void
    func configureDataSource() -> Void
}

extension Example where Self: UIViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

