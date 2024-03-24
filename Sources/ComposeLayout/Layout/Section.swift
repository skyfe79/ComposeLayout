//
//  Section.swift
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

/// A structure that represents a section in a compositional layout.
///
/// This structure can be used to define different types of sections within a compositional layout, including normal sections and list sections (iOS 14.0+).
public struct Section {
  #if os(iOS)
    /// An enumeration that defines the types of sections available on iOS.
    @available(iOS 14.0, *)
    private enum SectionType {
      /// A normal section without any specific configuration.
      case normal
      /// A list section that uses a `UICollectionLayoutListConfiguration` and `NSCollectionLayoutEnvironment`.
      case list(configuration: UICollectionLayoutListConfiguration, layoutEnvironment: NSCollectionLayoutEnvironment)
    }
  #endif

  /// The type of the section, used internally to differentiate between normal and list sections on iOS.
  private let type: Any?
  /// The root group of the section, defining the layout of items within the section.
  public var rootGroup: NSCollectionLayoutGroupConvertible
  /// The behavior for orthogonal scrolling within the section.
  public var orthogonalScrollingBehavior: PlatformCollectionLayoutSectionOrthogonalScrollingBehavior?
  /// The spacing between groups within the section.
  public var interGroupSpacing: CGFloat = 0.0
  /// The content insets for the section.
  public var contentInsets: NSDirectionalEdgeInsets?
  /// A reference to the content insets, used on iOS.
  public var contentInsetsReference: Any?
  /// A reference to the supplementary content insets, used on iOS.
  public var supplementaryContentInsetsReference: Any?
  /// The boundary supplementary items for the section.
  public var boundarySupplementaryItems: [BoundarySupplementaryItem]?
  /// The decoration items for the section.
  public var decorationItems: [DecorationItem]?
  /// A handler for invalidating visible items within the section.
  public var visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?

  /// Initializes a new section with the specified type and root group.
  /// - Parameters:
  ///   - type: The type of the section, used internally.
  ///   - rootGroup: A closure that returns the root group for the section.
  private init(type: Any?, @SectionBuilder rootGroup: () -> NSCollectionLayoutGroupConvertible) {
    self.type = type
    self.rootGroup = rootGroup()
  }

  /// Initializes a new section with the specified root group.
  /// - Parameter rootGroup: A closure that returns the root group for the section.
  public init(@SectionBuilder rootGroup: () -> NSCollectionLayoutGroupConvertible) {
    #if os(iOS)
      if #available(iOS 14.0, *) {
        self.init(type: SectionType.normal, rootGroup: rootGroup)
      } else {
        self.init(type: nil, rootGroup: rootGroup)
      }
    #else
      self.init(type: nil, rootGroup: rootGroup)
    #endif
  }

  #if os(iOS)
    /// Creates a list section using the specified configuration and layout environment.
    /// - Parameters:
    ///   - configuration: The configuration for the list.
    ///   - layoutEnvironment: The layout environment for the list.
    /// - Returns: A `Section` configured as a list.
    @available(iOS 14.0, *)
    public static func list(using configuration: UICollectionLayoutListConfiguration, layoutEnvironment: NSCollectionLayoutEnvironment) -> Section {
      Section(type: SectionType.list(configuration: configuration, layoutEnvironment: layoutEnvironment)) {
        // not used
        HGroup {}
      }
    }
  #endif
}

extension Section: NSCollectionLayoutSectionConvertible, NSCollectionLayoutSectionsConvertible {
  /// Returns an array containing the section itself.
  public var sections: [Section] {
    return [self]
  }

  /// Converts a normal section to an `NSCollectionLayoutSection`.
  private func normalSectionToNSCollectionLayoutSection() -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection(group: rootGroup.toNSCollectionLayoutGroup())
    section.interGroupSpacing = interGroupSpacing
    if let orthogonalScrollingBehavior = orthogonalScrollingBehavior {
      section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
    }
    if let contentInsets = contentInsets {
      section.contentInsets = contentInsets
    }
    if let boundarySupplementaryItems = boundarySupplementaryItems {
      section.boundarySupplementaryItems = boundarySupplementaryItems.compactMap { $0.toNSCollectionLayoutBoundarySupplementaryItem() }
    }
    if let decorationItems = decorationItems {
      section.decorationItems = decorationItems.compactMap { $0.toNSCollectionLayoutDecorationItem() }
    }
    if let visibleItemsInvalidationHandler = visibleItemsInvalidationHandler {
      section.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
    }

