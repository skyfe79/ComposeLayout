//
//  File.swift
//  
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

#if os(iOS)
import UIKit
public typealias PlatformCollectionView = UICollectionView
public typealias PlatformCompositionalLayout = UICollectionViewCompositionalLayout
public typealias PlatformCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration
public typealias PlatformCollectionLayoutSectionOrthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
#else
import AppKit
public typealias PlatformCollectionView = NSCollectionView
public typealias PlatformCompositionalLayout = NSCollectionViewCompositionalLayout
public typealias PlatformCompositionalLayoutConfiguration = NSCollectionViewCompositionalLayoutConfiguration
public typealias PlatformCollectionLayoutSectionOrthogonalScrollingBehavior = NSCollectionLayoutSectionOrthogonalScrollingBehavior
#endif


