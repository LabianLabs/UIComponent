//
//  AutoLayout.swift
//  UIComponent
//
//  Created by labs01 on 6/10/18.
//

import Foundation

func updateRenderTreeInfo(renderView: RenderView, renderTree:UIKitRenderTree){    
    let findViewByTag = { [weak renderView] (tag:String) -> Any? in
        return renderView?.viewsByTag[tag]
    }
    switch renderTree {
        case let (.node(component, view, trees)):
            if var c = component as? Component{
                if let tag = c.tag{
                    renderView.viewsByTag[tag] = view
                }
                c.viewByTag = findViewByTag
            }
            for tree in trees{
                updateRenderTreeInfo(renderView: renderView, renderTree: tree)
            }
            break
        case let (.leaf(component, view)):
            if var c = component as? Component{
                if let tag = c.tag{
                    renderView.viewsByTag[tag] = view
                }
                c.viewByTag = findViewByTag
            }
            break
        default:
            break
    }
}

func applyLayout(renderTree: UIKitRenderTree){
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
