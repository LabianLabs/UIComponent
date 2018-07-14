//
//  ViewComponent.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

struct BasicViewState{
    var userName:String
    var avatarUrl:String
    var step:Int = 3
}

class BasicComponentContainer:BaseComponentRenderable<BasicViewState>{
    weak var viewController: BasicComponentViewController?

    public init(controller: BasicComponentViewController, state: BasicViewState){
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: BasicViewState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.layout = {c, v in
                constrain(v){ view in
                    view.left == view.superview!.left
                    view.top == view.superview!.top + 64
                    view.width == view.superview!.width
                    view.bottom == view.superview!.bottom
                }
            }
            $0.children
                <<< StateComponent(){
                    $0.loadingComponent = LabelComponent(){$0.text = "loading"; $0.layout = {c, v in v.loFillInParent()}}
                    $0.dataComponent = LabelComponent(){$0.text = "data"; $0.layout = {c, v in v.loFillInParent()}}
                    $0.errorComponent = LabelComponent(){$0.text = "error"; $0.layout = {c, v in v.loFillInParent()}}
                    $0.emptyComponent = LabelComponent(){$0.text = "empty"; $0.layout = {c, v in v.loFillInParent()}}
                    $0.isError = {return false}
                }
            }
    }
}
