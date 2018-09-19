//
//  AutoLayout.swift
//  UIComponent
//
//  Created by labs01 on 6/10/18.
//

import Foundation

public func applyLayout(renderTree: UIKitRenderTree){
    switch renderTree {
        case let (.node(component, view, trees)):
            component.autoLayout(view: view)
            for tree in trees{
                applyLayout(renderTree: tree)
            }
            break
        case let (.leaf(component, view)):            
            component.autoLayout(view: view)
            break
        default:
            break
        
    }
}
