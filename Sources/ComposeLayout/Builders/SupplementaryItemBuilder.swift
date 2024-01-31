//
//  File.swift
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
public enum SupplementaryItemBuilder {
    public static func buildBlock(_ items: SupplementaryItem...) -> [SupplementaryItem] {
        items.compactMap { $0 }
    }
}
