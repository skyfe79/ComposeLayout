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

public protocol NSCollectionLayoutBoundarySupplementaryItemConvertible {
    func toNSCollectionLayoutBoundarySupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem
}
