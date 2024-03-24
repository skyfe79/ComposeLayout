//
//  NSCollectionLayoutGroupConvertible.swift
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

/// A protocol that enables the conversion to `NSCollectionLayoutGroup`.
///
/// Conforming types can be converted into an instance of `NSCollectionLayoutGroup`, which is used to define the layout of items in a collection view group.
public protocol NSCollectionLayoutGroupConvertible {
  /// Converts the conforming type to an instance of `NSCollectionLayoutGroup`.
  ///
  /// This method is responsible for creating an `NSCollectionLayoutGroup` that represents the layout of items in a collection view group.
  ///
  /// - Returns: An `NSCollectionLayoutGroup` instance that defines the layout of items.
  func toNSCollectionLayoutGroup() -> NSCollectionLayoutGroup
}
