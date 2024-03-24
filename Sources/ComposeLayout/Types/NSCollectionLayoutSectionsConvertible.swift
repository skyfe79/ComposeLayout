//
//  NSCollectionLayoutSectionsConvertible.swift
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

/// A protocol that enables the conversion of sections into an array of `NSCollectionLayoutSection`.
///
/// Conforming types can convert their section representations into `NSCollectionLayoutSection` objects, which are used to define the layout of sections within a collection view.
public protocol NSCollectionLayoutSectionsConvertible {
  /// The sections to be converted.
  var sections: [Section] { get }
  
  /// Converts the sections into an array of `NSCollectionLayoutSection`.
  ///
  /// This method is responsible for creating `NSCollectionLayoutSection` objects that represent the layout of sections within a collection view.
  ///
  /// - Returns: An array of `NSCollectionLayoutSection` representing the layout of the sections.
  func toNSCollectionLayoutSections() -> [NSCollectionLayoutSection]
}
