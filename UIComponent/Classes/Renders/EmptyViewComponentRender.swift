//
//  ViewRender.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/12/18.
//

import Foundation
import UIKit
extension EmptyViewComponent: UIKitRenderable{
    public func renderUIKit() -> UIKitRenderTree {
        let view = UIView()
        self.applyBaseAttributes(to: view)
        let children = renderChildren(in: view)
        return .node(self, view, children)
    }
    
    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {
        
        guard let newComponent = newComponent as? EmptyViewComponent else { fatalError() }
        
        guard case let .node(_, _, childTree) = renderTree else { fatalError() }
        
        var children = childTree
        
        var viewsToInsert: [(index: Int, view: UIView, renderTree: UIKitRenderTree)] = []
        var viewsToRemove: [(index: Int, view: UIView)] = []
        
        if case let .root(changes) = change {
            
            for change in changes {
                
                switch change {
                case let .insert(index, _):
                    let renderTreeEntry = (newComponent.children[index] as! UIKitRenderable).renderUIKit()
                    viewsToInsert.append((index, renderTreeEntry.view, renderTreeEntry))
                case let .remove(index):
                    let childView = children[index].view
                    viewsToRemove.append((index, childView))
                default:
                    break
                }
            }
            
        }
        
        var indexOffset = 0
        
        for insert in viewsToInsert {
            view.insertSubview(insert.view, at: insert.index)
            children.insert(insert.renderTree, at: insert.index)
            
            indexOffset += 1
        }
        
        for remove in viewsToRemove {
            remove.view.removeFromSuperview()
            children.remove(at: remove.index + indexOffset)
            indexOffset -= 1
        }
        return .node(newComponent, view, children)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(self, view)
        }else{
            view.loFillInParent()
        }
    }
    
    private func renderChildren(in parent: UIView)-> [UIKitRenderTree]{
        var childViews: [UIView]
        let childComponents = self.children.compactMap { $0 as? UIKitRenderable }
        let children = childComponents.map { component in
            component.renderUIKit()
        }
        childViews = children.map { $0.view }
        for view in childViews{
            parent.addSubview(view)
        }
        return children
    }
}
