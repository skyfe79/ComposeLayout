//
//  BoundarySupplementaryItem.swift
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

/// A structure that defines the properties of a boundary supplementary item in a collection view layout.
///
/// This structure is used to configure the dimensions, alignment, and other properties of a boundary supplementary item.
public struct BoundarySupplementaryItem {
  /// The width of the boundary supplementary item, specified as a fraction of the width of the containing group.
  private var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
  /// The height of the boundary supplementary item, specified as a fraction of the height of the containing group.
  private var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
  /// The kind of the element, typically used to distinguish between different types of supplementary items.
  private var elementKind: String = ElementKind.unknown
  /// A Boolean value that determines whether the supplementary item is pinned to the visible bounds of the collection view.
  private var pinToVisibleBounds: Bool?
  /// A Boolean value that determines whether the supplementary item extends beyond the boundary edges of the section.
  private var extendsBoundary: Bool?
  /// The alignment of the supplementary item within its container.
  private var alignment: NSRectAlignment = .none
  /// The absolute offset of the supplementary item from its default position.
  private var absoluteOffset: CGPoint?
  /// The z-index of the supplementary item, used to control its stacking order.
  private var zIndex: Int?

  /// The size of the boundary supplementary item, derived from its width and height dimensions.
  private var size: NSCollectionLayoutSize {
    NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
  }

  /// Initializes a new boundary supplementary item with the specified element kind.
  ///
  /// - Parameter elementKind: The kind of the element for the supplementary item.
  public init(elementKind: String) {
    self.elementKind = elementKind
  }
}

// MARK: - toNSCollectionLayoutSupplementaryItem

extension BoundarySupplementaryItem: NSCollectionLayoutBoundarySupplementaryItemConvertible {
  /// Converts `BoundarySupplementaryItem` to `NSCollectionLayoutBoundarySupplementaryItem`.
  ///
  /// This method creates an instance of `NSCollectionLayoutBoundarySupplementaryItem` using the properties defined in `BoundarySupplementaryItem`. It supports conditional creation based on whether an absolute offset is provided. Additionally, it configures the item with optional properties such as `pinToVisibleBounds`, `extendsBoundary`, and `zIndex` if they are set.
  ///
  /// - Returns: An instance of `NSCollectionLayoutBoundarySupplementaryItem` configured with the properties of `BoundarySupplementaryItem`.
  public func toNSCollectionLayoutBoundarySupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    let item: NSCollectionLayoutBoundarySupplementaryItem 
    if let absoluteOffset = absoluteOffset {
      item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: elementKind, alignment: alignment, absoluteOffset: absoluteOffset)
    } else {
      item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: elementKind, alignment: alignment)
    }

    if let pinToVisibleBounds = pinToVisibleBounds {
      item.pinToVisibleBounds = pinToVisibleBounds
    }

    if let extendsBoundary = extendsBoundary {
      item.extendsBoundary = extendsBoundary
    }

    if let zIndex = zIndex {
      item.zIndex = zIndex
    }

    return item
  }
}

// MARK: - size

public extension BoundarySupplementaryItem {
  /// Sets the width of the boundary supplementary item.
  ///
  /// - Parameter value: The width dimension for the boundary supplementary item.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated width.
  func width(_ value: NSCollectionLayoutDimension) -> BoundarySupplementaryItem {
    return mutable(self) { $0.width = value }
  }

  /// Sets the height of the boundary supplementary item.
  ///
  /// - Parameter value: The height dimension for the boundary supplementary item.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated height.
  func height(_ value: NSCollectionLayoutDimension) -> BoundarySupplementaryItem {
    return mutable(self) { $0.height = value }
  }

  /// Sets the size of the boundary supplementary item.
  ///
  /// - Parameter value: The size for the boundary supplementary item.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated size.
  func size(_ value: NSCollectionLayoutSize) -> BoundarySupplementaryItem {
    return mutable(self) {
      $0.width = value.widthDimension
      $0.height = value.heightDimension
    }
  }
}

// MARK: - Specifying scrolling behavior

public extension BoundarySupplementaryItem {
  /// Pins the boundary supplementary item to the visible bounds.
  ///
  /// Use this method to pin the boundary supplementary item to the visible bounds of the collection view.
  ///
  /// - Parameter value: A Boolean value indicating whether the boundary supplementary item should be pinned to the visible bounds.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated pinning behavior.
  func pinToVisibleBounds(_ value: Bool) -> BoundarySupplementaryItem {
    return mutable(self) { $0.pinToVisibleBounds = value }
  }
}

// MARK: - Specifying position

public extension BoundarySupplementaryItem {
  /// Extends the boundary of the supplementary item.
  ///
  /// Use this method to specify whether the boundary supplementary item should extend beyond the default boundaries of the collection view.
  ///
  /// - Parameter value: A Boolean value indicating whether the boundary supplementary item should extend its boundary.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated boundary extension behavior.
  func extendsBoundary(_ value: Bool) -> BoundarySupplementaryItem {
    return mutable(self) { $0.extendsBoundary = value }
  }
}

// MARK: - Specifying stacking order

public extension BoundarySupplementaryItem {
  /// Sets the stacking order of the boundary supplementary item.
  ///
  /// Use this method to set the stacking order of the boundary supplementary item. Items with higher zIndex values appear in front of items with lower zIndex values.
  ///
  /// - Parameter value: An integer value representing the stacking order.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated stacking order.
  func zIndex(_ value: Int) -> BoundarySupplementaryItem {
    return mutable(self) { $0.zIndex = value }
  }
}

// MARK: - alignment, offset

public extension BoundarySupplementaryItem {
  /// Sets the alignment of the boundary supplementary item.
  ///
  /// Use this method to set the alignment of the boundary supplementary item within its container.
  ///
  /// - Parameter value: An `NSRectAlignment` value that determines the alignment.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated alignment.
  func alignment(_ value: NSRectAlignment) -> BoundarySupplementaryItem {
    return mutable(self) { $0.alignment = value }
  }

  /// Sets the absolute offset of the boundary supplementary item.
  ///
  /// Use this method to set the absolute offset of the boundary supplementary item from its original position.
  ///
  /// - Parameter value: A `CGPoint` value that determines the offset.
  /// - Returns: A `BoundarySupplementaryItem` instance with the updated offset.
  func absoluteOffset(_ value: CGPoint) -> BoundarySupplementaryItem {
    return mutable(self) { $0.absoluteOffset = value }
  }
}
