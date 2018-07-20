////  BaseContainerComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 7/20/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIKit
extension BaseContainerComponent{
    public func updateChildren(view:UIView, change: Changes,
                        newComponent: UIKitRenderable,
                        renderTree: UIKitRenderTree,
                        insertSubview:((UIView,Int)->Void)?=nil,
                        removeSubview:((UIView, Int)->Void)?=nil)->[UIKitRenderTree]{
        
        guard let newComponent = newComponent as? ComponentContainer else { fatalError() }
        
        guard case let .node(_, _, childTree) = renderTree else { fatalError() }
        
        var children = childTree
        
        var viewsToInsert: [(index: Int, view: UIView, renderTree: UIKitRenderTree)] = []
        var viewsToRemove: [(index: Int, view: UIView)] = []
        var viewsToUpdate: [UIKitRenderTree] = children.map({return $0})
        var componentsToUpdate:[Component] = self.children.map({return $0})
        
        if case let .root(changes) = change {
            
            for change in changes {
                
                switch change {
                case let .insert(index, _):
                    let renderTreeEntry = (newComponent.children[index] as! UIKitRenderable).renderUIKit()
                    viewsToInsert.append((index, renderTreeEntry.view, renderTreeEntry))
                case let .remove(index):
                    let childView = children[index].view
                    viewsToRemove.append((index, childView))
                    viewsToUpdate.remove(at: index)
                    componentsToUpdate.remove(at: index)
                default:
                    break
                }
            }
            
        }
        
        var indexOffset = 0
        
        for insert in viewsToInsert {
            if let callback = insertSubview{
                callback(insert.view, insert.index)
            }else{
                view.insertSubview(insert.view, at: insert.index)
            }
            children.insert(insert.renderTree, at: insert.index)
            
            indexOffset += 1
        }
        
        for remove in viewsToRemove {
            if let callback = removeSubview{
                callback(remove.view, remove.index)
            }else{
                remove.view.removeFromSuperview()
            }
            children.remove(at: remove.index + indexOffset)
            indexOffset -= 1
        }
        
        for i in 0 ..< viewsToUpdate.count-1{
            viewsToUpdate[i].renderable.updateUIKit(viewsToUpdate[i].view, change: Changes.update, newComponent: componentsToUpdate[i] as! UIKitRenderable, renderTree: viewsToUpdate[i])
        }
        return children
    }
}
