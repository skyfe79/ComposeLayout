//
//  Group.swift
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

/// A protocol defining the requirements for a layout group in a compositional layout.
///
/// A `ComposeLayoutGroup` is an item that can contain multiple subitems and can convert itself into a collection layout group or items.
public protocol ComposeLayoutGroup: ComposeLayoutItem, NSCollectionLayoutItemsConvertible, NSCollectionLayoutGroupConvertible {
  /// The number of times the group's items should be repeated.
  var repeatItemsCount: Int { get }
  /// The subitems contained within the group.
  var subitems: [NSCollectionLayoutItem] { get }
  /// The spacing between items within the group.
  var interItemSpacing: NSCollectionLayoutSpacing? { get set }
}

/// A protocol defining the requirements for creating layout groups using a builder pattern.
public protocol Group: ComposeLayoutGroup {
  /// Initializes a new group with the provided subitems.
  /// - Parameter items: A closure that returns an array of `NSCollectionLayoutItem` to be used as subitems.
  init(@GroupBuilder items: () -> [NSCollectionLayoutItem])

  /// Initializes a new group with the provided subitems, repeating them a specified number of times.
  /// - Parameters:
  ///   - repeatItems: The number of times to repeat the provided items within the group.
  ///   - items: A closure that returns an array of `NSCollectionLayoutItem` to be used as subitems.
  init(repeatItems: Int, @GroupBuilder items: () -> [NSCollectionLayoutItem])
}

// MARK: - NSCollectionLayoutItemsConvertible

public extension Group {
  /// Converts the group's subitems into an array of `NSCollectionLayoutItem`.
  func toNSCollectionLayoutItems() -> [NSCollectionLayoutItem] {
    return subitems
  }

  /// Converts the group into a single `NSCollectionLayoutItem`.
  func toNSCollectionLayoutItem() -> NSCollectionLayoutItem {
    return toNSCollectionLayoutGroup()
  }
}

public extension Group {
  /// Sets the spacing between items within the group.
  /// - Parameter spacing: The spacing to be applied between items.
  /// - Returns: The group with the updated inter-item spacing.
  func interItemSpacing(_ spacing: NSCollectionLayoutSpacing) -> Group {
    return mutable(self) { $0.interItemSpacing = spacing }
  }
}

// MARK: - Size

public extension Group {
  /// Sets the width of the group.
  /// - Parameter value: The width dimension for the group.
  /// - Returns: The group with the updated width.
  func width(_ value: NSCollectionLayoutDimension) -> Group {
    return mutable(self) { $0.width = value }
  }

  /// Sets the height of the group.
  /// - Parameter value: The height dimension for the group.
  /// - Returns: The group with the updated height.
  func height(_ value: NSCollectionLayoutDimension) -> Group {
    return mutable(self) { $0.height = value }
  }

  /// The size of the group, derived from its width and height dimensions.
  var size: NSCollectionLayoutSize {
    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
  }

  /// Sets the size of the group.
  /// - Parameter value: The size for the group.
  /// - Returns: The group with the updated size.
  func size(_ value: NSCollectionLayoutSize) -> Group {
    return mutable(self) {
      $0.width = value.widthDimension
      $0.height = value.heightDimension
    }
  }
}

// MARK: - Content Insets

public extension Group {
  /// Sets the content insets for the group.
  /// - Parameter insets: The directional edge insets for the group.
  /// - Returns: The group with the updated content insets.
  func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Group {
    return mutable(self) {
      $0.contentInsets = insets
    }
  }

  /// Sets the content insets for the group with individual values.
  /// - Parameters:
  ///   - leading: The leading inset.
  ///   - top: The top inset.
  ///   - trailing: The trailing inset.
  ///   - bottom: The bottom inset.
  /// - Returns: The group with the updated content insets.
  func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Group {
    return mutable(self) {
      let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
      $0.contentInsets = newInsets
    }
  }
}

// MARK: - Edge Spacing

public extension Group {
  /// Sets the edge spacing for the group.
  /// - Parameter spacing: The edge spacing for the group.
  /// - Returns: The group with the updated edge spacing.
  func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> Group {
    return mutable(self) {
      $0.edgeSpacing = spacing
    }
  }

  /// Sets the edge spacing for the group with individual values.
  /// - Parameters:
  ///   - leading: The leading spacing.
  ///   - top: The top spacing.
  ///   - trailing: The trailing spacing.
  ///   - bottom: The bottom spacing.
  /// - Returns: The group with the updated edge spacing.
  func edgeSpacing(leading: NSCollectionLayoutSpacing? = nil, top: NSCollectionLayoutSpacing? = nil, trailing: NSCollectionLayoutSpacing? = nil, bottom: NSCollectionLayoutSpacing? = nil) -> Group {
    return mutable(self) {
      let newEdgeSpacing = NSCollectionLayoutEdgeSpacing(leading: leading, top: top, trailing: trailing, bottom: bottom)
      $0.edgeSpacing = newEdgeSpacing
    }
  }
}

// MARK: - Supplementary Items

public extension Group {
  /// Adds supplementary items to the group.
  /// - Parameter items: A closure that returns an array of `SupplementaryItem` to be added to the group.
  /// - Returns: The group with the added supplementary items.
  func supplementaryItems(@SupplementaryItemBuilder items: () -> [SupplementaryItem]) -> Group {
    return mutable(self) { $0.supplementaryItems.append(contentsOf: items()) }
  }
}
