//
//  Operators.swift
//  UIComponent
//
//  Created by labs01 on 6/9/18.
//

import Foundation

@discardableResult
public func <<< (left: Children, right:Component) -> Children {
    left.append(right)
    return left
}

@discardableResult
public func <<< (left: Children, right:Children) -> Children {
    right.forEach { (c) in
        left.append(c)
    }
    return left
}

//public func == (lhs: Component, rhs: Component) -> Bool {
//    return true
//}
