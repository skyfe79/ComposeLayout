//
//  DecorationItem.swift
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

/// A structure that defines the properties of a decoration item in a collection view layout.
///
/// This structure is used to configure the appearance and placement of a decoration item within a collection view layout.
public struct DecorationItem {
  /// The kind of the element, typically used to distinguish between different types of decoration items.
  public var elementKind: String
  /// The content insets for the decoration item.
  public var contentInsets: NSDirectionalEdgeInsets?
  /// The edge spacing for the decoration item.
  public var edgeSpacing: NSCollectionLayoutEdgeSpacing?
  /// The z-index of the decoration item, used to control its stacking order.
  public var zIndex: Int?

  /// Initializes a new decoration item with the specified element kind.
  ///
  /// - Parameter elementKind: The kind of the element for the decoration item.
  public init(elementKind: String) {
    self.elementKind = elementKind
  }

  /// Converts `DecorationItem` to `NSCollectionLayoutDecorationItem`.
  ///
  /// This method creates an instance of `NSCollectionLayoutDecorationItem` using the properties defined in `DecorationItem`.
  ///
  /// - Returns: An instance of `NSCollectionLayoutDecorationItem` configured with the properties of `DecorationItem`.
  public func toNSCollectionLayoutDecorationItem() -> NSCollectionLayoutDecorationItem {
    let item = NSCollectionLayoutDecorationItem.background(elementKind: elementKind)

    if let contentInsets = contentInsets {
      item.contentInsets = contentInsets
    }

    if let edgeSpacing = edgeSpacing {
      item.edgeSpacing = edgeSpacing
    }

    if let zIndex = zIndex {
      item.zIndex = zIndex
    }

    return item
  }

  /// Sets the z-index of the decoration item.
  ///
  /// - Parameter value: An integer value representing the z-index.
  /// - Returns: A `DecorationItem` instance with the updated z-index.
  public func zIndex(_ value: Int) -> DecorationItem {
    return mutable(self) { $0.zIndex = value }
  }
}

// MARK: - contentInsets

public extension DecorationItem {
  /// Sets the content insets for the decoration item.
  ///
  /// - Parameter insets: The content insets for the decoration item.
  /// - Returns: A `DecorationItem` instance with the updated content insets.
  func contentInsets(_ insets: NSDirectionalEdgeInsets) -> DecorationItem {
    return mutable(self) {
      $0.contentInsets = insets
    }
  }

  /// Sets the content insets for the decoration item with individual values.
  ///
  /// - Parameters:
  ///   - leading: The leading inset.
  ///   - top: The top inset.
  ///   - trailing: The trailing inset.
  ///   - bottom: The bottom inset.
  /// - Returns: A `DecorationItem` instance with the updated content insets.
  func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> DecorationItem {
    return mutable(self) {
      let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
      $0.contentInsets = newInsets
    }
  }
}

// MARK: - edgeSpacing

public extension DecorationItem {
  /// Sets the edge spacing for the decoration item.
  ///
  /// - Parameter spacing: The edge spacing for the decoration item.
  /// - Returns: A `DecorationItem` instance with the updated edge spacing.
  func edgeSpacing(_ spacing: NSCollectionLayoutEdgeSpacing) -> DecorationItem {
    return mutable(self) {
      $0.edgeSpacing = spacing
    }
  }

  /// Sets the edge spacing for the decoration item with individual values.
  ///
  /// - Parameters:
  ///   - leading: The leading spacing.
  ///   - top: The top spacing.
  ///   - trailing: The trailing spacing.
  ///   - bottom: The bottom spacing.
  /// - Returns: A `DecorationItem` instance with the updated edge spacing.
  func edgeSpacing(leading: NSCollectionLayoutSpacing? = nil, top: NSCollectionLayoutSpacing? = nil, trailing: NSCollectionLayoutSpacing? = nil, bottom: NSCollectionLayoutSpacing? = nil) -> DecorationItem {
    return mutable(self) {
      let newEdgeSpacing = NSCollectionLayoutEdgeSpacing(leading: leading, top: top, trailing: trailing, bottom: bottom)
      $0.edgeSpacing = newEdgeSpacing
    }
  }
}
