//
//  VGroup.swift
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

/// A structure that represents a vertical group in a compositional layout.
///
/// `VGroup` is used to create a vertical group of items in a compositional layout. It supports repeating items, customizing dimensions, and adding supplementary items.
public struct VGroup: Group {
  /// The number of times the items should be repeated in the group.
  public private(set) var repeatItemsCount: Int
  /// The items that make up the group.
  public private(set) var subitems: [NSCollectionLayoutItem] = []
  /// The width of the group, specified as a layout dimension.
  public var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
  /// The height of the group, specified as a layout dimension.
  public var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
  /// Supplementary items associated with the group, such as headers or footers.
  public var supplementaryItems: [SupplementaryItem] = []
  /// The content insets applied to the group.
  public var contentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
  /// The edge spacing for the group, if any.
  public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
  /// The spacing between items within the group.
  public var interItemSpacing: NSCollectionLayoutSpacing?

  /// Initializes a new group with the specified number of repeating items and a builder for the items.
  ///
  /// - Parameters:
  ///   - repeatItems: The number of times to repeat the items in the group.
  ///   - items: A closure that returns an array of `NSCollectionLayoutItem` to be included in the group.
  public init(repeatItems: Int, @GroupBuilder items: () -> [NSCollectionLayoutItem]) {
    repeatItemsCount = repeatItems
    subitems = items()
  }

  /// Initializes a new group with a builder for the items.
  ///
  /// This initializer sets the `repeatItemsCount` to `0`, indicating that the items should not be repeated.
  ///
  /// - Parameter items: A closure that returns an array of `NSCollectionLayoutItem` to be included in the group.
  public init(@GroupBuilder items: () -> [NSCollectionLayoutItem]) {
    self.init(repeatItems: 0, items: items)
  }
}

public extension VGroup {
  /// Converts `VGroup` to `NSCollectionLayoutGroup`.
  ///
  /// This method constructs an `NSCollectionLayoutGroup` based on the properties of `VGroup`. If `repeatItemsCount` is greater than 0 and there is at least one item, it creates a vertical group with the first item repeated `repeatItemsCount` times. Otherwise, it creates a vertical group with all subitems. It also configures the group's edge spacing, inter-item spacing, content insets, and supplementary items.
  ///
  /// - Returns: An `NSCollectionLayoutGroup` configured with properties from `VGroup`.
  func toNSCollectionLayoutGroup() -> NSCollectionLayoutGroup {
    let group: NSCollectionLayoutGroup
    if repeatItemsCount > 0 {
      if let firstItem = toNSCollectionLayoutItems().first {
        group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: firstItem, count: repeatItemsCount)
      } else {
        group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: toNSCollectionLayoutItems())
      }
    } else {
      group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: toNSCollectionLayoutItems())
    }
    group.edgeSpacing = edgeSpacing
    group.interItemSpacing = interItemSpacing
    group.contentInsets = contentInsets
    group.supplementaryItems = supplementaryItems.compactMap { $0.toNSCollectionLayoutSupplementaryItem() }
    return group
  }
}
