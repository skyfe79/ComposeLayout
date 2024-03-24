//
//  ComposeLayoutModel.swift
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

/// A model representing the layout of sections within a collection view.
///
/// This model conforms to `NSCollectionLayoutSectionsConvertible`, allowing it to convert its sections into an array of `NSCollectionLayoutSection`.
public struct ComposeLayoutModel: NSCollectionLayoutSectionsConvertible {
  /// The sections that make up the layout model.
  public var sections: [Section]

  /// Initializes a new layout model with the given sections.
  ///
  /// - Parameter sections: The sections to be included in the layout model.
  public init(sections: [Section]) {
    self.sections = sections
  }
}

public extension ComposeLayoutModel {
  /// Converts the model's sections into an array of `NSCollectionLayoutSection`.
  ///
  /// This method iterates over each section in the model, converting them into `NSCollectionLayoutSection` objects.
  ///
  /// - Returns: An array of `NSCollectionLayoutSection` representing the layout of the sections within the collection view.
  func toNSCollectionLayoutSections() -> [NSCollectionLayoutSection] {
    return sections.compactMap { $0.toNSCollectionLayoutSections() }.flatMap { $0 }
  }
}
