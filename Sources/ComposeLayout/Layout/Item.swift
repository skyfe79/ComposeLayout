//
//  Item.swift
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

/// A protocol that defines the requirements for an item in a compositional layout.
///
/// This protocol ensures that any conforming type can be converted into an `NSCollectionLayoutItem` and specifies the necessary properties for layout configuration.
public protocol ComposeLayoutItem: NSCollectionLayoutItemConvertible {
  /// The width dimension of the item.
  var width: NSCollectionLayoutDimension { get set }
  /// The height dimension of the item.
  var height: NSCollectionLayoutDimension { get set }
  /// An array of supplementary items associated with the item.
  var supplementaryItems: [SupplementaryItem] { get set }
  /// The content insets applied to the item.
  var contentInsets: NSDirectionalEdgeInsets { get set }
  /// The edge spacing for the item, if any.
  var edgeSpacing: NSCollectionLayoutEdgeSpacing? { get set }
  /// The calculated size of the item, derived from its width and height dimensions.
  var size: NSCollectionLayoutSize { get }
}


public extension ComposeLayoutItem {
  /// Computes the `NSCollectionLayoutSize` of the item based on its width and height dimensions.
  var size: NSCollectionLayoutSize {
    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
  }
}

/// A structure that represents an item in a compositional layout.
///
/// This structure conforms to the `ComposeLayoutItem` protocol, allowing it to be used within a compositional layout. It defines the basic properties required for layout configuration, such as dimensions, supplementary items, content insets, and edge spacing.
public struct Item: ComposeLayoutItem {
  /// The width dimension of the item. It can be a fractional width of the container or an absolute value.
  public var width: NSCollectionLayoutDimension
  /// The height dimension of the item. It can be a fractional height of the container or an absolute value.
  public var height: NSCollectionLayoutDimension
  /// An array of supplementary items associated with this item. Supplementary items can represent headers, footers, or other decorative elements.
  public var supplementaryItems: [SupplementaryItem] = []
  /// The content insets applied to the item. This defines the spacing around the item within its container.
  public var contentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
  /// The edge spacing for the item. This can be used to specify spacing on one or more sides of the item, potentially overriding the container's default spacing.
  public var edgeSpacing: NSCollectionLayoutEdgeSpacing?

  /// Initializes a new item with specified width and height dimensions.
  ///
  /// - Parameters:
  ///   - width: The width dimension for the item. Defaults to a fractional width of 1.0, meaning it will try to fill the available width of its container.
  ///   - height: The height dimension for the item. Defaults to a fractional height of 1.0, meaning it will try to fill the available height of its container.
  public init(width: NSCollectionLayoutDimension = .fractionalWidth(1.0), height: NSCollectionLayoutDimension = .fractionalHeight(1.0)) {
    self.width = width
    self.height = height
  }
}

// MARK: - toNSCollectionLayoutItem

public extension Item {
  /// Converts the `Item` instance into an `NSCollectionLayoutItem`.
  ///
  /// This method creates an `NSCollectionLayoutItem` using the `Item`'s properties such as `size`, `supplementaryItems`, `contentInsets`, and `edgeSpacing`. The `supplementaryItems` are converted using their `toNSCollectionLayoutSupplementaryItem` method.
  ///
  /// - Returns: An `NSCollectionLayoutItem` configured with the `Item`'s properties.
  func toNSCollectionLayoutItem() -> NSCollectionLayoutItem {
    let layoutItem = NSCollectionLayoutItem(layoutSize: size, supplementaryItems: supplementaryItems.compactMap { $0.toNSCollectionLayoutSupplementaryItem() })
    layoutItem.contentInsets = contentInsets
    layoutItem.edgeSpacing = edgeSpacing
    return layoutItem
  }
}

// MARK: - size

public extension Item {
  /// Sets the width dimension of the item.
  /// - Parameter value: The new width dimension for the item.
  /// - Returns: An item with the updated width dimension.
  func width(_ value: NSCollectionLayoutDimension) -> Item {
    return mutable(self) { $0.width = value }
  }

  /// Sets the height dimension of the item.
  /// - Parameter value: The new height dimension for the item.
  /// - Returns: An item with the updated height dimension.
  func height(_ value: NSCollectionLayoutDimension) -> Item {
    return mutable(self) { $0.height = value }
  }

  /// Sets both the width and height dimensions of the item.
  /// - Parameter value: The new size for the item, containing both width and height dimensions.
  /// - Returns: An item with the updated dimensions.
  func size(_ value: NSCollectionLayoutSize) -> Item {
    return mutable(self) {
      $0.width = value.widthDimension
      $0.height = value.heightDimension
    }
  }
}

// MARK: - contentInsets

public extension Item {
  /// Sets the content insets for the item.
  ///
  /// - Parameter insets: The content insets to be applied to the item.
  /// - Returns: An item with the updated content insets.
  func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Item {
    return mutable(self) {
      $0.contentInsets = insets
    }
  }

  /// Sets the content insets for the item with individual values for each edge.
  ///
  /// - Parameters:
  ///   - leading: The leading edge inset. Defaults to `0.0`.
  ///   - top: The top edge inset. Defaults to `0.0`.
  ///   - trailing: The trailing edge inset. Defaults to `0.0`.
  ///   - bottom: The bottom edge inset. Defaults to `0.0`.
  /// - Returns: An item with the updated content insets.
  func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Item {
    return mutable(self) {
      let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
      $0.contentInsets = newInsets
    }
  }
}

// MARK: - edgeSpacing

public extension Item {
  /// Applies edge spacing to the item.
  ///
  /// - Parameter spacing: The edge spacing to apply.
  /// - Returns: The item with the updated edge spacing.
  func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> Item {
    return mutable(self) {
      $0.edgeSpacing = spacing
    }
  }

  /// Applies edge spacing to the item with individual values for each edge.
  ///
  /// - Parameters:
  ///   - leading: The leading edge spacing, or `nil` for no change.
  ///   - top: The top edge spacing, or `nil` for no change.
  ///   - trailing: The trailing edge spacing, or `nil` for no change.
  ///   - bottom: The bottom edge spacing, or `nil` for no change.
  /// - Returns: The item with the updated edge spacing.
  func edgeSpacing(leading: NSCollectionLayoutSpacing? = nil, top: NSCollectionLayoutSpacing? = nil, trailing: NSCollectionLayoutSpacing? = nil, bottom: NSCollectionLayoutSpacing? = nil) -> Item {
    return mutable(self) {
      let newEdgeSpacing = NSCollectionLayoutEdgeSpacing(leading: leading, top: top, trailing: trailing, bottom: bottom)
      $0.edgeSpacing = newEdgeSpacing
    }
  }
}

// MARK: - supplementaryItems

public extension Item {
  /// Adds supplementary items to the item using a builder closure.
  ///
  /// This method allows for the dynamic addition of supplementary items to an item. The supplementary items are constructed using the provided builder closure.
  ///
  /// - Parameter items: A closure that returns an array of `SupplementaryItem` to be added to the item.
  /// - Returns: The item with the added supplementary items.
  func supplementaryItems(@SupplementaryItemBuilder items: () -> [SupplementaryItem]) -> Item {
    return mutable(self) { $0.supplementaryItems.append(contentsOf: items()) }
  }
}
