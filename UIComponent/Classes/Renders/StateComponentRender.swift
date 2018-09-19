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
    var lastLoadingComponent:ComponentContainer?
    var lastErrorComponent:ComponentContainer?
    var lastDataComponent:ComponentContainer?
    var lastEmptyComponent:ComponentContainer?
}

extension StateComponent:UIKitRenderable{
    
    public func renderUIKit() -> UIKitRenderTree {
        let view = StateComponentView()
        if isLoading(){
            renderLoading(view: view)
        }else if isError(){
            renderError(view: view)
        }else{
            if isEmpty(){
                renderError(view: view)
            }else{
                renderData(view: view)
            }
        }
        return .leaf(self, view)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let stateComp = newComponent as? StateComponent,
            let cmpView = view as? StateComponentView  else {fatalError()}
        if stateComp.isLoading(){
            if cmpView.loadingTree == nil{
                renderLoading(view: cmpView)
            }
            else if let loading = stateComp.loadingComponent{
                updateLoading(view: cmpView, newComponent: loading)
            }
        }else if stateComp.isError(){
            if cmpView.errorTree == nil{
                renderError(view: cmpView)
            }
            else if let error = stateComp.errorComponent{
                updateError(view: cmpView, newComponent: error)
            }
        }else{
            if stateComp.isEmpty(){
                if cmpView.emptyTree == nil{
                    renderEmpty(view: cmpView)
                }
                else if let empty = stateComp.emptyComponent{
                    updateEmpty(view: cmpView, newComponent: empty)
                }
            }else{
                if cmpView.dataTree == nil{
                    renderData(view: cmpView)
                }
                else if let data = stateComp.dataComponent{
                    updateData(view: cmpView, newComponent: data)
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
    
    
    private func renderError(view:StateComponentView){
        view.errorTree = (errorComponent as? UIKitRenderable)?.renderUIKit()
        view.lastErrorComponent = errorComponent
        callbackOnRendered(renderTree: view.errorTree!)
    }
    
    private func renderLoading(view:StateComponentView){
        view.loadingTree = (self.loadingComponent as? UIKitRenderable)?.renderUIKit()
        view.lastLoadingComponent = self.loadingComponent
        callbackOnRendered(renderTree: view.loadingTree!)
    }
    private func renderEmpty(view:StateComponentView){
        view.emptyTree = (self.emptyComponent as? UIKitRenderable)?.renderUIKit()
        view.lastEmptyComponent = self.emptyComponent
        callbackOnRendered(renderTree: view.emptyTree!)
    }
    
    private func renderData(view:StateComponentView){
        view.dataTree = (dataComponent as? UIKitRenderable)?.renderUIKit()
        view.lastDataComponent = self.dataComponent
        callbackOnRendered(renderTree: view.dataTree!)
    }
    
    private func updateLoading(view:StateComponentView, newComponent:ComponentContainer){
        if let last = view.lastLoadingComponent{
            let changes = diffChanges(last, newTree: newComponent)
            view.loadingTree = applyReconcilation(view.loadingTree!, changeSet: changes, newComponent: newComponent as! UIKitRenderable)
            callbackOnUpdated(renderTree: view.loadingTree!)
        }
    }
    
    private func updateError(view:StateComponentView, newComponent:ComponentContainer){
        if let last = view.lastErrorComponent{
            let changes = diffChanges(last, newTree: newComponent)
            view.errorTree = applyReconcilation(view.errorTree!, changeSet: changes, newComponent: newComponent as! UIKitRenderable)
            callbackOnUpdated(renderTree: view.errorTree!)
        }
    }
    
    private func updateEmpty(view:StateComponentView, newComponent:ComponentContainer){
        if let last = view.lastEmptyComponent{
            let changes = diffChanges(last, newTree: newComponent)
            view.emptyTree = applyReconcilation(view.emptyTree!, changeSet: changes, newComponent: newComponent as! UIKitRenderable)
            callbackOnUpdated(renderTree: view.emptyTree!)
        }
    }
    
    private func updateData(view:StateComponentView, newComponent:ComponentContainer){
        if let last = view.lastDataComponent{
            let changes = diffChanges(last, newTree: newComponent)
            view.dataTree = applyReconcilation(view.dataTree!, changeSet: changes, newComponent: newComponent as! UIKitRenderable)
            callbackOnUpdated(renderTree: view.dataTree!)
        }
    }
    
}

