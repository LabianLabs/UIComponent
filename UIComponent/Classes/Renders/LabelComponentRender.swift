//
//  LabelRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/26/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension LabelComponent {
    public func renderUIKit() -> UIKitRenderTree {
        let alignText:((TextAlignment) -> NSTextAlignment) = { align in
            switch align {
                case .left:
                    return NSTextAlignment.left
                case .right:
                    return NSTextAlignment.right
                default:
                    return NSTextAlignment.center
            }
        }
        let label = UILabel()
        label.text = self.text
        label.numberOfLines = 0
        label.textColor = UIColor(rgba: self.textColor.hexString)
        self.applyBaseAttributes(to: label)
        let fontName = self.fontName ?? label.font.fontName
        let fontSize = self.fontSize > 0 ? self.fontSize : label.font.pointSize
        label.font = UIFont(name: fontName, size: fontSize)
        label.textAlignment = alignText(self.textAlignment)
        if self.fontStyle == FontStyle.bold{
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        }
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
        newComponent.applyBaseAttributes(to: view)
        return .leaf(newComponent, label)
    }

    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(view)
        }
    }
}
