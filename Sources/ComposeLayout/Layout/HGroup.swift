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

public struct HGroup: Group {
    public var subitems: [NSCollectionLayoutItem] = []
    public var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
    public var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
    public var supplementaryItems: [SupplementaryItem] = []
    public var contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
    public var interItemSpacing: NSCollectionLayoutSpacing?
    
    public init(@GroupBuilder items: () -> [NSCollectionLayoutItem]) {
        self.subitems = items()
    }
}

extension HGroup {
    public func toNSCollectionLayoutGroup() -> NSCollectionLayoutGroup {
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: toNSCollectionLayoutItems())
        group.edgeSpacing = edgeSpacing
        group.interItemSpacing = interItemSpacing
        group.contentInsets = contentInsets
        group.supplementaryItems = supplementaryItems.compactMap { $0.toNSCollectionLayoutSupplementaryItem() }
        return group
    }
}
