//
//  ComposeLayoutModel.swift
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

public struct ComposeLayoutModel: NSCollectionLayoutSectionsConvertible {
    public var sections: [Section]
}

extension ComposeLayoutModel {
    public func toNSCollectionLayoutSections() -> [NSCollectionLayoutSection] {
        return self.sections.compactMap { $0.toNSCollectionLayoutSections() }.flatMap { $0 }
    }
}
