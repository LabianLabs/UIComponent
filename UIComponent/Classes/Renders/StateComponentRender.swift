////  LoadingComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 7/14/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIKit

class StateComponentView:UIView{
    var loadingTree:UIKitRenderTree?
    var errorTree:UIKitRenderTree?
    var emptyTree:UIKitRenderTree?
    var dataTree:UIKitRenderTree?
}

public func recursiveUpdate(renderTree: UIKitRenderTree, newComponent: UIKitRenderable){
    renderTree.renderable.updateUIKit(renderTree.view, change: Changes.update, newComponent: newComponent, renderTree: renderTree)
    (renderTree.renderable as? BaseComponent)?.onUpdated?(newComponent as! BaseComponent, renderTree.view)
    switch renderTree {
        case let (.node(_, _, children)):
            for i in 0..<children.count{
                let childComp = (newComponent as! ComponentContainer).children[i] as! UIKitRenderable
                recursiveUpdate(renderTree: children[i], newComponent: childComp)
            }
            break
        default:
            break
    }
}

extension StateComponent:UIKitRenderable{
    
    public func renderUIKit() -> UIKitRenderTree {
        
        guard let errorComponent = self.errorComponent,
            let dataComponent = self.dataComponent else {fatalError()}
        let view = StateComponentView()
        var children = [UIKitRenderTree]()
        if isLoading(){
            if let loadingTree = (self.loadingComponent as? UIKitRenderable)?.renderUIKit(){
                view.loadingTree = loadingTree
                children.append(loadingTree)
            }
        }else if isError(){
            if let errorTree = (errorComponent as? UIKitRenderable)?.renderUIKit(){
                view.errorTree = errorTree
                children.append(errorTree)
            }
        }else{
            if isEmpty(){
                if let emptyTree = (self.emptyComponent as? UIKitRenderable)?.renderUIKit(){
                    view.emptyTree = emptyTree
                    children.append(emptyTree)
                }
            }else{
                if let dataTree = (dataComponent as? UIKitRenderable)?.renderUIKit(){
                    view.dataTree = dataTree
                    children.append(dataTree)
                }
            }
        }
        return .leaf(self, view)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let stateComp = newComponent as? StateComponent,
            let cmpView = view as? StateComponentView  else {fatalError()}
        var children  = [UIKitRenderTree]()
        if stateComp.isLoading(){
            if cmpView.loadingTree == nil{
                if let loadingTree = (stateComp.loadingComponent as? UIKitRenderable)?.renderUIKit(){
                    cmpView.loadingTree = loadingTree
                    (stateComp.loadingComponent as? BaseComponent)?.onRendered?((stateComp.loadingComponent as! BaseComponent), loadingTree.view)
                }
            }
            else {
                recursiveUpdate(renderTree: cmpView.loadingTree!, newComponent: stateComp.loadingComponent as! UIKitRenderable)
            }
            children.append(cmpView.loadingTree!)
        }else if stateComp.isError(){
            if cmpView.errorTree == nil{
                if let errorTree = (stateComp.errorComponent as? UIKitRenderable)?.renderUIKit(){
                    cmpView.errorTree = errorTree
                    (stateComp.errorComponent as? BaseComponent)?.onRendered?((stateComp.errorComponent as! BaseComponent), errorTree.view)
                }
            }
            else {
                recursiveUpdate(renderTree: cmpView.errorTree!, newComponent: stateComp.errorComponent as! UIKitRenderable)
            }
            children.append(cmpView.errorTree!)
        }else{
            if stateComp.isEmpty(){
                if cmpView.emptyTree == nil{
                    if let emptyTree = (stateComp.emptyComponent as? UIKitRenderable)?.renderUIKit(){
                        cmpView.emptyTree = emptyTree
                        (stateComp.emptyComponent as? BaseComponent)?.onRendered?((stateComp.emptyComponent as! BaseComponent), emptyTree.view)
                    }
                }
                else {
                   recursiveUpdate(renderTree: cmpView.emptyTree!, newComponent: stateComp.emptyComponent as! UIKitRenderable)
                }
                children.append(cmpView.emptyTree!)
            }else{
                if cmpView.dataTree == nil{
                    if let dataTree = (stateComp.dataComponent as? UIKitRenderable)?.renderUIKit(){
                        cmpView.dataTree = dataTree
                        (stateComp.dataComponent as? BaseComponent)?.onUpdated?((stateComp.dataComponent as! BaseComponent), dataTree.view)
                    }
                }else{
                    recursiveUpdate(renderTree: cmpView.dataTree!, newComponent: stateComp.dataComponent as! UIKitRenderable)
                }
                children.append(cmpView.dataTree!)
            }
        }
        return .node(stateComp, view, children)
    }
    
    public func autoLayout(view: UIView) {
        guard let stateView = view as? StateComponentView else {return}
        if let layout = self.layout{
            layout(stateView)
        }else{
            constrain(stateView){ v in
                v.top  == v.superview!.top
                v.leading == v.superview!.leading
                v.trailing == v.superview!.trailing
                v.width == v.superview!.width
            }
        }
        // Clear all sub view
        _ = stateView.subviews.map({$0.removeFromSuperview()})
        if isLoading(){
            if let loadingView = stateView.loadingTree?.view{
                stateView.addSubview(loadingView)
                (stateView.loadingTree?.renderable)?.autoLayout(view: loadingView)
            }
        }else if isError(){
            if let errorView = stateView.errorTree?.view{
                stateView.addSubview(errorView)
                (stateView.errorTree?.renderable)?.autoLayout(view: errorView)
            }
        }else{
            if isEmpty(){
                if let emptyView = stateView.emptyTree?.view{
                    stateView.addSubview(emptyView)
                    (stateView.emptyTree?.renderable)?.autoLayout(view: emptyView)
                }
            }else{
                if let dataView = stateView.dataTree?.view{
                    dataView.removeFromSuperview()
                    stateView.addSubview(dataView)
                    (stateView.dataTree?.renderable)?.autoLayout(view: dataView)
                }
            }
        }
    }
    
}

