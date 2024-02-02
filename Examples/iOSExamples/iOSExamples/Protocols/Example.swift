//
//  Example.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/02.
//

import Foundation
import UIKit

protocol Example: CollectionViewProvider, DiffableDataSourceProvider {
    func createLayout() -> UICollectionViewLayout
    func configureHierarchy() -> Void
    func configureDataSource() -> Void
}
