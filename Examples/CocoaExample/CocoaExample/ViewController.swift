//
//  ViewController.swift
//  CocoaExample
//
//  Created by codingmax on 2024/01/31.
//

import Cocoa
import ComposeLayout

class MyCollectionViewItem: NSCollectionViewItem {
    override func loadView() {
        self.view = NSView()
    }
}

class MyBackgroundView: NSView {
    static var reuseIdentifier: String? {
        "blue"
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.blue.setFill()
        dirtyRect.fill()
    }
}

class MyBackgroundView2: NSView {
    static var reuseIdentifier: String? {
        "red"
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.red.setFill()
        dirtyRect.fill()
    }
}

class MyBackgroundView3: NSView {
    static var reuseIdentifier: String? {
        "yellow"
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.yellow.setFill()
        dirtyRect.fill()
    }
}

class ViewController: NSViewController {
    
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
                    .contentInsets(leading: 1, top: 1, trailing: 1, bottom: 1)
                VGroup {
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(0.5))
                        .contentInsets(leading: 1, top: 1, trailing: 1, bottom: 1)
                    Item()
                        .width(.fractionalWidth(1.0))
                        .height(.fractionalHeight(0.5))
                        .contentInsets(leading: 1, top: 1, trailing: 1, bottom: 1)
                }
                .width(.fractionalWidth(0.5))
                .height(.fractionalHeight(1.0))
                
            }
            .width(.fractionalWidth(1.0))
            .height(.absolute(300))
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
                            .containerAnchor(edges: [.top, .leading])
                            
                    }
                    .contentInsets(leading: 1, top: 1, trailing: 1, bottom: 1)
                VGroup {
                    for _ in 0..<10 {
                        Item()
                            .width(.fractionalWidth(1.0))
                            .height(.fractionalHeight(0.1))
                            .contentInsets(leading: 1, top: 1, trailing: 1, bottom: 1)
                    }
                }
                
                .width(.fractionalWidth(0.5))
                .height(.fractionalHeight(1.0))
                
            }
            .height(.absolute(300))
            
        }
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
    
    lazy var layout: NSCollectionViewCompositionalLayout = {
        let config = NSCollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        return ComposeLayout { environment in
            self.testSection(environment: environment)
            self.firstSection(environment: environment)
            self.secondSection(environment: environment)
        }
        .register(MyBackgroundView.self, forDecorationViewOfKind: "blue-background")
        .configuration(config)
        .build()
    }()
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = self.layout
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("Cell"))
        collectionView.register(MyBackgroundView2.self, forSupplementaryViewOfKind: NSCollectionView.SupplementaryElementKind("red"), withIdentifier: NSUserInterfaceItemIdentifier("red"))
        collectionView.register(MyBackgroundView3.self, forSupplementaryViewOfKind: NSCollectionView.SupplementaryElementKind("yellow"), withIdentifier: NSUserInterfaceItemIdentifier("yellow"))
    }
}

extension ViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("Cell"), for: indexPath)
        item.view.wantsLayer = true
        item.view.layer?.backgroundColor = NSColor(calibratedRed: CGFloat.random(in: 0.5...1.0), green: CGFloat.random(in: 0.5...1.0), blue: CGFloat.random(in: 0.5...1.0), alpha: 1.0).cgColor
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView,
                        viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind,
                        at indexPath: IndexPath) -> NSView {

        if kind == NSCollectionView.SupplementaryElementKind("red") {
            return collectionView.makeSupplementaryView(ofKind: kind,
                                                            withIdentifier: NSUserInterfaceItemIdentifier("red"),
                                                            for: indexPath)
        } else if kind == NSCollectionView.SupplementaryElementKind("yellow") {
            return collectionView.makeSupplementaryView(ofKind: kind,
                                                            withIdentifier: NSUserInterfaceItemIdentifier("yellow"),
                                                            for: indexPath) as! MyBackgroundView3
        }
        return NSView()
    }
}
