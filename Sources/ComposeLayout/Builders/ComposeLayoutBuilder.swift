//
//  ComposeLayoutBuilder.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

/// A result builder for composing layout models from various components.
@resultBuilder
public enum ComposeLayoutBuilder {
  /// Builds an array of `ComposeLayoutModel` from a variadic list of components conforming to `NSCollectionLayoutSectionsConvertible`.
  /// - Parameter components: A variadic list of components.
  /// - Returns: An array of `ComposeLayoutModel`.
  public static func buildBlock(_ components: NSCollectionLayoutSectionsConvertible...) -> [ComposeLayoutModel] {
    return components.compactMap { ComposeLayoutModel(sections: $0.sections) }
  }

  /// Finalizes the construction of a `ComposeLayoutModel` from an array of `ComposeLayoutModel`.
  /// - Parameter component: An array of `ComposeLayoutModel`.
  /// - Returns: A single `ComposeLayoutModel` containing all sections.
  public static func buildFinalResult(_ component: [ComposeLayoutModel]) -> ComposeLayoutModel {
    return component.reduce(into: ComposeLayoutModel(sections: [])) { acc, composeLayoutModel in
      acc.sections.append(contentsOf: composeLayoutModel.sections)
    }
  }

  /// Handles an optional array of `ComposeLayoutModel`, constructing a `ComposeLayoutModel` regardless of the input being nil or not.
  /// - Parameter component: An optional array of `ComposeLayoutModel`.
  /// - Returns: A `ComposeLayoutModel`.
  public static func buildOptional(_ component: [ComposeLayoutModel]?) -> ComposeLayoutModel {
    return buildFinalResult(component ?? [])
  }

  /// Constructs a `ComposeLayoutModel` from the first component of a conditional content.
  /// - Parameter component: An array of `ComposeLayoutModel`.
  /// - Returns: A `ComposeLayoutModel`.
  public static func buildEither(first component: [ComposeLayoutModel]) -> ComposeLayoutModel {
    return buildFinalResult(component)
  }

  /// Constructs a `ComposeLayoutModel` from the second component of a conditional content.
  /// - Parameter component: An array of `ComposeLayoutModel`.
  /// - Returns: A `ComposeLayoutModel`.
  public static func buildEither(second component: [ComposeLayoutModel]) -> ComposeLayoutModel {
    return buildFinalResult(component)
  }

  /// Constructs a `ComposeLayoutModel` from an array of arrays of `ComposeLayoutModel`.
  /// - Parameter components: An array of arrays of `ComposeLayoutModel`.
  /// - Returns: A `ComposeLayoutModel`.
  public static func buildArray(_ components: [[ComposeLayoutModel]]) -> ComposeLayoutModel {
    return buildFinalResult(components.flatMap { $0 })
  }
}
