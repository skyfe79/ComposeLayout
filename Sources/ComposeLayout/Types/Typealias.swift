//
//  Typealias.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

#if os(iOS)
  import UIKit

  /// A typealias for `UICollectionView` to abstract platform-specific collection view classes.
  public typealias PlatformCollectionView = UICollectionView
  /// A typealias for `UICollectionViewCompositionalLayout` to abstract platform-specific compositional layout classes.
  public typealias PlatformCompositionalLayout = UICollectionViewCompositionalLayout
  /// A typealias for `UICollectionViewCompositionalLayoutConfiguration` to abstract platform-specific compositional layout configuration classes.
  public typealias PlatformCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration
  /// A typealias for `UICollectionLayoutSectionOrthogonalScrollingBehavior` to abstract platform-specific orthogonal scrolling behavior enums.
  public typealias PlatformCollectionLayoutSectionOrthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
#else
  import AppKit

  /// A typealias for `NSCollectionView` to abstract platform-specific collection view classes.
  public typealias PlatformCollectionView = NSCollectionView
  /// A typealias for `NSCollectionViewCompositionalLayout` to abstract platform-specific compositional layout classes.
  public typealias PlatformCompositionalLayout = NSCollectionViewCompositionalLayout
  /// A typealias for `NSCollectionViewCompositionalLayoutConfiguration` to abstract platform-specific compositional layout configuration classes.
  public typealias PlatformCompositionalLayoutConfiguration = NSCollectionViewCompositionalLayoutConfiguration
  /// A typealias for `NSCollectionLayoutSectionOrthogonalScrollingBehavior` to abstract platform-specific orthogonal scrolling behavior enums.
  public typealias PlatformCollectionLayoutSectionOrthogonalScrollingBehavior = NSCollectionLayoutSectionOrthogonalScrollingBehavior
#endif
