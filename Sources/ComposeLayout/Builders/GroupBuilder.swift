//
//  ItemBuilder.swift
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

@resultBuilder
public enum GroupBuilder {
    // for single ComposeLayoutItem expression and for in expression
    public static func buildBlock(_ components: [ComposeLayoutItem]...) -> [ComposeLayoutItem] {
            return components.flatMap { $0 }
    }
    
    public static func buildFinalResult(_ component: [ComposeLayoutItem]) -> [NSCollectionLayoutItem] {
        return component.compactMap { $0.toNSCollectionLayoutItem() }
    }

    public static func buildExpression(_ expression: [ComposeLayoutItem]) -> [ComposeLayoutItem] {
        return expression
    }
    
    public static func buildExpression(_ expression: ComposeLayoutItem) -> [ComposeLayoutItem] {
        return [expression]
    }
    
    public static func buildArray(_ components: [[ComposeLayoutItem]]) -> [ComposeLayoutItem] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [ComposeLayoutItem]?) -> [ComposeLayoutItem] {
        return component ?? []
    }
    
    public static func buildEither(first component: [ComposeLayoutItem]) -> [ComposeLayoutItem] {
        return component
    }
    
    public static func buildEither(second component: [ComposeLayoutItem]) -> [ComposeLayoutItem] {
        return component
    }
}
