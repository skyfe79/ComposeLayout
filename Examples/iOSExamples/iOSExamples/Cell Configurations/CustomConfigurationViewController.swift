//
//  CustomConfigurationViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/04.
//

import UIKit
import ComposeLayout

class CustomConfigurationViewController: UIViewController, Example {
    
    enum Sections: Hashable {
        case main
    }
    
    struct IconItem: Hashable {
        let image: UIImage?
        init(imageName: String) {
            self.image = UIImage(systemName: imageName)
        }
        private let identifier = UUID()
        
        static let all = Array(repeating: [
            "trash", "folder", "paperplane", "book", "tag", "camera", "pin",
            "lock.shield", "cube.box", "gift", "eyeglasses", "lightbulb"
        ], count: 25).flatMap { $0 }.shuffled().map { IconItem(imageName: $0) }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections, IconItem>!
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Custom Configurations"
        configureHierarchy()
        configureDataSource()
    }
 
}
 
extension CustomConfigurationViewController {
    func createLayout() -> UICollectionViewLayout {
        ComposeLayout { sectionIndex, environment in
            Section {
                HGroup {
                    Item()
                        .width(.estimated(44))
                        .height(.estimated(44))
                }
                .interItemSpacing(.flexible(10))
                .width(.fractionalWidth(1.0))
                .height(.estimated(44))
            }
            .interGroupSpacing(10)
            .contentInsets(leading: 10, top: 10, trailing: 10, bottom: 10)
        }
        .build()
    }
}

extension CustomConfigurationViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell, IconItem> { (cell, indexPath, item) in
            cell.image = item.image
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, IconItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: IconItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, IconItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(IconItem.all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

class CustomConfigurationCell: UICollectionViewCell {
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = CustomBackgroundConfiguration.configuration(for: state)
        
        var content = CustomContentConfiguration().updated(for: state)
        content.image = image
        contentConfiguration = content
    }
}
