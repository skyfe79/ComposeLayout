//
//  GroupBuilder.swift
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

/// A result builder that constructs an array of `NSCollectionLayoutItem` from various components.
@resultBuilder
public enum GroupBuilder {
  // for single ComposeLayoutItem expression and for in expression
  public static func buildBlock(_ components: [ComposeLayoutItem]...) -> [ComposeLayoutItem] {
    return components.flatMap { $0 }
  }

  /// Finalizes the construction of an array of `NSCollectionLayoutItem` from an array of `ComposeLayoutItem`.
  /// - Parameter component: An array of `ComposeLayoutItem`.
  /// - Returns: An array of `NSCollectionLayoutItem`.
  public static func buildFinalResult(_ component: [ComposeLayoutItem]) -> [NSCollectionLayoutItem] {
    return component.compactMap { $0.toNSCollectionLayoutItem() }
  }

  /// Constructs an array of `ComposeLayoutItem` from a single or multiple `ComposeLayoutItem`.
  /// - Parameter expression: A single or multiple `ComposeLayoutItem`.
  /// - Returns: An array of `ComposeLayoutItem`.
  public static func buildExpression(_ expression: [ComposeLayoutItem]) -> [ComposeLayoutItem] {
    return expression
  }

  /// Constructs an array of `ComposeLayoutItem` from a single `ComposeLayoutItem`.
  /// - Parameter expression: A single `ComposeLayoutItem`.
  /// - Returns: An array of `ComposeLayoutItem`.
  public static func buildExpression(_ expression: ComposeLayoutItem) -> [ComposeLayoutItem] {
    return [expression]
  }

  /// Constructs an array of `ComposeLayoutItem` from an array of arrays of `ComposeLayoutItem`.
  /// - Parameter components: An array of arrays of `ComposeLayoutItem`.
  /// - Returns: An array of `ComposeLayoutItem`.
  public static func buildArray(_ components: [[ComposeLayoutItem]]) -> [ComposeLayoutItem] {
    return components.flatMap { $0 }
  }

  /// Handles an optional array of `ComposeLayoutItem`, constructing an array of `ComposeLayoutItem` regardless of the input being nil or not.
  /// - Parameter component: An optional array of `ComposeLayoutItem`.
  /// - Returns: An array of `ComposeLayoutItem`.
  public static func buildOptional(_ component: [ComposeLayoutItem]?) -> [ComposeLayoutItem] {
    return component ?? []
  }

  /// Constructs an array of `ComposeLayoutItem` from the first component of a conditional content.
  /// - Parameter component: An array of `ComposeLayoutItem`.
  /// - Returns: An array of `ComposeLayoutItem`.
  public static func buildEither(first component: [ComposeLayoutItem]) -> [ComposeLayoutItem] {
    return component
  }

  /// Constructs an array of `ComposeLayoutItem` from the second component of a conditional content.
  /// - Parameter component: An array of `ComposeLayoutItem`.
  /// - Returns: An array of `ComposeLayoutItem`.
  public static func buildEither(second component: [ComposeLayoutItem]) -> [ComposeLayoutItem] {
    return component
  }
}
