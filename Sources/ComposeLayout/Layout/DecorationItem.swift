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

public struct DecorationItem {
    public var elementKind: String
    public var contentInsets: NSDirectionalEdgeInsets?
    public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
    public var zIndex: Int?
    
    public init(elementKind: String) {
        self.elementKind = elementKind
    }
            
    public func toNSCollectionLayoutDecorationItem() -> NSCollectionLayoutDecorationItem {
        let item = NSCollectionLayoutDecorationItem.background(elementKind: elementKind)
        
        if let contentInsets {
            item.contentInsets = contentInsets
        }
        
        if let edgeSpacing {
            item.edgeSpacing = edgeSpacing
        }
        
        if let zIndex {
            item.zIndex = zIndex
        }
        
        return item
    }
    
    public func zIndex(_ value: Int) -> DecorationItem {
        return mutable(self) { $0.zIndex = value }
    }
}

// MARK: - contentInsets
extension DecorationItem {
    public func contentInsets(_ insets: NSDirectionalEdgeInsets) -> DecorationItem {
        return mutable(self) {
            $0.contentInsets = insets
        }
    }
    
    public func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> DecorationItem {
        return mutable(self) {
            let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
            $0.contentInsets = newInsets
        }
    }
}

// MARK: - edgeSpacing
extension DecorationItem {
    public func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> DecorationItem {
        return mutable(self) {
            $0.edgeSpacing = spacing
        }
    }
    
    public func edgeSpacing(leading: NSCollectionLayoutSpacing? = nil, top: NSCollectionLayoutSpacing? = nil, trailing: NSCollectionLayoutSpacing? = nil, bottom: NSCollectionLayoutSpacing? = nil) -> DecorationItem {
        return mutable(self) {
            let newEdgeSpacing = NSCollectionLayoutEdgeSpacing(leading: leading, top: top, trailing: trailing, bottom: bottom)
            $0.edgeSpacing = newEdgeSpacing
        }
    }
}
