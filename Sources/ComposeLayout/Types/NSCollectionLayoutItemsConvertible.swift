//
//  NSCollectionLayoutItemsConvertible.swift
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

/// A protocol that enables the conversion to a single `NSCollectionLayoutItem`.
public protocol NSCollectionLayoutItemConvertible {
  /// Converts the conforming type to an instance of `NSCollectionLayoutItem`.
  ///
  /// - Returns: An `NSCollectionLayoutItem` instance.
  func toNSCollectionLayoutItem() -> NSCollectionLayoutItem
}

/// A protocol that enables the conversion to multiple `NSCollectionLayoutItem`s.
public protocol NSCollectionLayoutItemsConvertible {
  /// Converts the conforming type to an array of `NSCollectionLayoutItem` instances.
  ///
  /// - Returns: An array of `NSCollectionLayoutItem` instances.
  func toNSCollectionLayoutItems() -> [NSCollectionLayoutItem]
}
