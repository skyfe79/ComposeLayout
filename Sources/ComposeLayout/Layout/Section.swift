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

public struct Section: Hashable {

    #if os(iOS)
    @available(iOS 14.0, *)
    private enum SectionType {
        case normal
        case list(configuration: UICollectionLayoutListConfiguration, layoutEnvironment: NSCollectionLayoutEnvironment)
    }
    #endif
    
    public static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }
        
    /// only use id for hasing and equals comparing
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private let type: Any?
    private let id: AnyHashable
    public var rootGroup: NSCollectionLayoutGroupConvertible
    private var orthogonalScrollingBehavior: PlatformCollectionLayoutSectionOrthogonalScrollingBehavior?
    private var interGroupSpacing: CGFloat = 0.0
    private var contentInsets: NSDirectionalEdgeInsets?
    private var contentInsetsReference: Any?
    private var supplementaryContentInsetsReference: Any?
    internal var boundarySupplementaryItems: [BoundarySupplementaryItem]?
    internal var decorationItems: [DecorationItem]?
    
    private init<ID>(id: ID, type: Any?, @SectionBuilder rootGroup: () -> NSCollectionLayoutGroupConvertible) where ID: Hashable {
        self.id = id
        self.type = type
        self.rootGroup = rootGroup()
    }
    
    public init<ID>(id: ID, @SectionBuilder rootGroup: () -> NSCollectionLayoutGroupConvertible) where ID: Hashable {
        #if os(iOS)
            if #available(iOS 14.0, *) {
                self.init(id: id, type: SectionType.normal, rootGroup: rootGroup)
            } else {
                self.init(id: id, type: nil, rootGroup: rootGroup)
            }
        #else
            self.init(type: nil, rootGroup: rootGroup)
        #endif
    }
    
    #if os(iOS)
    @available(iOS 14.0, *)
    public static func list(using configuration: UICollectionLayoutListConfiguration, layoutEnvironment: NSCollectionLayoutEnvironment) -> Section  {
        Section(id: "test", type: SectionType.list(configuration: configuration, layoutEnvironment: layoutEnvironment)) {
            HGroup {
                
            }
        }
    }
    #endif
}

extension Section: NSCollectionLayoutSectionConvertible, NSCollectionLayoutSectionsConvertible {
    public var sections: [Section] {
        return [self]
    }
    
    private func normalSectionToNSCollectionLayoutSection() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: rootGroup.toNSCollectionLayoutGroup())
        section.interGroupSpacing = interGroupSpacing
        if let orthogonalScrollingBehavior {
            section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        }
        if let contentInsets {
            section.contentInsets = contentInsets
        }
        if let boundarySupplementaryItems {
            section.boundarySupplementaryItems = boundarySupplementaryItems.compactMap { $0.toNSCollectionLayoutBoundarySupplementaryItem() }
        }
        if let decorationItems {
            section.decorationItems = decorationItems.compactMap { $0.toNSCollectionLayoutDecorationItem() }
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
    @available(iOS 14.0, *)
    private func listSectionToNSCollectionLayoutSection(using configuration: UICollectionLayoutListConfiguration, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    }
    #endif
    
    public func toNSCollectionLayoutSection() -> NSCollectionLayoutSection {
        #if os(iOS)
        if #available(iOS 14.0, *), let sectionType = type as? SectionType {
            switch sectionType {
            case .normal:
                return normalSectionToNSCollectionLayoutSection()
            case .list(let configuration, let layoutEnvironment):
                return listSectionToNSCollectionLayoutSection(using: configuration, layoutEnvironment: layoutEnvironment)
            }
        } else {
            return normalSectionToNSCollectionLayoutSection()
        }
        #else
        return normalSectionToNSCollectionLayoutSection()
        #endif
    }
    
    public func toNSCollectionLayoutSections() -> [NSCollectionLayoutSection] {
        return [toNSCollectionLayoutSection()]
    }
}


// MARK: - Specifying scrolling behavior
extension Section {
    public func orthogonalScrollingBehavior(_ value: PlatformCollectionLayoutSectionOrthogonalScrollingBehavior) -> Section {
        return mutable(self) { $0.orthogonalScrollingBehavior = value }
    }
}

// MARK: - Configuring section spacing
extension Section {
    public func interGroupSpacing(_ value: CGFloat) -> Section {
        return mutable(self) { $0.interGroupSpacing = value }
    }
}

// MARK: - contentInsets
extension Section {
    public func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Section {
        return mutable(self) {
            $0.contentInsets = insets
        }
    }
    
    public func contentInsets(leading: CGFloat = 0.0, top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Section {
        return mutable(self) {
            let newInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
            $0.contentInsets = newInsets
        }
    }

#if os(iOS)
    @available(iOS 14.0, *)
    public func contentInsets(reference: UIContentInsetsReference) -> Section {
        return mutable(self) { $0.contentInsetsReference = reference }
    }
    
    @available(iOS 16.0, *)
    public func supplementaryContentInsets(reference: UIContentInsetsReference) -> Section {
        return mutable(self) { $0.supplementaryContentInsetsReference = reference }
    }
#endif
}

// MARK: - Configuring additional views
extension Section {
    public func boundarySupplementaryItems(@BoundarySupplementaryItemBuilder boundarySupplementaryItems: () -> [BoundarySupplementaryItem]) -> Section {
        return mutable(self) { $0.boundarySupplementaryItems = boundarySupplementaryItems() }
    }
    
    public func decorationItems(@DecorationItemBuilder decorationItems: () -> [DecorationItem]) -> Section {
        return mutable(self) { $0.decorationItems = decorationItems() }
    }
}
