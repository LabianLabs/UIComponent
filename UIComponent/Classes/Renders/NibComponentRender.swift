//
//  NibComponentRenderer.swift
//  Eureka
//
//  Created by Duc Ngo on 6/10/18.
//

import UIKit

extension NibComponent: UIKitRenderable{
    public func renderUIKit() -> UIKitRenderTree {
        guard let nibFile = self.nibFile else { return .leaf(self, UIView()) }
        let bundle = Bundle.main
        if let view = bundle.loadNibNamed(nibFile, owner: nil, options: nil)?.first as? T{
            self.render?(view)
            return .leaf(self, view as! UIView)
        }else{
            fatalError()
        }
    }
    
    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {
        
        guard let newComponent = newComponent as? NibComponent else { fatalError() }
        guard let nibView = view as? T else { fatalError() }
        self.render?(nibView)
        return .leaf(newComponent, nibView as! UIView)
    }
    
    public func autoLayout(view: UIView) {
        self.layout(self, view)
    }
}


