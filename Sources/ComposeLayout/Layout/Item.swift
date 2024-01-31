//
//  File.swift
//  
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

#if os(iOS)
import UIKit
#else
import AppKit
#endif


public protocol ComposeLayoutItem: NSCollectionLayoutItemConvertible {
    var width: NSCollectionLayoutDimension { get set }
    var height: NSCollectionLayoutDimension { get set }
    var supplementaryItems: [SupplementaryItem] { get set }
    var contentInsets: NSDirectionalEdgeInsets { get set }
    var edgeSpacing: NSCollectionLayoutEdgeSpacing? { get set }
    var size: NSCollectionLayoutSize { get }
}

extension ComposeLayoutItem {
    public var size: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    }
}

public struct Item: ComposeLayoutItem {
    public var width: NSCollectionLayoutDimension
    public var height: NSCollectionLayoutDimension
    public var supplementaryItems: [SupplementaryItem] = []
    public var contentInsets: NSDirectionalEdgeInsets = .zero
    public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
    
    public init(width: NSCollectionLayoutDimension = .fractionalWidth(1.0), height: NSCollectionLayoutDimension = .fractionalHeight(1.0)) {
        self.width = width
        self.height = height
    }
}

// MARK: - toNSCollectionLayoutItem
extension Item {
    public func toNSCollectionLayoutItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: size, supplementaryItems: supplementaryItems.compactMap { $0.toNSCollectionLayoutSupplementaryItem() })
        item.contentInsets = contentInsets
        item.edgeSpacing = edgeSpacing
        return item
    }
}

// MARK: - size
extension Item {
    public func width(_ value: NSCollectionLayoutDimension) -> Item {
        return mutable(self) { $0.width = value }
    }
    
    public func height(_ value: NSCollectionLayoutDimension) -> Item {
        return mutable(self) { $0.height = value }
    }
    
    public func size(_ value: NSCollectionLayoutSize) -> Item {
        return mutable(self) {
            $0.width = value.widthDimension
            $0.height = value.heightDimension
        }
    }
}

// MARK: - contentInsets
extension Item {
    public func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Item {
        return mutable(self) {
            $0.contentInsets = insets
        }
    }
    
    public func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Item {
        return mutable(self) {
            let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
            $0.contentInsets = newInsets
        }
    }
}

// MARK: - edgeSpacing
extension Item {
    public func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> Item {
        return mutable(self) {
            $0.edgeSpacing = spacing
        }
    }
    
    public func edgeSpacing(leading: NSCollectionLayoutSpacing? = nil, top: NSCollectionLayoutSpacing? = nil, trailing: NSCollectionLayoutSpacing? = nil, bottom: NSCollectionLayoutSpacing? = nil) -> Item {
        return mutable(self) {
            let newEdgeSpacing = NSCollectionLayoutEdgeSpacing(leading: leading, top: top, trailing: trailing, bottom: bottom)
            $0.edgeSpacing = newEdgeSpacing
        }
    }
}


// MARK: - supplementaryItems
extension Item {
    public func supplementaryItems(@SupplementaryItemBuilder items: () -> [SupplementaryItem]) -> Item {
        return mutable(self) { $0.supplementaryItems.append(contentsOf: items()) }
    }
}
