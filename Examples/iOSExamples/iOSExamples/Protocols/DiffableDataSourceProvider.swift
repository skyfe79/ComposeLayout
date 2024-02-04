//
//  DiffableDataSourceProvider.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/02.
//

import Foundation
import UIKit

protocol DiffableDataSourceProvider {
    associatedtype Sections: Hashable
    associatedtype Content: Hashable
    var dataSource: UICollectionViewDiffableDataSource<Sections, Content>! { get }
}
