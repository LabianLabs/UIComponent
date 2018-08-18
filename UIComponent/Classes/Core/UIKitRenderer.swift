//
//  UIKitRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

public typealias LayoutBlock = (_ view:UIView) -> Void

/// A view that can render a `ComponentContainer`
public final class RenderView: Renderer {

    public var view = UIView()
    
    public var container: ComponentRenderable?

    public var lastRootComponent: ComponentContainer?
    
    public var lastRenderTree: UIKitRenderTree?
    
    public init(container: ComponentRenderable) {
        var container = container
        self.container = container
        self.container?.renderView = self.view
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
                self.callbackOnUpdated(renderTree: renderTree)
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
                self.callbackOnRendered(renderTree: renderTree)
                applyLayout(renderTree: renderTree)
            }
        }
    }

    
    private func callbackOnRendered(renderTree: UIKitRenderTree){
        switch renderTree {
        case let (.node(component, view, trees)):
            if  let c = (component as? BaseComponent){
                c.onRendered?(c, view)
            }
            for tree in trees{
                callbackOnRendered(renderTree: tree)
            }
            break
        case let (.leaf(component, view)):
            if  let c = (component as? BaseComponent){
                c.onRendered?(c, view)
            }
            break
        default:
            break
            
        }
    }
    
    private func callbackOnUpdated(renderTree: UIKitRenderTree){
        switch renderTree {
        case let (.node(component, view, trees)):
            if  let c = (component as? BaseComponent){
                c.onUpdated?(c, view)
            }
            for tree in trees{
                callbackOnUpdated(renderTree: tree)
            }
            break
        case let (.leaf(component, view)):
            if  let c = (component as? BaseComponent){
                c.onUpdated?(c, view)
            }
            break
        default:
            break
            
        }
    }
}


public protocol UIKitRenderable {
    func renderUIKit() -> UIKitRenderTree
    func autoLayout(view:UIView)
    // Note: Right now it is not possible to return a new view instance from this method. This
    // new instance would not be inserted into the view hierarchy!
    @discardableResult
    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree
}

public extension UIKitRenderable {
    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        return .leaf(self, view)
    }
}
