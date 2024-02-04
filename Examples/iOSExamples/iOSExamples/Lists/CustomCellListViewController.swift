//
//  CustomCellListViewController.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/04.
//

import UIKit
import ComposeLayout

class CustomCellListViewController: UIViewController, Example {
    
    enum Sections: Hashable {
        case main
    }

    struct Category: Hashable {
        let icon: UIImage?
        let name: String?
        
        static let music = Category(icon: UIImage(systemName: "music.mic"), name: "Music")
        static let transportation = Category(icon: UIImage(systemName: "car"), name: "Transportation")
        static let weather = Category(icon: UIImage(systemName: "cloud.rain"), name: "Weather")
    }

    struct ItemModel: Hashable {
        let category: Category
        let image: UIImage?
        let title: String?
        let description: String?
        init(category: Category, imageName: String? = nil, title: String? = nil, description: String? = nil) {
            self.category = category
            if let systemName = imageName {
                self.image = UIImage(systemName: systemName)
            } else {
                self.image = nil
            }
            self.title = title
            self.description = description
        }
        private let identifier = UUID()
        
        static let all = [
            ItemModel(category: .music, imageName: "headphones", title: "Headphones",
                 description: "A portable pair of earphones that are used to listen to music and other forms of audio."),
            ItemModel(category: .music, imageName: "hifispeaker.fill", title: "Loudspeaker",
                 description: "A device used to reproduce sound by converting electrical impulses into audio waves."),
            ItemModel(category: .transportation, imageName: "airplane", title: "Plane",
                 description: "A commercial airliner used for long distance travel."),
            ItemModel(category: .transportation, imageName: "tram.fill", title: "Tram",
                 description: "A trolley car used as public transport in cities."),
            ItemModel(category: .transportation, imageName: "car.fill", title: "Car",
                 description: "A personal vehicle with four wheels that is able to carry a small number of people."),
            ItemModel(category: .weather, imageName: "hurricane", title: "Hurricane",
                 description: "A tropical cyclone in the Caribbean with violent wind."),
            ItemModel(category: .weather, imageName: "tornado", title: "Tornado",
                 description: "A destructive vortex of swirling violent winds that advances beneath a large storm system."),
            ItemModel(category: .weather, imageName: "tropicalstorm", title: "Tropical Storm",
                 description: "A localized, intense low-pressure system, forming over tropical oceans."),
            ItemModel(category: .weather, imageName: "snow", title: "Snow",
                 description: "Atmospheric water vapor frozen into ice crystals falling in light flakes.")
        ]
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Sections, ItemModel>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List with Custom Cells"
        configureHierarchy()
        configureDataSource()
    }
    
}

extension CustomCellListViewController {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return ComposeLayout.list(using: config)
    }
}

extension CustomCellListViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CustomListCell, ItemModel> { (cell, indexPath, item) in
            cell.updateWithItem(item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections, ItemModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ItemModel) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, ItemModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ItemModel.all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// Declare a custom key for a custom `item` property.
fileprivate extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("com.apple.ItemListCell.item")
}

// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
    var item: CustomCellListViewController.ItemModel? {
        set { self[.item] = newValue }
        get { return self[.item] as? CustomCellListViewController.ItemModel }
    }
}

// This list cell subclass is an abstract class with a property that holds the item the cell is displaying,
// which is added to the cell's configuration state for subclasses to use when updating their configuration.
private class ItemListCell: UICollectionViewListCell {
    private var item: CustomCellListViewController.ItemModel? = nil
    
    func updateWithItem(_ newItem: CustomCellListViewController.ItemModel) {
        guard item != newItem else { return }
        item = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.item = self.item
        return state
    }
}

private class CustomListCell: ItemListCell {
    
    private func defaultListContentConfiguration() -> UIListContentConfiguration { return .subtitleCell() }
    private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
    
    private let categoryIconView = UIImageView()
    private let categoryLabel = UILabel()
    private var customViewConstraints: (categoryLabelLeading: NSLayoutConstraint,
                                        categoryLabelTrailing: NSLayoutConstraint,
                                        categoryIconTrailing: NSLayoutConstraint)?
    
    private func setupViewsIfNeeded() {
        // We only need to do anything if we haven't already setup the views and created constraints.
        guard customViewConstraints == nil else { return }
        
        contentView.addSubview(listContentView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryIconView)
        listContentView.translatesAutoresizingMaskIntoConstraints = false
        let defaultHorizontalCompressionResistance = listContentView.contentCompressionResistancePriority(for: .horizontal)
        listContentView.setContentCompressionResistancePriority(defaultHorizontalCompressionResistance - 1, for: .horizontal)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryIconView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = (
            categoryLabelLeading: categoryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
            categoryLabelTrailing: categoryIconView.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor),
            categoryIconTrailing: contentView.trailingAnchor.constraint(equalTo: categoryIconView.trailingAnchor)
        )
        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            constraints.categoryLabelLeading,
            constraints.categoryLabelTrailing,
            constraints.categoryIconTrailing
        ])
        customViewConstraints = constraints
    }
    
    private var separatorConstraint: NSLayoutConstraint?
    private func updateSeparatorConstraint() {
        guard let textLayoutGuide = listContentView.textLayoutGuide else { return }
        if let existingConstraint = separatorConstraint, existingConstraint.isActive {
            return
        }
        let constraint = separatorLayoutGuide.leadingAnchor.constraint(equalTo: textLayoutGuide.leadingAnchor)
        constraint.isActive = true
        separatorConstraint = constraint
    }
    
    /// - Tag: UpdateConfiguration
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        // Configure the list content configuration and apply that to the list content view.
        var content = defaultListContentConfiguration().updated(for: state)
        content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)
        content.image = state.item?.image
        content.text = state.item?.title
        content.secondaryText = state.item?.description
        content.axesPreservingSuperviewLayoutMargins = []
        listContentView.configuration = content
        
        // Get the list value cell configuration for the current state, which we'll use to obtain the system default
        // styling and metrics to copy to our custom views.
        let valueConfiguration = UIListContentConfiguration.valueCell().updated(for: state)
        
        // Configure custom image view for the category icon, copying some of the styling from the value cell configuration.
        categoryIconView.image = state.item?.category.icon
        categoryIconView.tintColor = valueConfiguration.imageProperties.resolvedTintColor(for: tintColor)
        categoryIconView.preferredSymbolConfiguration = .init(font: valueConfiguration.secondaryTextProperties.font, scale: .small)
        
        // Configure custom label for the category name, copying some of the styling from the value cell configuration.
        categoryLabel.text = state.item?.category.name
        categoryLabel.textColor = valueConfiguration.secondaryTextProperties.resolvedColor()
        categoryLabel.font = valueConfiguration.secondaryTextProperties.font
        categoryLabel.adjustsFontForContentSizeCategory = valueConfiguration.secondaryTextProperties.adjustsFontForContentSizeCategory
        
        // Update some of the constraints for our custom views using the system default metrics from the configurations.
        customViewConstraints?.categoryLabelLeading.constant = content.directionalLayoutMargins.trailing
        customViewConstraints?.categoryLabelTrailing.constant = valueConfiguration.textToSecondaryTextHorizontalPadding
        customViewConstraints?.categoryIconTrailing.constant = content.directionalLayoutMargins.trailing
        updateSeparatorConstraint()
    }
}
