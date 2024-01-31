//
//  File.swift
//  
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

@resultBuilder
public enum BoundarySupplementaryItemBuilder {
}

extension BoundarySupplementaryItemBuilder {
    public static func buildBlock(_ items: BoundarySupplementaryItem...) -> [BoundarySupplementaryItem] {
        items.compactMap { $0 }
    }
    
    public static func buildFinalResult(_ items: [BoundarySupplementaryItem]) -> [BoundarySupplementaryItem] {
        return items.compactMap { $0 }
    }
}