    #if os(iOS)
      if #available(iOS 14.0, *), let contentInsetsReference = contentInsetsReference as? UIContentInsetsReference {
        section.contentInsetsReference = contentInsetsReference
      }
      if #available(iOS 16.0, *), let supplementaryContentInsetsReference = supplementaryContentInsetsReference as? UIContentInsetsReference {
        section.supplementaryContentInsetsReference = supplementaryContentInsetsReference
      }
    #endif

    return section
  }

  #if os(iOS)
    /// Converts a list section to an `NSCollectionLayoutSection` using the specified configuration and layout environment.
    @available(iOS 14.0, *)
    private func listSectionToNSCollectionLayoutSection(using configuration: UICollectionLayoutListConfiguration, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
      return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    }
  #endif

  /// Converts the section to an `NSCollectionLayoutSection`.
  public func toNSCollectionLayoutSection() -> NSCollectionLayoutSection {
    #if os(iOS)
      if #available(iOS 14.0, *), let sectionType = type as? SectionType {
        switch sectionType {
        case .normal:
          return normalSectionToNSCollectionLayoutSection()
        case let .list(configuration, layoutEnvironment):
          return listSectionToNSCollectionLayoutSection(using: configuration, layoutEnvironment: layoutEnvironment)
        }
      } else {
        return normalSectionToNSCollectionLayoutSection()
      }
    #else
      return normalSectionToNSCollectionLayoutSection()
    #endif
  }

  /// Returns an array containing a single `NSCollectionLayoutSection` converted from the section.
  public func toNSCollectionLayoutSections() -> [NSCollectionLayoutSection] {
    return [toNSCollectionLayoutSection()]
  }
}

// MARK: - Specifying scrolling behavior

public extension Section {
  /// Sets the orthogonal scrolling behavior for the section.
  ///
  /// This method allows you to specify how the section should scroll orthogonally (i.e., in a direction perpendicular to the main scroll direction).
  ///
  /// - Parameter value: The orthogonal scrolling behavior for the section.
  /// - Returns: A section with the updated orthogonal scrolling behavior.
  func orthogonalScrollingBehavior(_ value: PlatformCollectionLayoutSectionOrthogonalScrollingBehavior) -> Section {
    return mutable(self) { $0.orthogonalScrollingBehavior = value }
  }
}

// MARK: - Configuring section spacing

public extension Section {
  /// Sets the spacing between groups within the section.
  ///
  /// This method allows you to specify the amount of space between adjacent groups in a section.
  ///
  /// - Parameter value: The spacing in points between groups within the section.
  /// - Returns: A section with the updated inter-group spacing.
  func interGroupSpacing(_ value: CGFloat) -> Section {
    return mutable(self) { $0.interGroupSpacing = value }
  }
}

// MARK: - contentInsets

public extension Section {
  /// Sets the content insets for the section.
  ///
  /// - Parameter insets: The directional edge insets to be applied to the section.
  /// - Returns: A section with the updated content insets.
  func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Section {
    return mutable(self) {
      $0.contentInsets = insets
    }
  }

  /// Sets the content insets for the section with individual values for each edge.
  ///
  /// - Parameters:
  ///   - leading: The leading edge inset. Defaults to `0.0`.
  ///   - top: The top edge inset. Defaults to `0.0`.
  ///   - trailing: The trailing edge inset. Defaults to `0.0`.
  ///   - bottom: The bottom edge inset. Defaults to `0.0`.
  /// - Returns: A section with the updated content insets.
  func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Section {
    return mutable(self) {
      let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
      $0.contentInsets = newInsets
    }
  }

  #if os(iOS)
    /// Sets the content insets for the section based on a reference type available in iOS 14.0 and later.
    ///
    /// - Parameter reference: The content insets reference type.
    /// - Returns: A section with the updated content insets reference.
    @available(iOS 14.0, *)
    func contentInsets(reference: UIContentInsetsReference) -> Section {
      return mutable(self) { $0.contentInsetsReference = reference }
    }

    /// Sets the supplementary content insets for the section based on a reference type available in iOS 16.0 and later.
    ///
    /// - Parameter reference: The supplementary content insets reference type.
    /// - Returns: A section with the updated supplementary content insets reference.
    @available(iOS 16.0, *)
    func supplementaryContentInsets(reference: UIContentInsetsReference) -> Section {
      return mutable(self) { $0.supplementaryContentInsetsReference = reference }
    }
  #endif
}

// MARK: - Configuring additional views

public extension Section {
  /// Adds boundary supplementary items to the section.
  ///
  /// This method allows for the dynamic addition of boundary supplementary items to a section using a builder closure.
  ///
  /// - Parameter boundarySupplementaryItems: A closure that returns an array of `BoundarySupplementaryItem`.
  /// - Returns: A section with the added boundary supplementary items.
  func boundarySupplementaryItems(@BoundarySupplementaryItemBuilder boundarySupplementaryItems: () -> [BoundarySupplementaryItem]) -> Section {
    return mutable(self) { $0.boundarySupplementaryItems = boundarySupplementaryItems() }
  }

  /// Adds decoration items to the section.
  ///
  /// This method allows for the dynamic addition of decoration items to a section using a builder closure.
  ///
  /// - Parameter decorationItems: A closure that returns an array of `DecorationItem`.
  /// - Returns: A section with the added decoration items.
  func decorationItems(@DecorationItemBuilder decorationItems: () -> [DecorationItem]) -> Section {
    return mutable(self) { $0.decorationItems = decorationItems() }
  }
}

// MARK: - visibleItemsInvalidationHandler

public extension Section {
  /// Sets a handler that is invoked when the visibility of items in the section changes.
  ///
  /// - Parameter handler: A closure that is called when the visibility of items within the section changes.
  /// - Returns: A section with the updated visible items invalidation handler.
  func visibleItemsInvalidationHandler(_ handler: @escaping NSCollectionLayoutSectionVisibleItemsInvalidationHandler) -> Section {
    return mutable(self) { $0.visibleItemsInvalidationHandler = handler }
  }
}
