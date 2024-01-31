//
//  DecorationItemBuilder.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

@resultBuilder
public enum DecorationItemBuilder {
    
}

extension DecorationItemBuilder {
    public static func buildBlock(_ items: DecorationItem...) -> [DecorationItem] {
        return items.compactMap { $0 }
    }
    
    public static func buildFinalResult(_ items: [DecorationItem]) -> [DecorationItem] {
        return items.compactMap { $0 }
    }
}

