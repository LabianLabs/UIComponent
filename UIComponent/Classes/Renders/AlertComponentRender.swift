////  AlertComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 7/14/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIKit

extension AlertComponent: UIKitRenderable{
    public func renderUIKit() -> UIKitRenderTree {
        self.alert = alert(component:self)
        self.controller?.present(self.alert!, animated: true, completion: nil)
        return .leaf(self, UIView())
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let component = newComponent as? AlertComponent else { fatalError()}
        component.alert = alert(component:component)
        component.controller?.present(component.alert!, animated: true, completion: nil)
        return .leaf(component, view)
    }
    
    public func autoLayout(view: UIView) {}
    
    private func alert(component:AlertComponent)-> UIAlertController{
        self.alert?.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: component.title, message: component.message, preferredStyle: UIAlertControllerStyle.alert)
        if let okTitle = component.okButtonTitle{
            alert.addAction((UIAlertAction(title: okTitle, style: .default, handler: { (action) -> Void in
                component.callbackOnOk?()
                alert.dismiss(animated: true, completion: nil)
            })))
        }
        if let cancleTitle = component.cancelButtonTitle{
            alert.addAction((UIAlertAction(title: cancleTitle, style: .default, handler: { (action) -> Void in
                component.callbackOnCancel?()
                alert.dismiss(animated: true, completion: nil)
            })))
        }
        return alert
    }
}
