//
//  MenuContainer.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

enum Menu {
    case basicComponents, form, dynamicForm
}

class MenuContainer: BaseComponentRenderable<Int>{
    weak var viewController: MenuViewController?
    var onMenuSelected:((Menu)->Void)?
    
    public init(controller: MenuViewController, state: Int){
        self.viewController = controller
        super.init(state: state)
    }
    override func render(_ state: Int) -> ComponentContainer {
        return EmptyViewComponent()
    }
}
