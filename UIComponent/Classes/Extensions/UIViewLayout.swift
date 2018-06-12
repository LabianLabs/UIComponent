//
//  UIViewLayout.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation
import UIKit

extension UIView /*AutoLayout*/{
    @discardableResult
    public func loFillInParent()->UIView{
        constrain(self){ view in
            view.left == view.superview!.left
            view.top == view.superview!.top
            view.width == view.superview!.width
            view.height == view.superview!.height
        }
        return self
    }
}
