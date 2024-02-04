//
//  CustomVisibleItemsInvalidationHandlerViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class CustomVisibleItemsInvalidationHandlerViewController: UIViewController, Example {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, UIColor>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension CustomVisibleItemsInvalidationHandlerViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            Section {
                HGroup {
                    Item()
                        .width(.fractionalWidth(1.0/3.0))
                        .height(.fractionalHeight(1.0))
                }
                .width(.fractionalWidth(1.0))
                .height(.absolute(150))
            }
            .contentInsets(leading: 1.5, top: 30, trailing: 2.5, bottom: 30)
            .orthogonalScrollingBehavior(.continuous)
            .visibleItemsInvalidationHandler { items, offset, layoutEnvironment in
                items.forEach { item in
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.7
                    let maxScale: CGFloat = 1.1
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        .build()
    }
}

extension CustomVisibleItemsInvalidationHandlerViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, UIColor> { cell, indexPath, color in
            cell.contentView.backgroundColor = color
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, UIColor>(collectionView: collectionView) { collectionView, indexPath, color in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: color)
        }
        
        let sections = Array(0..<3)
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIColor>()
        sections.forEach {
            snapshot.appendSections([$0])
            switch $0 {
            case 0:
                snapshot.appendItems(Array(0..<10).map { UIColor(hue: CGFloat($0) / 10.0, saturation: 1.0, brightness: 1.0, alpha: 1.0) })
            case 1:
                snapshot.appendItems(Array(0..<10).map { UIColor(hue: CGFloat($0) / 10.0, saturation: CGFloat($0) / 10.0, brightness: 1.0, alpha: 1.0) })
            case 2:
                snapshot.appendItems(Array(0..<10).map { UIColor(hue: CGFloat($0) / 10.0, saturation: CGFloat($0) / 10.0, brightness: CGFloat($0) / 10.0, alpha: 1.0) })
            default:
                break
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
