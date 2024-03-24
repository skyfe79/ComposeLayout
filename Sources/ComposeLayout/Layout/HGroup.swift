//
//  HGroup.swift
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

/// A structure representing a horizontal group in a compositional layout.
public struct HGroup: Group {
  /// The number of times the items in the group are repeated.
  public private(set) var repeatItemsCount: Int
  /// The collection of subitems within the group.
  public private(set) var subitems: [NSCollectionLayoutItem] = []
  /// The width dimension of the group.
  public var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
  /// The height dimension of the group.
  public var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
  /// The supplementary items associated with the group.
  public var supplementaryItems: [SupplementaryItem] = []
  /// The content insets applied to the group.
  public var contentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
  /// The edge spacing applied to the group.
  public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
  /// The spacing between items within the group.
  public var interItemSpacing: NSCollectionLayoutSpacing?

  /// Initializes a new horizontal group with the specified number of repeated items.
  /// - Parameters:
  ///   - repeatItems: The number of times the items should be repeated.
  ///   - items: A closure that returns an array of `NSCollectionLayoutItem`.
  public init(repeatItems: Int, @GroupBuilder items: () -> [NSCollectionLayoutItem]) {
    self.repeatItemsCount = repeatItems
    self.subitems = items()
  }

  /// Initializes a new horizontal group.
  /// - Parameter items: A closure that returns an array of `NSCollectionLayoutItem`.
  public init(@GroupBuilder items: () -> [NSCollectionLayoutItem]) {
    self.init(repeatItems: 0, items: items)
  }
}

public extension HGroup {
  /// Converts the horizontal group into an `NSCollectionLayoutGroup`.
  /// - Returns: An `NSCollectionLayoutGroup` configured based on the horizontal group's properties.
  func toNSCollectionLayoutGroup() -> NSCollectionLayoutGroup {
    let group:NSCollectionLayoutGroup
    if repeatItemsCount > 0 {
      if let firstItem = toNSCollectionLayoutItems().first {
        group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: firstItem, count: repeatItemsCount)
      } else {
        group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: toNSCollectionLayoutItems())
      }
    } else {
      group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: toNSCollectionLayoutItems())
    }
    group.edgeSpacing = edgeSpacing
    group.interItemSpacing = interItemSpacing
    group.contentInsets = contentInsets
    group.supplementaryItems = supplementaryItems.compactMap { $0.toNSCollectionLayoutSupplementaryItem() }
    return group
  }
}
