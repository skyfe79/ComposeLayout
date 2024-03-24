//
//  NSCollectionLayoutSectionConvertible.swift
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

/// A protocol that enables the conversion to `NSCollectionLayoutSection`.
///
/// Types conforming to this protocol can be converted into an instance of `NSCollectionLayoutSection`, which is used to define the layout of sections in a collection view.
public protocol NSCollectionLayoutSectionConvertible {
  /// Converts the conforming type to an instance of `NSCollectionLayoutSection`.
  ///
  /// This method is responsible for creating an `NSCollectionLayoutSection` that represents the layout of a section in a collection view.
  ///
  /// - Returns: An `NSCollectionLayoutSection` instance.
  func toNSCollectionLayoutSection() -> NSCollectionLayoutSection
}
