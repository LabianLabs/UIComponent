//
//  LabelRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/26/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension LabelComponent: UIKitRenderable {

    public func renderUIKit() -> UIKitRenderTree {
        let label = UILabel()
        label.text = self.text
        label.numberOfLines = 0
        label.textColor = UIColor(rgba: self.textColor.hexString)
        self.applyBaseAttributes(to: label)
        return .leaf(self, label)
    }

    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard let label = view as? UILabel else { fatalError() }
        guard let newComponent = newComponent as? LabelComponent else { fatalError() }

        label.text = newComponent.text

        return .leaf(newComponent, label)
    }

    public func autoLayout( view: UIView) {
        if let layout = self.layout{
            layout(self, view)
        }else{
            view.loFillInParent()
//            constrain(view){ label in
//                label.left == label.superview!.left
//                label.right == label.superview!.right
//                label.top == label.superview!.top
//                label.height == 44
//            }
        }
    }
}
