////  FollowComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 6/26/18.
//  Copyright © LabianLabs 2015
//

import Foundation

extension FollowComponent: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        let followButton = UIButton(type: .custom)
        followButton.backgroundColor = self.status ? UIColor.green : UIColor.red
        followButton.contentMode = .center
        followButton.setBackgroundImage(self.backgroundImage, for: .normal)
        followButton.addTarget(self, action: #selector(onFollowDidTouch), for: .touchUpInside)
        self.applyBaseAttributes(to: followButton)
        return .leaf(self, followButton)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let followButton = view as? UIButton else {fatalError()}
        guard let newComponent = newComponent  as? FollowComponent else {fatalError()}
        followButton.removeTarget(self, action: #selector(onFollowDidTouch), for: .touchUpInside)
        followButton.addTarget(newComponent, action: #selector(onFollowDidTouch), for: .touchUpInside)
        newComponent.status = !self.status
        followButton.setBackgroundImage(newComponent.backgroundImage, for: .normal)
        return .leaf(newComponent, view)
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
    
    @objc public func onFollowDidTouch(sender:UIButton){
        self.status ? self.callbackOnFollow?(sender) : self.callbackOnUnFollow?(sender)
    }
}
