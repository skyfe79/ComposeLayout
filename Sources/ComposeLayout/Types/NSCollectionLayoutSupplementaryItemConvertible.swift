//
//  NSCollectionLayoutSupplementaryItemConvertible.swift
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

/// A protocol that enables the conversion to `NSCollectionLayoutSupplementaryItem`.
///
/// Types conforming to this protocol can be converted into an instance of `NSCollectionLayoutSupplementaryItem`, which is used to define the layout of supplementary items in a collection view.
public protocol NSCollectionLayoutSupplementaryItemConvertible {
  /// Converts the conforming type to an instance of `NSCollectionLayoutSupplementaryItem`.
  ///
  /// This method is responsible for creating an `NSCollectionLayoutSupplementaryItem` that represents the layout of a supplementary item in a collection view.
  ///
  /// - Returns: An `NSCollectionLayoutSupplementaryItem` instance.
  func toNSCollectionLayoutSupplementaryItem() -> NSCollectionLayoutSupplementaryItem
}
