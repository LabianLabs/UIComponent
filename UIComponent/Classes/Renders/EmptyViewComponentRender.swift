//
//  ViewRender.swift
//  UIComponent
//
//  Created by labs01 on 6/12/18.
//

import Foundation
import UIKit
extension EmptyViewComponent{
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
        newComponent.applyBaseAttributes(to: view)
        let children = updateChildren(view: view, change: change, newComponent: newComponent, renderTree: renderTree)
        return .node(newComponent, view, children)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(view)
        }else{
            view.loFillInParent()
        }
    }
    
    private func renderChildren(in parent: UIView)-> [UIKitRenderTree]{
        var childViews: [UIView]
        let childComponents = self.children.compactMap { $0 as? UIKitRenderable }
        var trees = [UIKitRenderTree]()
        for child in childComponents{
            let tree = child.renderUIKit()
            if let baseCmp = (child as? BaseComponent){
                baseCmp.onRendered?(baseCmp, tree.view)
            }
            trees.append(tree)
        }
        childViews = trees.map { $0.view }
        for view in childViews{
            parent.addSubview(view)
        }
        return trees
    }
}
