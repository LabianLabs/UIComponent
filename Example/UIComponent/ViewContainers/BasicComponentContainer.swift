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
                <<< SearchBarComponent(){
                    $0.placeholder = "Search"
                    $0.tag = "SEARCHBAR"
                }
                <<< NavigationBarComponent(){
                        $0.host = viewController
                        $0.setupTitle = {
                            return "Custom Title"
                        }
                        $0.rightButtonTitle = "Done"
                    }.OnClickLeftButton {
                        print("OnClickLeftButton")
                    }.OnClickRightButton {
                        print("OnClickRightButton")
                    }
                <<< CardComponent() {
                    $0.children
                        <<< ViewComponent<CustomViewComponent>(){ view in
                            view.nibFile = "CustomViewComponent"
                        }
                        <<< ViewComponent<CustomViewComponent>() { view in
                            view.nibFile = "CustomViewComponent1"
                        }
                        <<< ViewComponent<CustomViewComponent>() { view in
                            view.nibFile = "CustomViewComponent2"
                    }
                    $0.layout = { c,view in
                        view.loFillInParent()
                    }
                    }.onIndexChanged(selectionIndex: 2, callback: { (_) in
                        print("click")
                    })
//                <<< SegmentComponent(["1", "2", "3"]){
//                    $0.tag = "SEGMENT"
//                    $0.layout = { c, view in
//                        constrain(c.viewByTag("SEARCHBAR") as! UIView, view) { v1, v2 in
//                            v2.top == v1.bottom
//                            v2.left == v2.superview!.left
//                            v2.right == v2.superview!.right
//                            v2.height == 44
//                        }
//                    }
//                }
//                <<< ViewComponent<CustomViewComponent>(){
//                    $0.nibFile = "CustomViewComponent"
//                    $0.render = { view in
//                        view.userName = "111"
//                    }
//                    $0.layout = { c, view in
//                        view.loHeightInParent(0.3).loBellow(c.viewByTag("SEGMENT") as! UIView)
//                    }
//                }
                <<< FloatComponent<CustomViewComponent>(){
                    $0.nibFile = "CustomViewComponent"
                }
            }
    }
}
