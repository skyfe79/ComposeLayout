//
//  SupplementaryItem.swift
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

/// A structure that represents a supplementary item in a compositional layout.
///
/// This structure is used to define supplementary items such as headers or footers within a compositional layout. It includes properties for specifying the item's dimensions, its anchoring within the container, and optionally, an anchor relative to another item.
public struct SupplementaryItem {
  /// The kind of element this supplementary item represents, such as a header or footer.
  public var elementKind: String
  /// The width of the supplementary item, specified as a layout dimension.
  public var width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
  /// The height of the supplementary item, specified as a layout dimension.
  public var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
  /// The anchor that defines how this item is positioned within its container.
  public var containerAnchor: NSCollectionLayoutAnchor = .init(edges: [.top])
  /// An optional anchor that defines how this item is positioned relative to another item.
  public var itemAnchor: NSCollectionLayoutAnchor?

  /// The size of the supplementary item, derived from its width and height dimensions.
  public var size: NSCollectionLayoutSize {
    NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
  }

  /// Initializes a new supplementary item with the specified element kind.
  ///
  /// - Parameter elementKind: A string that identifies the kind of element this supplementary item represents.
  public init(elementKind: String) {
    self.elementKind = elementKind
  }
}
// MARK: - toNSCollectionLayoutSupplementaryItem

extension SupplementaryItem: NSCollectionLayoutSupplementaryItemConvertible {
  /// Converts `SupplementaryItem` to `NSCollectionLayoutSupplementaryItem`.
  ///
  /// This method checks if `itemAnchor` is set. If it is, it initializes `NSCollectionLayoutSupplementaryItem` with `itemAnchor`. Otherwise, it initializes it without `itemAnchor`.
  ///
  /// - Returns: An instance of `NSCollectionLayoutSupplementaryItem` configured with properties from `SupplementaryItem`.
  public func toNSCollectionLayoutSupplementaryItem() -> NSCollectionLayoutSupplementaryItem {
    if let itemAnchor = itemAnchor {
      return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
    } else {
      return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor)
    }
  }
}

// MARK: - Size

public extension SupplementaryItem {
  /// Sets the width dimension of the supplementary item.
  ///
  /// - Parameter value: The new width dimension for the supplementary item.
  /// - Returns: A supplementary item with the updated width dimension.
  func width(_ value: NSCollectionLayoutDimension) -> SupplementaryItem {
    return mutable(self) { $0.width = value }
  }

  /// Sets the height dimension of the supplementary item.
  ///
  /// - Parameter value: The new height dimension for the supplementary item.
  /// - Returns: A supplementary item with the updated height dimension.
  func height(_ value: NSCollectionLayoutDimension) -> SupplementaryItem {
    return mutable(self) { $0.height = value }
  }

  /// Sets both the width and height dimensions of the supplementary item.
  ///
  /// - Parameter value: The new size for the supplementary item, containing both width and height dimensions.
  /// - Returns: A supplementary item with the updated dimensions.
  func size(_ value: NSCollectionLayoutSize) -> SupplementaryItem {
    return mutable(self) {
      $0.width = value.widthDimension
      $0.height = value.heightDimension
    }
  }
}

// MARK: - elementKind

public extension SupplementaryItem {
  /// Sets the element kind of the supplementary item.
  ///
  /// - Parameter kind: The new element kind for the supplementary item.
  /// - Returns: A supplementary item with the updated element kind.
  func elementKind(_ kind: String) -> SupplementaryItem {
    return mutable(self) { $0.elementKind = kind }
  }
}

// MARK: - Container Anchor

public extension SupplementaryItem {
  /// Sets the container anchor of the supplementary item.
  ///
  /// - Parameter anchor: The `NSCollectionLayoutAnchor` to be used as the container anchor.
  /// - Returns: A supplementary item with the updated container anchor.
  func containerAnchor(_ anchor: NSCollectionLayoutAnchor) -> SupplementaryItem {
    return mutable(self) { $0.containerAnchor = anchor }
  }

  /// Sets the container anchor of the supplementary item using edges.
  ///
  /// - Parameter edges: The edges to which the container anchor will be aligned.
  /// - Returns: A supplementary item with the updated container anchor.
  func containerAnchor(edges: NSDirectionalRectEdge) -> SupplementaryItem {
    return mutable(self) { $0.containerAnchor = NSCollectionLayoutAnchor(edges: edges) }
  }

  /// Sets the container anchor of the supplementary item using edges and an absolute offset.
  ///
  /// - Parameters:
  ///   - edges: The edges to which the container anchor will be aligned.
  ///   - absoluteOffset: The absolute offset from the edges.
  /// - Returns: A supplementary item with the updated container anchor.
  func containerAnchor(edges: NSDirectionalRectEdge, absoluteOffset: CGPoint) -> SupplementaryItem {
    return mutable(self) { $0.containerAnchor = NSCollectionLayoutAnchor(edges: edges, absoluteOffset: absoluteOffset) }
  }

  /// Sets the container anchor of the supplementary item using edges and a fractional offset.
  ///
  /// - Parameters:
  ///   - edges: The edges to which the container anchor will be aligned.
  ///   - fractionalOffset: The fractional offset from the edges.
  /// - Returns: A supplementary item with the updated container anchor.
  func containerAnchor(edges: NSDirectionalRectEdge, fractionalOffset: CGPoint) -> SupplementaryItem {
    return mutable(self) { $0.containerAnchor = NSCollectionLayoutAnchor(edges: edges, fractionalOffset: fractionalOffset) }
  }
}
// MARK: - Item Anchor

public extension SupplementaryItem {
  /// Sets the item anchor of the supplementary item.
  ///
  /// - Parameter anchor: The `NSCollectionLayoutAnchor` to be used as the item anchor.
  /// - Returns: A supplementary item with the updated item anchor.
  func itemAnchor(_ anchor: NSCollectionLayoutAnchor) -> SupplementaryItem {
    return mutable(self) { $0.itemAnchor = anchor }
  }

  /// Sets the item anchor of the supplementary item using edges.
  ///
  /// - Parameter edges: The edges to which the item anchor will be aligned.
  /// - Returns: A supplementary item with the updated item anchor.
  func itemAnchor(edges: NSDirectionalRectEdge) -> SupplementaryItem {
    return mutable(self) { $0.itemAnchor = NSCollectionLayoutAnchor(edges: edges) }
  }

  /// Sets the item anchor of the supplementary item using edges and an absolute offset.
  ///
  /// - Parameters:
  ///   - edges: The edges to which the item anchor will be aligned.
  ///   - absoluteOffset: The absolute offset from the edges.
  /// - Returns: A supplementary item with the updated item anchor.
  func itemAnchor(edges: NSDirectionalRectEdge, absoluteOffset: CGPoint) -> SupplementaryItem {
    return mutable(self) { $0.itemAnchor = NSCollectionLayoutAnchor(edges: edges, absoluteOffset: absoluteOffset) }
  }

  /// Sets the item anchor of the supplementary item using edges and a fractional offset.
  ///
  /// - Parameters:
  ///   - edges: The edges to which the item anchor will be aligned.
  ///   - fractionalOffset: The fractional offset from the edges.
  /// - Returns: A supplementary item with the updated item anchor.
  func itemAnchor(edges: NSDirectionalRectEdge, fractionalOffset: CGPoint) -> SupplementaryItem {
    return mutable(self) { $0.itemAnchor = NSCollectionLayoutAnchor(edges: edges, fractionalOffset: fractionalOffset) }
  }
}
