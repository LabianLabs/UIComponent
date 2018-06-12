//
//  Operators.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/9/18.
//

import Foundation
import Eureka

@discardableResult
public func <<< (left: Children, right:Component) -> Children {
    left.append(right)
    return left
}

//public func == (lhs: Component, rhs: Component) -> Bool {
//    return true
//}
