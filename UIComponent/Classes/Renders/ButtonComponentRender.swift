//
//  ButtonRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension ButtonComponent: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        let button = UIButton(type: .custom)
        button.setTitle(self.title, for: UIControlState())
        button.setTitleColor(.blue, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(onButtonDidTouch), for: UIControlEvents.touchUpInside)
        self.applyBaseAttributes(to: button)
        return .leaf(self, button)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(self, view)
        } else {
            constrain(view) { button in
                button.top == button.superview!.top
                button.left == button.superview!.left
                button.right == button.superview!.right
                button.height == 44
            }
        }
    }
    
    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard let button = view as? UIButton else { fatalError() }
        guard let newComponent = newComponent as? ButtonComponent else { fatalError() }
        button.removeTarget(self, action: #selector(onButtonDidTouch), for: .touchUpInside)
        button.addTarget(newComponent, action: #selector(onButtonDidTouch), for: .touchUpInside)
        button.setTitle(newComponent.title, for: .normal)
        
        return .leaf(newComponent, button)
    }
    
    @objc public func onButtonDidTouch(sender:UIButton){
        self.callbackOnClick?(sender)
    }
}
