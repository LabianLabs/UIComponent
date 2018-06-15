//
//  UIViewLayout.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation
import UIKit

extension UIView:Initializable /*Core*/{
    
}

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
    
    @discardableResult
    public func loHeightInParent(_ percentage:CGFloat = 1.0)->UIView{
        constrain(self){ v1 in
            v1.height == v1.superview!.height * percentage
        }
        return self
    }
    
    @discardableResult
    public func loBellow(_ view: UIView)->UIView{
        constrain(self, view){ v1, v2 in
            v1.left == v1.superview!.left
            v1.top == v2.bottom
            v1.width == v1.superview!.width
            v1.bottom == v1.superview!.bottom
        }
        return self
    }
}
