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

public struct BoundarySupplementaryItem {
    private var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
    private var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
    private var elementKind: String = ElementKind.unknown
    private var pinToVisibleBounds: Bool = false
    private var extendsBoundary: Bool = false
    private var alignment: NSRectAlignment = .none
    private var absoluteOffset: CGPoint?
    private var zIndex: Int?
    
    private var size: NSCollectionLayoutSize {
        NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    }
    
    public init(elementKind: String) {
        self.elementKind = elementKind
    }
}

// MARK: - toNSCollectionLayoutSupplementaryItem
extension BoundarySupplementaryItem: NSCollectionLayoutBoundarySupplementaryItemConvertible {
    public func toNSCollectionLayoutBoundarySupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let item: NSCollectionLayoutBoundarySupplementaryItem = if let absoluteOffset {
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: elementKind, alignment: alignment, absoluteOffset: absoluteOffset)
        } else {
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: elementKind, alignment: alignment)
        }
        
        item.pinToVisibleBounds = pinToVisibleBounds
        item.extendsBoundary = extendsBoundary
        
        if let zIndex {
            item.zIndex = zIndex
        }
        
        return item
    }
}


// MARK: - size
extension BoundarySupplementaryItem {
    public func width(_ value: NSCollectionLayoutDimension) -> BoundarySupplementaryItem {
        return mutable(self) { $0.width = value }
    }
    
    public func height(_ value: NSCollectionLayoutDimension) -> BoundarySupplementaryItem {
        return mutable(self) { $0.height = value }
    }
    
    public func size(_ value: NSCollectionLayoutSize) -> BoundarySupplementaryItem {
        return mutable(self) {
            $0.width = value.widthDimension
            $0.height = value.heightDimension
        }
    }
}


// MARK: - Specifying scrolling behavior
extension BoundarySupplementaryItem {
    public func pinToVisibleBounds(_ value: Bool) -> BoundarySupplementaryItem {
        return mutable(self) { $0.pinToVisibleBounds = value }
    }
}

// MARK: - Specifying position
extension BoundarySupplementaryItem {
    public func extendsBoundary(_ value: Bool) -> BoundarySupplementaryItem {
        return mutable(self) { $0.extendsBoundary = value }
    }
}

// MARK: - Specifying stacking order
extension BoundarySupplementaryItem {
    public func zIndex(_ value: Int) -> BoundarySupplementaryItem {
        return mutable(self) { $0.zIndex = value }
    }
}

// MARK - alignment, offset
extension BoundarySupplementaryItem {
    public func alignment( _ value: NSRectAlignment) -> BoundarySupplementaryItem {
        return mutable(self) { $0.alignment = value }
    }
    
    public func absoluteOffset(_ value: CGPoint) -> BoundarySupplementaryItem {
        return mutable(self) { $0.absoluteOffset = value }
    }
}
