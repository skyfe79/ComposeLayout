//
//  DevViewController.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import UIKit
import ComposeLayout

class MyBackgroundView: UICollectionReusableView {
    override var reuseIdentifier: String? {
        "blue"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .blue
    }
}

class MyBackgroundView2: UICollectionReusableView {
    override var reuseIdentifier: String? {
        "red"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .red
    }
}

class MyBackgroundView3: UICollectionReusableView {
    override var reuseIdentifier: String? {
        "yellow"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .yellow
    }
}


class DevViewController: UIViewController {
//    lazy var myLayout = {
//        ComposeLayout { environment in
//            Section(id: UUID()) {
//                if 1 == 0 {
//                    HGroup {
//                        Item(width: .absolute(10), height: .absolute(10))
//                        VGroup {
//                            Item(width: .absolute(10), height: .absolute(10))
//                        }
//                    }
//                } else {
//                    VGroup {
//                        for _ in 1...10 {
//                            Item(width: .absolute(10), height: .absolute(10))
//                        }
//                    }
//                }
//            }
//            Section(id: UUID()) {
//                if #available(iOS 13, *) {
//                    VGroup {
//                        Item(width: .absolute(10), height: .absolute(10))
//                    }
//                } else {
//                    HGroup {
//                        Item(width: .absolute(10), height: .absolute(10))
//                    }
//                }
//            }
//            Section(id: UUID()) {
//                HGroup {
//                    Item(width: .absolute(10), height: .absolute(10))
//                    Item(width: .absolute(10), height: .absolute(10))
//                    VGroup {
//                        Item(width: .absolute(10), height: .absolute(10))
//                        HGroup {
//                            Item(width: .absolute(10), height: .absolute(10))
//                            Item(width: .absolute(10), height: .absolute(10))
//                            VGroup {
//                                for _ in 1...10 {
//                                    Item(width: .absolute(10), height: .absolute(10))
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .build()
//    }()
    
    func testSection(environment: NSCollectionLayoutEnvironment) -> Section {
        Section(id: UUID()) {
            HGroup {
                Item()
                    .width(.fractionalWidth(0.5))
                    .height(.fractionalHeight(1.0))
            }
            .height(.absolute(200))
        }
        .orthogonalScrollingBehavior(.continuous)
    }
    
    func firstSection(environment: NSCollectionLayoutEnvironment) -> Section {
        Section(id: UUID()) {
            HGroup {
                Item()
                    .width(.fractionalWidth(0.5))
                    .height(.fractionalHeight(1.0))
                VGroup {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(0.5))
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(0.5))
                        
                        
                }
                .interItemSpacing(.fixed(1))
                .width(.fractionalWidth(0.5))
                .height(.fractionalHeight(1.0))
                
            }
            .interItemSpacing(.fixed(1))
            .height(.absolute(100))
        }
    }
    
    func secondSection(environment: NSCollectionLayoutEnvironment) -> Section {
        Section(id: UUID()) {
            HGroup {
                Item()
                    .width(.fractionalWidth(0.5))
                    .height(.fractionalHeight(1.0))
                    .supplementaryItems {
                        SupplementaryItem(elementKind: "red")
                            .width(.absolute(50))
                            .height(.absolute(50))
                            .containerAnchor(edges: [.top, .trailing])
                    }
                VGroup {
                    for _ in 0..<10 {
                        Item()
                            .width(.fractionalWidth(1.0))
                            .height(.fractionalHeight(0.1))
                    }
                }
                .interItemSpacing(.fixed(1))
                .width(.fractionalWidth(0.5))
                .height(.fractionalHeight(1.0))
                
            }
            .interItemSpacing(.fixed(1))
            .height(environment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? .absolute(300) : .absolute(100))
            
        }
        .interGroupSpacing(1)
        .contentInsets(leading: 5, top: 5, trailing: 5, bottom: 5)
        .contentInsets(reference: .automatic)
        .supplementaryContentInsets(reference: .layoutMargins)
        .boundarySupplementaryItems {
            BoundarySupplementaryItem(elementKind: "yellow")
                .width(.fractionalWidth(1.0))
                .height(.fractionalHeight(0.3))
                .alignment(.top)
                .pinToVisibleBounds(true)
                .zIndex(Int.max)
        }
        .decorationItems {
            DecorationItem(elementKind: "blue-background")
        }
    }
    
    lazy var layout:UICollectionViewCompositionalLayout = {
        ComposeLayout { environment in
            self.testSection(environment: environment)
            self.firstSection(environment: environment)
            self.secondSection(environment: environment)
        }
        .register(MyBackgroundView.self, forDecorationViewOfKind: "blue-background")
        .build()
    }()
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(MyBackgroundView2.self, forSupplementaryViewOfKind: "red", withReuseIdentifier: "red")
        collectionView.register(MyBackgroundView3.self, forSupplementaryViewOfKind: "yellow", withReuseIdentifier: "yellow")

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        // AutoLayout CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension DevViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 51
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0.5...1.0), green: CGFloat.random(in: 0.5...1.0), blue: CGFloat.random(in: 0.5...1.0), alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
    }
}

