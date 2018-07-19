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

extension StateComponent:UIKitRenderable{
    public func renderUIKit() -> UIKitRenderTree {
        guard let errorComponent = self.errorComponent,
            let dataComponent = self.dataComponent else {fatalError()}
        let view = StateComponentView()
        if isLoading(){
            if let loadingTree = (self.loadingComponent as? UIKitRenderable)?.renderUIKit(){
                view.loadingTree = loadingTree
                self.children.append(self.loadingComponent!)
            }
        }else if isError(){
            if let errorTree = (errorComponent as? UIKitRenderable)?.renderUIKit(){
                view.errorTree = errorTree
                self.children.append(self.errorComponent!)
            }
        }else{
            if isEmpty(){
                if let emptyTree = (self.emptyComponent as? UIKitRenderable)?.renderUIKit(){
                    view.emptyTree = emptyTree
                    self.children.append(self.emptyComponent!)
                }
            }else{
                if let dataTree = (dataComponent as? UIKitRenderable)?.renderUIKit(){
                    view.dataTree = dataTree
                    self.children.append(self.dataComponent!)
                }
            }
        }
        return .leaf(self, view)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let stateComp = newComponent as? StateComponent,
            let cmpView = view as? StateComponentView  else {fatalError()}
        if stateComp.isLoading(){
            if cmpView.loadingTree == nil{
                if let loadingTree = (stateComp.loadingComponent as? UIKitRenderable)?.renderUIKit(){
                    cmpView.loadingTree = loadingTree
                    stateComp.children.append(loadingTree.renderable as! Component)
                }
            }
            else {
                if let loadingComp = (stateComp.loadingComponent as? UIKitRenderable){
                    loadingComp.updateUIKit(cmpView.loadingTree!.view, change: change, newComponent: loadingComp, renderTree: cmpView.loadingTree!)
                }
            }
        }else if stateComp.isError(){
            if cmpView.errorTree == nil{
                if let errorTree = (stateComp.errorComponent as? UIKitRenderable)?.renderUIKit(){
                    cmpView.errorTree = errorTree
                    stateComp.children.append(errorTree.renderable as! Component)
                }
            }
            else {
                if let errorComp = (stateComp.errorComponent as? UIKitRenderable){
                    errorComp.updateUIKit(cmpView.errorTree!.view, change: change, newComponent: errorComp, renderTree: cmpView.errorTree!)
                }
            }
        }else{
            if stateComp.isEmpty(){
                if cmpView.emptyTree == nil{
                    if let emptyTree = (stateComp.emptyComponent as? UIKitRenderable)?.renderUIKit(){
                        cmpView.emptyTree = emptyTree
                        stateComp.children.append(emptyTree.renderable as! Component)
                    }
                }
                else {
                    if let emptyComp = (stateComp.emptyComponent as? UIKitRenderable){
                        emptyComp.updateUIKit(cmpView.emptyTree!.view, change: change, newComponent: emptyComp, renderTree: cmpView.emptyTree!)
                    }
                }
            }else{
                if cmpView.dataTree == nil{
                    if let dataTree = (stateComp.dataComponent as? UIKitRenderable)?.renderUIKit(){
                        cmpView.dataTree = dataTree
                        stateComp.children.append(dataTree.renderable as! Component)
                    }
                }else{
                    (stateComp.dataComponent as? UIKitRenderable)?.updateUIKit(cmpView.dataTree!.view, change: change, newComponent: stateComp.dataComponent as! UIKitRenderable, renderTree: cmpView.dataTree!)
                }
            }
        }
        return .leaf(newComponent, view)
    }
    
    public func autoLayout(view: UIView) {
        guard let stateView = view as? StateComponentView else {return}
        if let layout = self.layout{
            layout(self, stateView)
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
                    stateView.addSubview(dataView)
                    (stateView.dataTree?.renderable)?.autoLayout(view: dataView)
                }
            }
        }
    }
    
}
