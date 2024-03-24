//
//  Mutable.swift
//
//
//  Created by Sungcheol Kim on 2024/01/31.
//

import Foundation

/// Applies a modification to a copy of the given value and returns the modified copy.
/// - Parameters:
///   - value: The original value to be copied and modified.
///   - modifier: A closure that takes an `inout` parameter of the value's type and modifies it.
/// - Returns: A modified copy of the original value.
@discardableResult
func mutable<T>(_ value: T, modifier: (inout T) -> Void) -> T {
  var mutableValue = value
  modifier(&mutableValue)
  return mutableValue
}
