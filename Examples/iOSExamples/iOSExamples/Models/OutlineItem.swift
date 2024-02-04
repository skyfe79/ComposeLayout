//
//  OutlineItem.swift
//  iOSExamples
//
//  Created by Sungcheol Kim on 2024/02/02.
//

import Foundation
import UIKit

struct OutlineItem: Hashable {
    private let identifier = UUID()
    let title: String
    let subitems: [OutlineItem]
    let outlineViewController: UIViewController.Type?

    init(title: String,
         viewController: UIViewController.Type? = nil,
         subitems: [OutlineItem] = []) {
        self.title = title
        self.subitems = subitems
        self.outlineViewController = viewController
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
