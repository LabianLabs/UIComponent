//
//  SegmentComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 6/12/18.
//

import Foundation
import UIKit

extension SegmentComponent: UIKitRenderable{
    public func renderUIKit() -> UIKitRenderTree {
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = self.selectedIndex
        segment.addTarget(self, action: #selector(onSemgentValueChange), for: UIControlEvents.valueChanged)
        applyBaseAttributes(to: segment)
        return .leaf(self, segment)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let segment = view as? UISegmentedControl else {fatalError()}
        guard let component = newComponent as? SegmentComponent else {fatalError()}
        segment.removeTarget(self, action: #selector(onSemgentValueChange), for: UIControlEvents.valueChanged)
        segment.addTarget(newComponent, action: #selector(onSemgentValueChange), for: UIControlEvents.valueChanged)
        component.applyBaseAttributes(to: view)
        return .leaf(newComponent, view)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(view)
        } else {
            view.loFillInParent()
        }
    }
}

extension SegmentComponent{
    @objc func onSemgentValueChange(sender:UISegmentedControl){
        self.callbackOnSelectedChanged?(sender.selectedSegmentIndex)
    }
}
