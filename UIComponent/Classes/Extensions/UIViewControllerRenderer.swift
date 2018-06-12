//
//  UIViewControllerRenderer.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation

extension UIViewController/*Render*/{
    struct Keys{
        static var renderViewKey:UInt=0
    }
    
    public var renderView:RenderView{
        get {
            if let value = objc_getAssociatedObject(self, &Keys.renderViewKey) {
                return value as! RenderView
            }
            fatalError()
        }
        set {
            objc_setAssociatedObject(self, &Keys.renderViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
