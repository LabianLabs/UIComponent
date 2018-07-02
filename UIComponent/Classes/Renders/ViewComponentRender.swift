//
//  ViewComponentRenderer.swift
//  Eureka
//
//  Created by labs01 on 6/10/18.
//

import UIKit

open class UIViewComponent: UIView{
    public var value:Any?
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
        //self.render?(view as! T)
        view?.value = self.value
        view?.setup()
        if self.children.count > 0{
            let children = self.renderChildren(in: view!)
            return .node(self, view!, children)
        }
        return .leaf(self, view!)
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
        } else{
            nibView.value = newComponent.value
            nibView.update()
        }
        return .leaf(newComponent, nibView)
    }
    
    private func updateContainerUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {
        guard let newComponent = newComponent as? ViewComponent else { fatalError() }
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

    public func autoLayout(view: UIView) {
        self.layout?(self, view)
    }
}


