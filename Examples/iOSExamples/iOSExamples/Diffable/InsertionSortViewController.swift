//
//  InsertionSortViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class InsertionSortViewController: UIViewController, Example {
    static let nodeSize = CGSize(width: 16, height: 34)
    static let reuseIdentifier = "cell-id"
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<InsertionSortArray, InsertionSortArray.SortNode>!
    var isSorting = false
    var isSorted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Insertion Sort Visualizer"
        configureHierarchy()
        configureDataSource()
        configureNavItem()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if dataSource != nil {
            let bounds = collectionView.bounds
            let snapshot = randomizedSnapshot(for: bounds)
            dataSource.apply(snapshot)
        }
    }
}

extension InsertionSortViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            let contentSize = environment.container.effectiveContentSize
            let columns = Int(contentSize.width / InsertionSortViewController.nodeSize.width)
            let rowHeight = InsertionSortViewController.nodeSize.height
            Section {
                HGroup(repeatItems: columns) {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(1.0))
                .height(.absolute(rowHeight))
            }
        }
        .build()
    }
}

extension InsertionSortViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, InsertionSortArray.SortNode> { (cell, indexPath, sortNode) in
            // Populate the cell with our item description.
            cell.backgroundColor = sortNode.color
        }
        
        dataSource = UICollectionViewDiffableDataSource<InsertionSortArray, InsertionSortArray.SortNode>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, node: InsertionSortArray.SortNode) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: node)
        }
        
        let bounds = collectionView.bounds
        let snapshot = randomizedSnapshot(for: bounds)
        dataSource.apply(snapshot)
    }
}

extension InsertionSortViewController {
    func configureNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isSorting ? "Stop" : "Sort",
                                                            style: .plain, target: self,
                                                            action: #selector(toggleSort))
    }
    
    @objc
    func toggleSort() {
        isSorting.toggle()
        if isSorting {
            performSortStep()
        }
        configureNavItem()
    }
    
    func performSortStep() {
        if !isSorting {
            return
        }

        var sectionCountNeedingSort = 0

        // Get the current state of the UI from the data source.
        var updatedSnapshot = dataSource.snapshot()

        // For each section, if needed, step through and perform the next sorting step.
        updatedSnapshot.sectionIdentifiers.forEach {
            let section = $0
            if !section.isSorted {

                // Step the sort algorithm.
                section.sortNext()
                let items = section.values

                // Replace the items for this section with the newly sorted items.
                updatedSnapshot.deleteItems(items)
                updatedSnapshot.appendItems(items, toSection: section)

                sectionCountNeedingSort += 1
            }
        }

        var shouldReset = false
        var delay = 125
        if sectionCountNeedingSort > 0 {
            dataSource.apply(updatedSnapshot)
        } else {
            delay = 1000
            shouldReset = true
        }
        let bounds = collectionView.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if shouldReset {
                let snapshot = self.randomizedSnapshot(for: bounds)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            self.performSortStep()
        }
    }
}

extension InsertionSortViewController {
    func randomizedSnapshot(for bounds: CGRect) -> NSDiffableDataSourceSnapshot<InsertionSortArray, InsertionSortArray.SortNode> {
        var snapshot = NSDiffableDataSourceSnapshot<InsertionSortArray, InsertionSortArray.SortNode>()
        let rowCount = rows(for: bounds)
        let columnCount = columns(for: bounds)
        for _ in 0..<rowCount {
            let section = InsertionSortArray(count: columnCount)
            snapshot.appendSections([section])
            snapshot.appendItems(section.values)
        }
        return snapshot
    }
    
    func rows(for bounds: CGRect) -> Int {
        return Int(bounds.height / InsertionSortViewController.nodeSize.height)
    }
    
    func columns(for bounds: CGRect) -> Int {
        return Int(bounds.width / InsertionSortViewController.nodeSize.width)
    }
}
