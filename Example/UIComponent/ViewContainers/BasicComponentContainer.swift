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
                    }.onClickLeftButton {
                        print("OnClickLeftButton")
                    }.onClickRightButton {
                        print("OnClickRightButton")
                    }
                <<< StackComponent(){
                    $0.axis = StackComponent.Axis.horizontal
                    $0.borderWidth = 1
                    $0.borderColor = Color.green
                    $0.backgroundColor = Color.fuchsia
                    $0.cornerRadius = 20
                    $0.children <<< LabelComponent(){
                                    $0.text = "Hello"
                                    $0.fontSize = 40
                                    $0.fontStyle = LabelComponent.FontStyle.bold
                                    $0.textAlignment = LabelComponent.TextAlignment.right
                                }
                                <<< LabelComponent(){
                                    $0.text = "Hello"
                                    $0.fontSize = 40
                                    
                    }
                    $0.layout = { c, v in
                        constrain(v){ v in
                            v.width == 300
                            v.height == 300
                            v.center == v.superview!.center
                        }
                    }
                }
            }
    }
}
