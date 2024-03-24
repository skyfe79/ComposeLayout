//
//  DecorationItemBuilder.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

/// A result builder that constructs an array of `DecorationItem` objects.
@resultBuilder
public enum DecorationItemBuilder {}

public extension DecorationItemBuilder {
  /// Builds an array of `DecorationItem` from a variadic list of items.
  /// - Parameter items: A variadic list of `DecorationItem` objects.
  /// - Returns: An array of `DecorationItem`.
  static func buildBlock(_ items: DecorationItem...) -> [DecorationItem] {
    return items.compactMap { $0 }
  }

  /// Finalizes the construction of an array of `DecorationItem`.
  /// - Parameter items: An array of `DecorationItem` objects.
  /// - Returns: An array of `DecorationItem`.
  static func buildFinalResult(_ items: [DecorationItem]) -> [DecorationItem] {
    return items.compactMap { $0 }
  }
}
