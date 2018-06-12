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
        guard let view = view as? UILabel else { fatalError() }
        guard let newComponent = newComponent as? LabelComponent else { fatalError() }

        view.text = newComponent.text

        return .leaf(newComponent, view)
    }

    public func autoLayout( view: UIView) {
        self.layout?(self, view)
    }
}
