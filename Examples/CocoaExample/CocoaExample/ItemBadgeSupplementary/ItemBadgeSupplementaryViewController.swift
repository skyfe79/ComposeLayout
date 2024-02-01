//
//  ItemBadgeSupplementaryViewController.swift
//  CocoaExample
//
//  Created by codingmax on 2024/02/01.
//

import Cocoa
import ComposeLayout

class BadgeView: NSBox, NSCollectionViewElement {
}

class ItemBadgeSupplementaryViewController: NSViewController, NSWindowDelegate {
    
    static let badgeElementKind = "badge-element-kind"
    static let badgeSupplementaryViewReuseIdentifier = NSUserInterfaceItemIdentifier("contact-badge-reuse-identifier")

    enum Sections {
        case main
    }

    struct Model: Hashable {
        let title: String
        let badgeCount: Int

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    @IBOutlet private weak var collectionView: NSCollectionView!
    private var dataSource: NSCollectionViewDiffableDataSource<Sections, Model>! = nil
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.delegate = self
        self.view.window?.minSize = NSSize(width: 320, height: 240)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension ItemBadgeSupplementaryViewController {
    private func createLayout() -> NSCollectionViewLayout {
        ComposeLayout { environment in
            Section(id: Sections.main) {
                HGroup {
                    Item(width: .fractionalWidth(0.25), height: .fractionalHeight(1.0))
                        .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
                        .supplementaryItems {
                            SupplementaryItem(elementKind: Self.badgeElementKind)
                                .width(.absolute(20))
                                .height(.absolute(20))
                                .containerAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
                        }
                }
                .width(.fractionalWidth(1.0))
                .height(.fractionalWidth(0.2))
            }
            .contentInsets(leading: 20, top: 20, trailing: 20, bottom: 20)
        }
        .build()
    }
}

extension ItemBadgeSupplementaryViewController {
    private func configureHierarchy() {
        let itemNib = NSNib(nibNamed: "TextItem", bundle: nil)
        collectionView.register(itemNib, forItemWithIdentifier: TextItem.reuseIdentifier)

        let badgeSupplementaryNib = NSNib(nibNamed: "BadgeSupplementaryView", bundle: nil)
        collectionView.register(badgeSupplementaryNib,
                    forSupplementaryViewOfKind: ItemBadgeSupplementaryViewController.badgeElementKind,
                    withIdentifier: ItemBadgeSupplementaryViewController.badgeSupplementaryViewReuseIdentifier)

        collectionView.collectionViewLayout = createLayout()
        collectionView.isSelectable = true
    }

    func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<Sections, Model>(collectionView: collectionView, itemProvider: {
            (collectionView: NSCollectionView, indexPath: IndexPath, model: Model) -> NSCollectionViewItem? in
            let item = collectionView.makeItem(withIdentifier: TextItem.reuseIdentifier, for: indexPath)
            item.textField?.stringValue = model.title
            if let box = item.view as? NSBox {
                box.cornerRadius = 8
            }
            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 2, height: -2)
            shadow.shadowBlurRadius = 2
            item.view.shadow = shadow
            return item
        })
        
        dataSource.supplementaryViewProvider = {
            (collectionView: NSCollectionView, kind: String, indexPath: IndexPath) -> (NSView & NSCollectionViewElement)? in
            guard let model = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
            let hasBadgeCount = model.badgeCount > 0
            if let badgeView = collectionView.makeSupplementaryView(
                ofKind: kind,
                withIdentifier: ItemBadgeSupplementaryViewController.badgeSupplementaryViewReuseIdentifier,
                for: indexPath) as? BadgeView {
                if let label = badgeView.contentView?.subviews.first as? NSTextField {
                    label.stringValue = "\(model.badgeCount)"
                }
                badgeView.isHidden = !hasBadgeCount
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Model>()
        snapshot.appendSections([.main])
        let models = (0..<100).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
