//
//  File.swift
//  
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

@resultBuilder
public enum ComposeLayoutBuilder {
    public static func buildBlock(_ components: NSCollectionLayoutSectionsConvertible...) -> [ComposeLayoutModel] {
        return components.compactMap { ComposeLayoutModel(sections: $0.sections) }
    }
        
    public static func buildFinalResult(_ component: [ComposeLayoutModel]) -> ComposeLayoutModel {
        return component.reduce(into: ComposeLayoutModel(sections: [])) { acc, composeLayoutModel in
            acc.sections.append(contentsOf: composeLayoutModel.sections)
        }
    }
    
    /// support if block
    public static func buildOptional(_ component: [ComposeLayoutModel]?) -> ComposeLayoutModel {
        return buildFinalResult(component ?? [])
    }

    /// support if-else block (if)
    public static func buildEither(first component: [ComposeLayoutModel]) -> ComposeLayoutModel {
        return buildFinalResult(component)
    }
    
    /// support if-else block (else)
    public static func buildEither(second component: [ComposeLayoutModel]) -> ComposeLayoutModel {
        return buildFinalResult(component)
    }
    
    /// support for-in loop
    public static func buildArray(_ components: [[ComposeLayoutModel]]) -> ComposeLayoutModel {
        return buildFinalResult(components.flatMap { $0 })
    }
}
