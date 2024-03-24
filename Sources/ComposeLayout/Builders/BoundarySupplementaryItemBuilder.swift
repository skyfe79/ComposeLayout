//
//  BoundarySupplementaryItemBuilder.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

/// A result builder that constructs an array of `BoundarySupplementaryItem` objects.
@resultBuilder
public enum BoundarySupplementaryItemBuilder {}

public extension BoundarySupplementaryItemBuilder {
  /// Builds an array of `BoundarySupplementaryItem` from a variadic list of items.
  /// - Parameter items: A variadic list of `BoundarySupplementaryItem` objects.
  /// - Returns: An array of `BoundarySupplementaryItem`.
  static func buildBlock(_ items: BoundarySupplementaryItem...) -> [BoundarySupplementaryItem] {
    return items.compactMap { $0 }
  }

  /// Finalizes the construction of an array of `BoundarySupplementaryItem`.
  /// - Parameter items: An array of `BoundarySupplementaryItem` objects.
  /// - Returns: An array of `BoundarySupplementaryItem`.
  static func buildFinalResult(_ items: [BoundarySupplementaryItem]) -> [BoundarySupplementaryItem] {
    return items.compactMap { $0 }
  }
}
