//
//  File.swift
//  
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

@discardableResult
internal func mutable<T>(_ value: T, modifier: (inout T) -> Void) -> T {
    var mutableValue = value
    modifier(&mutableValue)
    return mutableValue
}

