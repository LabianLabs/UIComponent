////  FloatComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation
struct  FloatComponentVars{
    public var tag:Int?
}

extension FloatComponent: UIKitRenderable {    
    public func renderUIKit() -> UIKitRenderTree {
        var view:UIView?
        if let nibFile = self.nibFile {
            let bundle = Bundle(for: (T.self as AnyClass))
            view = bundle.loadNibNamed(nibFile, owner: nil, options: nil)?.first as? UIView
        } else{
            view = T() as? UIView
        }
        if view == nil{
            fatalError()
        }
        self.applyBaseAttributes(to: view!)
        self.render?(view as! T)
        return .leaf(self, view!)
    }
    
    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard let newComponent = newComponent as? FloatComponent<T> else {fatalError()}
        newComponent.applyBaseAttributes(to: view)
        return .leaf(newComponent, view)
    }
    
    public func autoLayout(view: UIView) {
        moveViewToWindow(view)
        if let layout = self.layout{
            layout(view)
        }else{
            constrain(view){ v in
                v.bottom == v.superview!.bottom
                v.width == v.superview!.width
                v.left == v.superview!.left
                v.right == v.superview!.right
            }
        }
    }
    
    internal func destroy(){
        if let window :UIWindow = UIApplication.shared.keyWindow{
            window.viewWithTag(self.vars.tag!)?.removeFromSuperview()
        }
    }
    
    private func moveViewToWindow(_ view:UIView){
        view.removeFromSuperview()
        self.vars.tag = Int(arc4random_uniform(999999999) + 1)
        view.tag = self.vars.tag!
        if let window :UIWindow = UIApplication.shared.keyWindow{
            window.addSubview(view)
        }
    }
}
