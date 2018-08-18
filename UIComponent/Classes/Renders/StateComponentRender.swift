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
            }
        }else if isError(){
            if let errorTree = (errorComponent as? UIKitRenderable)?.renderUIKit(){
                view.errorTree = errorTree
            }
        }else{
            if isEmpty(){
                if let emptyTree = (self.emptyComponent as? UIKitRenderable)?.renderUIKit(){
                    view.emptyTree = emptyTree
                }
            }else{
                if let dataTree = (dataComponent as? UIKitRenderable)?.renderUIKit(){
                    view.dataTree = dataTree
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
                    (stateComp.loadingComponent as? BaseComponent)?.onRendered?((stateComp.loadingComponent as! BaseComponent), loadingTree.view)
                }
            }
            else {
                if let loadingComp = (stateComp.loadingComponent as? UIKitRenderable){
                    (self.loadingComponent as? UIKitRenderable)?.updateUIKit(cmpView.loadingTree!.view, change: change, newComponent: loadingComp, renderTree: cmpView.loadingTree!)
                    (loadingComp as? BaseComponent)?.onUpdated?((loadingComp as! BaseComponent), cmpView.dataTree!.view)
                }
            }
        }else if stateComp.isError(){
            if cmpView.errorTree == nil{
                if let errorTree = (stateComp.errorComponent as? UIKitRenderable)?.renderUIKit(){
                    cmpView.errorTree = errorTree
                    (stateComp.errorComponent as? BaseComponent)?.onRendered?((stateComp.errorComponent as! BaseComponent), errorTree.view)
                }
            }
            else {
                if let errorComp = (stateComp.errorComponent as? UIKitRenderable){
                    (self.errorComponent as? UIKitRenderable)?.updateUIKit(cmpView.errorTree!.view, change: change, newComponent: errorComp, renderTree: cmpView.errorTree!)
                    (errorComp as? BaseComponent)?.onUpdated?((errorComp as! BaseComponent), cmpView.dataTree!.view)
                }
            }
        }else{
            if stateComp.isEmpty(){
                if cmpView.emptyTree == nil{
                    if let emptyTree = (stateComp.emptyComponent as? UIKitRenderable)?.renderUIKit(){
                        cmpView.emptyTree = emptyTree
                        (stateComp.emptyComponent as? BaseComponent)?.onRendered?((stateComp.emptyComponent as! BaseComponent), emptyTree.view)
                    }
                }
                else {
                    if let emptyComp = (stateComp.emptyComponent as? UIKitRenderable){
                        (self.emptyComponent as? UIKitRenderable)?.updateUIKit(cmpView.emptyTree!.view, change: change, newComponent: emptyComp, renderTree: cmpView.emptyTree!)
                        (emptyComp as? BaseComponent)?.onUpdated?((emptyComp as! BaseComponent), cmpView.dataTree!.view)
                    }
                }
            }else{
                if cmpView.dataTree == nil{
                    if let dataTree = (stateComp.dataComponent as? UIKitRenderable)?.renderUIKit(){
                        cmpView.dataTree = dataTree
                        (stateComp.dataComponent as? BaseComponent)?.onUpdated?((stateComp.dataComponent as! BaseComponent), dataTree.view)
                    }
                }else{
                    (self.dataComponent as? UIKitRenderable)?.updateUIKit(cmpView.dataTree!.view, change: change, newComponent: stateComp.dataComponent as! UIKitRenderable, renderTree: cmpView.dataTree!)
                    (stateComp.dataComponent as? BaseComponent)?.onUpdated?((stateComp.dataComponent as! BaseComponent), cmpView.dataTree!.view)
                }
            }
        }
        return .leaf(stateComp, view)
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

