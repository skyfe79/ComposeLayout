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

public struct VGroup: Group {
    public private(set) var repeatItemsCount: Int
    public private(set) var subitems: [NSCollectionLayoutItem] = []
    public var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
    public var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
    public var supplementaryItems: [SupplementaryItem] = []
    public var contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
    public var interItemSpacing: NSCollectionLayoutSpacing?
    
    public init(repeatItems: Int, items: () -> [NSCollectionLayoutItem]) {
        self.repeatItemsCount = repeatItems
        self.subitems = items()
    }
    
    public init(@GroupBuilder items: () -> [NSCollectionLayoutItem]) {
        self.init(repeatItems: 0, items: items)
    }
}

extension VGroup {
    public func toNSCollectionLayoutGroup() -> NSCollectionLayoutGroup {
        let group = if repeatItemsCount > 0 {
            if let firstItem = toNSCollectionLayoutItems().first {
                NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: firstItem, count: repeatItemsCount)
            } else {
                NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: toNSCollectionLayoutItems())
            }
        } else {
            NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: toNSCollectionLayoutItems())
        }
        group.edgeSpacing = edgeSpacing
        group.interItemSpacing = interItemSpacing
        group.contentInsets = contentInsets
        group.supplementaryItems = supplementaryItems.compactMap { $0.toNSCollectionLayoutSupplementaryItem() }
        return group
    }
}
