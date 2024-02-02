//
//  CollectionViewProvider.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/02.
//

import Foundation
import UIKit

protocol CollectionViewProvider: AnyObject {
    var collectionView: UICollectionView! { get set }
}
