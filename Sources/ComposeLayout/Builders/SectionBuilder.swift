//
//  SectionBuilder.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

/// A result builder that constructs a section layout by combining various group components.
@resultBuilder
public enum SectionBuilder {
  /// Constructs a section layout from a variadic list of group components.
  /// - Parameter components: A variadic list of components conforming to `NSCollectionLayoutGroupConvertible`.
  /// - Returns: A component conforming to `NSCollectionLayoutGroupConvertible`.
  /// - Precondition: Only one group component is allowed per section.
  /// - Note: This method enforces that exactly one group component is provided to form a section.
  public static func buildBlock(_ components: NSCollectionLayoutGroupConvertible...) -> NSCollectionLayoutGroupConvertible {
    precondition(components.count == 1, "Section can contain only one Group!")
    guard
      let rootGroup = components.first
    else {
      fatalError("Section must have only one Group!")
    }
    return rootGroup
  }

  /// Allows a component to be conditionally included in a section layout when availability is limited.
  /// - Parameter component: A component conforming to `NSCollectionLayoutGroupConvertible`.
  /// - Returns: The provided component.
  public static func buildLimitedAvailability(_ component: NSCollectionLayoutGroupConvertible) -> NSCollectionLayoutGroupConvertible {
    return component
  }

  /// Constructs a section layout from the first component of a conditional content.
  /// - Parameter component: A component conforming to `NSCollectionLayoutGroupConvertible`.
  /// - Returns: The provided component.
  public static func buildEither(first component: NSCollectionLayoutGroupConvertible) -> NSCollectionLayoutGroupConvertible {
    return component
  }

  /// Constructs a section layout from the second component of a conditional content.
  /// - Parameter component: A component conforming to `NSCollectionLayoutGroupConvertible`.
  /// - Returns: The provided component.
  public static func buildEither(second component: NSCollectionLayoutGroupConvertible) -> NSCollectionLayoutGroupConvertible {
    return component
  }
}
