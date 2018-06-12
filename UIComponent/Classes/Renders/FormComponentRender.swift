//
//  FormComponentRender.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation
import UIKit
import Eureka

extension FormComponent: UIKitRenderable{
    var hostController: UIViewController?{
        return host as? UIViewController
    }
    public convenience init(_ host: UIViewController,_ initializer: (FormComponent)->Void = {_ in}) {
        self.init(nil, host, initializer)
    }
    
    public convenience init(_ tag: String? = nil,_ host: UIViewController,_ initializer: (FormComponent)->Void = {_ in}) {
        self.init(tag)
        self.host = host
        initializer(self)
    }
    
    public func renderUIKit() -> UIKitRenderTree {
        guard let host = hostController else { return .leaf(self, UIView())}
        let formController = FormViewController()
        host.addChildViewController(formController)
        formController.didMove(toParentViewController: host)
        self.applyBaseAttributes(to: formController.view)
        self.render?(formController.form)
        return .leaf(self, formController.view)
    }
    
    public func autoLayout(view: UIView) {
        self.layout?(self, view)
    }
}

