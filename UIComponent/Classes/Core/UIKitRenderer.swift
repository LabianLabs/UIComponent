//
//  UIKitRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

public typealias LayoutBlock = (_ component:Component,_ view:UIView) -> Void

/// A view that can render a `ComponentContainer`
public final class RenderView: Renderer {

    public var view = UIView()
    public var viewsByTag:[String:UIView] = [:]
    public var container: ComponentRenderable

    public var lastRootComponent: ComponentContainer?
    public var lastRenderTree: UIKitRenderTree?
    
    private init(container: ComponentRenderable) {
        var container = container
        self.container = container
        container.renderer = self
    }

    public static func render(container: ComponentRenderable, in controller: UIViewController){
        let render = RenderView(container: container)
        controller.renderView = render
        controller.view.addSubview(render.view)
        render.view.loFillInParent()
    }
    
    public func renderComponent(_ component: ComponentContainer, animated: Bool) {
        defer {
            // When leaving this function, store the new component
            // as the `lastRootComponent`.
            self.lastRootComponent = component
        }

        // If we have an existing root component, calculate diffs instead of rendering from scratch
        if let lastRootComponent = self.lastRootComponent, let lastRenderTree = lastRenderTree {
            // Calculate the difference between old and new component tree
            let reconcilerResults = diffChanges(lastRootComponent, newTree: component)

            // Wrap the UIKit updates into a closure
            let updates: () -> UIKitRenderTree = {
                applyReconcilation(
                    lastRenderTree,
                    changeSet: reconcilerResults,
                    newComponent: component as! UIKitRenderable
                )
            }

            // Decide wheter or not to perform the updates animated
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.lastRenderTree = updates()
                }) 
            } else {
                self.lastRenderTree = updates()
            }
            if let renderTree = self.lastRenderTree{
                updateRenderTreeInfo(renderView: self, renderTree: renderTree)
                applyLayout(renderTree: renderTree)
            }
        } else {
            // Perform a full render pass
            if let renderTree = (component as? UIKitRenderable)?.renderUIKit() {
                self.view.subviews.forEach {
                    $0.removeFromSuperview()
                }
                self.lastRenderTree = renderTree
                self.view.addSubview(renderTree.view)                
                updateRenderTreeInfo(renderView: self, renderTree: renderTree)
                applyLayout(renderTree: renderTree)
            }
        }
    }

}


public protocol UIKitRenderable {
    func renderUIKit() -> UIKitRenderTree
    func autoLayout(view:UIView)
    // Note: Right now it is not possible to return a new view instance from this method. This
    // new instance would not be inserted into the view hierarchy!
    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree
}

public extension UIKitRenderable {
    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        return .leaf(self, view)
    }
}
