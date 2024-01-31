//
//  File.swift
//  
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

@resultBuilder
public enum SectionBuilder {
    public static func buildBlock(_ components: NSCollectionLayoutGroupConvertible...) -> NSCollectionLayoutGroupConvertible {
        precondition(components.count == 1, "Section can contain only one Group!")
        guard
            let rootGroup = components.first
        else {
            fatalError("Section must have only one Group!")
        }
        return rootGroup
    }
    
    
    public static func buildLimitedAvailability(_ component: NSCollectionLayoutGroupConvertible) -> NSCollectionLayoutGroupConvertible {
        return component
    }
        
    public static func buildEither(first component: NSCollectionLayoutGroupConvertible) -> NSCollectionLayoutGroupConvertible {
        return component
    }
    
    public static func buildEither(second component: NSCollectionLayoutGroupConvertible) -> NSCollectionLayoutGroupConvertible {
        return component
    }
}
