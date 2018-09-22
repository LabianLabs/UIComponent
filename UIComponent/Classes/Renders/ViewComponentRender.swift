//
//  ViewComponentRenderer.swift
//  Eureka
//
//  Created by labs01 on 6/10/18.
//

import UIKit

open class UIViewComponent: UIView{
    open var value:Any?
    open func setup(){}
    open func update(){}
}

extension ViewComponent: UIKitRenderable{
    
    public func renderUIKit() -> UIKitRenderTree {
        var view:UIViewComponent?
        if let nibFile = self.nibFile {
            let bundle = Bundle(for: (T.self as AnyClass))
            view = bundle.loadNibNamed(nibFile, owner: nil, options: nil)?.first as? UIViewComponent
        } else{
            view = T() as? UIViewComponent
        }
        if view == nil{
            fatalError()
        }
        self.applyBaseAttributes(to: view!)
        self.config?(view as! T)
        view?.value = self.value
        view?.setup()
        if self.children.count > 0{
            let children = self.renderChildren(in: view!)
            return .node(self, view!, children)
        }
        return .node(self, view!, [UIKitRenderTree]())
    }
    
    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {
        
        guard let newComponent = newComponent as? ViewComponent else { fatalError() }
        guard let nibView = view as? UIViewComponent else { fatalError() }
        if self.children.count > 0{
            return self.updateContainerUIKit(view, change: change, newComponent: newComponent, renderTree: renderTree)
        }
        newComponent.applyBaseAttributes(to: view)
        newComponent.config?(view as! T)
        nibView.value = newComponent.value
        nibView.update()
        return .node(newComponent, nibView, [UIKitRenderTree]())
    }
    
    private func updateContainerUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {
        guard let newComponent = newComponent as? ViewComponent else { fatalError() }
        newComponent.nibFile = self.nibFile
        newComponent.value = self.value
        newComponent.applyBaseAttributes(to: view)
        let children = updateChildren(view: view, change: change, newComponent: newComponent, renderTree: renderTree)        
        return .node(newComponent, view, children)
    }
    
    private func renderChildren(in parent: UIView)-> [UIKitRenderTree]{
        var childViews: [UIView]
        let childComponents = self.children.compactMap { $0 as? UIKitRenderable }
        let children = childComponents.map { component -> UIKitRenderTree in
            let res = component.renderUIKit()
            if let baseCmp =  component as? BaseComponent{
                baseCmp.onRendered?(baseCmp, res.view)
            }
            return res
        }
        childViews = children.map { $0.view }
        for view in childViews{
            parent.addSubview(view)
        }
        return children
    }
    
    public func autoLayout(view: UIView) {
        self.layout?(view)
    }
}


