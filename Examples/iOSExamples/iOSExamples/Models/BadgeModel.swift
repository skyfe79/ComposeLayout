//
//  BadgeModel.swift
//  iOSExamples
//
//  Created by codingmax on 2024/02/02.
//

import Foundation

struct BadgeModel: Hashable {
    let title: String
    let badgeCount: Int

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
