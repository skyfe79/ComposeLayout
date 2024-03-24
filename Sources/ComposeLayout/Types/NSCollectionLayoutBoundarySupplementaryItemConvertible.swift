//
//  NSCollectionLayoutBoundarySupplementaryItemConvertible.swift
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

/// A protocol that enables the conversion to `NSCollectionLayoutBoundarySupplementaryItem`.
public protocol NSCollectionLayoutBoundarySupplementaryItemConvertible {
  /// Converts the conforming type to an instance of `NSCollectionLayoutBoundarySupplementaryItem`.
  /// - Returns: An `NSCollectionLayoutBoundarySupplementaryItem` instance.
  func toNSCollectionLayoutBoundarySupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem
}
