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

public struct SupplementaryItem {
    public var elementKind: String
    public var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
    public var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
    public var containerAnchor: NSCollectionLayoutAnchor = .init(edges: [.top])
    public var itemAnchor: NSCollectionLayoutAnchor?

    public var size: NSCollectionLayoutSize {
        NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    }
    
    public init(elementKind: String) {
        self.elementKind = elementKind
    }
}

// MARK: - toNSCollectionLayoutSupplementaryItem
extension SupplementaryItem: NSCollectionLayoutSupplementaryItemConvertible {
    public func toNSCollectionLayoutSupplementaryItem() -> NSCollectionLayoutSupplementaryItem {
        return if let itemAnchor {
            NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
        } else {
            NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor)
        }
    }
}

// MARK: - Size
extension SupplementaryItem {
    public func width(_ value: NSCollectionLayoutDimension) -> SupplementaryItem {
        return mutable(self) { $0.width = value }
    }
    
    public func height(_ value: NSCollectionLayoutDimension) -> SupplementaryItem {
        return mutable(self) { $0.height = value }
    }
    
    public func size(_ value: NSCollectionLayoutSize) -> SupplementaryItem {
        return mutable(self) {
            $0.width = value.widthDimension
            $0.height = value.heightDimension
        }
    }
}

// MARK: - elementKind
extension SupplementaryItem {
    public func elementKind(_ kind: String) -> SupplementaryItem {
        return mutable(self) { $0.elementKind = kind }
    }
}

// MARK: - Container Anchor
extension SupplementaryItem {
    public func containerAnchor(_ anchor: NSCollectionLayoutAnchor) -> SupplementaryItem {
        return mutable(self) { $0.containerAnchor = anchor }
    }
    
    public func containerAnchor(edges: NSDirectionalRectEdge) -> SupplementaryItem {
        return mutable(self) { $0.containerAnchor = NSCollectionLayoutAnchor(edges: edges) }
    }
    
    public func containerAnchor(edges: NSDirectionalRectEdge, absoluteOffset: CGPoint) -> SupplementaryItem {
        return mutable(self) { $0.containerAnchor = NSCollectionLayoutAnchor(edges: edges, absoluteOffset: absoluteOffset) }
    }
    
    public func containerAnchor(edges: NSDirectionalRectEdge, fractionalOffset: CGPoint) -> SupplementaryItem {
        return mutable(self) { $0.containerAnchor = NSCollectionLayoutAnchor(edges: edges, fractionalOffset: fractionalOffset) }
    }
}

// MARK: - Item Anchor
extension SupplementaryItem {
    public func itemAnchor(_ anchor: NSCollectionLayoutAnchor) -> SupplementaryItem {
        return mutable(self) { $0.itemAnchor = anchor }
    }
    
    public func itemAnchor(edges: NSDirectionalRectEdge) -> SupplementaryItem {
        return mutable(self) { $0.itemAnchor = NSCollectionLayoutAnchor(edges: edges) }
    }
    
    public func itemAnchor(edges: NSDirectionalRectEdge, absoluteOffset: CGPoint) -> SupplementaryItem {
        return mutable(self) { $0.itemAnchor = NSCollectionLayoutAnchor(edges: edges, absoluteOffset: absoluteOffset) }
    }
    
    public func itemAnchor(edges: NSDirectionalRectEdge, fractionalOffset: CGPoint) -> SupplementaryItem {
        return mutable(self) { $0.itemAnchor = NSCollectionLayoutAnchor(edges: edges, fractionalOffset: fractionalOffset) }
    }
}
