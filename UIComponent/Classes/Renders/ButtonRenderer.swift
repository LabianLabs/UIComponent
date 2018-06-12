//
//  ButtonRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension Button: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        let button = UIButton(type: .custom)
        button.setTitle(self.title, for: UIControlState())
        button.setTitleColor(.blue, for: UIControlState())
        return .leaf(self, button)
    }
    
    public func autoLayout(view: UIView) {
        self.layout(self, view)
    }
    
}
