//
//  MountainsViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/04.
//

import UIKit
import ComposeLayout

class MountainsViewController: UIViewController, Example {
    
    enum Sections: CaseIterable {
        case main
    }
    
    let mountainsController = MountainsController()
    let searchBar = UISearchBar(frame: .zero)
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections, MountainsController.Mountain>!
    var nameFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mountains Search"
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }

}

extension MountainsViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            let contentSize = environment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            Section(id: Sections.main) {
                HGroup(repeatItems: columns) {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(1.0))
                .height(.absolute(32))
                .interItemSpacing(.fixed(spacing))
            }
            .interGroupSpacing(spacing)
            .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
        }
        .build()
    }
}

extension MountainsViewController {
    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        searchBar.delegate = self
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LabelCell, MountainsController.Mountain> { cell, indexPath, mountain in
            cell.label.text = mountain.name
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, MountainsController.Mountain>(collectionView: collectionView, cellProvider: { collectionView, indexPath, mountain in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: mountain)
        })
    }
    
    func performQuery(with filter: String?) {
        let mountains = mountainsController.filteredMountains(with: filter).sorted { $0.name < $1.name }
        
        var snapshot = NSDiffableDataSourceSnapshot<Sections, MountainsController.Mountain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MountainsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}
