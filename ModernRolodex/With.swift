//
//  With.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/5/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import Foundation

@discardableResult
internal func with<T: AnyObject>(_ this: T, update: (T) throws -> Void) rethrows -> T {
    try update(this)
    return this
}
