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

public protocol ComposeLayoutGroup: ComposeLayoutItem, NSCollectionLayoutItemsConvertible, NSCollectionLayoutGroupConvertible {
    var subitems: [NSCollectionLayoutItem] { get }
    var interItemSpacing: NSCollectionLayoutSpacing? { get set }
}

public protocol Group: ComposeLayoutGroup {
}

// MARK: - NSCollectionLayoutItemsConvertible
extension Group {
    public func toNSCollectionLayoutItems() -> [NSCollectionLayoutItem] {
        return subitems
    }
    
    public func toNSCollectionLayoutItem() -> NSCollectionLayoutItem {
        return toNSCollectionLayoutGroup()
    }
}

extension Group {
    public func interItemSpacing(_ spacing: NSCollectionLayoutSpacing) -> Group {
        return mutable(self) { $0.interItemSpacing = spacing }
    }
}

// MARK: - size
extension Group {
    public func width(_ value: NSCollectionLayoutDimension) -> Group {
        return mutable(self) { $0.width = value }
    }
    
    public func height(_ value: NSCollectionLayoutDimension) -> Group {
        return mutable(self) { $0.height = value }
    }
    
    public var size: NSCollectionLayoutSize {
        NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    }
    
    public func size(_ value: NSCollectionLayoutSize) -> Group {
        return mutable(self) {
            $0.width = value.widthDimension
            $0.height = value.heightDimension
        }
    }
}

// MARK: - contentInsets
extension Group {
    public func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Group {
        return mutable(self) {
            $0.contentInsets = insets
        }
    }
    
    public func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Group {
        return mutable(self) {
            let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
            $0.contentInsets = newInsets
        }
    }
}

// MARK: - edgeSpacing
extension Group {
    public func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> Group {
        return mutable(self) {
            $0.edgeSpacing = spacing
        }
    }
    
    public func edgeSpacing(leading: NSCollectionLayoutSpacing? = nil, top: NSCollectionLayoutSpacing? = nil, trailing: NSCollectionLayoutSpacing? = nil, bottom: NSCollectionLayoutSpacing? = nil) -> Group {
        return mutable(self) {
            let newEdgeSpacing = NSCollectionLayoutEdgeSpacing(leading: leading, top: top, trailing: trailing, bottom: bottom)
            $0.edgeSpacing = newEdgeSpacing
        }
    }
}

// MARK: - supplementaryItems
extension Group {
    public func supplementaryItems(@SupplementaryItemBuilder items: () -> [SupplementaryItem]) -> Group {
        return mutable(self) { $0.supplementaryItems.append(contentsOf: items()) }
    }
}
