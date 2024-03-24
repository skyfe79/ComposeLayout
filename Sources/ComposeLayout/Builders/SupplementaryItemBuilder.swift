//
//  SupplementaryItemBuilder.swift
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

/// A result builder that constructs an array of `SupplementaryItem` objects.
@resultBuilder
public enum SupplementaryItemBuilder {
  /// Builds an array of `SupplementaryItem` from a variadic list of items.
  /// - Parameter items: A variadic list of `SupplementaryItem` objects.
  /// - Returns: An array of `SupplementaryItem`.
  public static func buildBlock(_ items: SupplementaryItem...) -> [SupplementaryItem] {
    return items.compactMap { $0 }
  }
}
