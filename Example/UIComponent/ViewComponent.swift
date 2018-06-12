//
//  ViewComponent.swift
//  UIComponent_Example
//
//  Created by Duc Ngo on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent
import Eureka

struct ViewState{
    var userName:String
    var avatarUrl:String
    var step:Int = 3
}

class ViewContainer:BaseComponentRenderable<ViewState>{
    weak var viewController: ViewController?
    
    public init(controller: ViewController, state: ViewState){
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: ViewState) -> ComponentContainer {
        return NibContainerComponent<UserProfile>(){
            $0.layout = { c, view in
                view.loFillInParent()
            }
            $0.children
                <<< NibComponent<UserProfile>(){
                    $0.render = { view in
                        view.userName = "111"
                    }
                    $0.layout = { c, view in
                        constrain(view){ view in
                            view.left == view.superview!.left
                            view.top == view.superview!.top
                            view.width == view.superview!.width
                            view.height == view.superview!.height * 0.3
                        }
                    }
                }
                <<< FormComponent(viewController!){
                    $0.render = { form in
                        form +++ Section()
                            <<< LabelRow () {
                                $0.title = "LabelRow"
                                $0.value = "tap the row"
                                }.onCellSelection { cell, row in
                                    row.title = (row.title ?? "") + " 🇺🇾 "
                                    row.reload() // or row.updateCell()
                        }
                    }
                    $0.layout = { c, view in
                        constrain(view){ view in
                            view.left == view.superview!.left
                            view.top == view.superview!.top + 200
                            view.width == view.superview!.width
                            view.height == view.superview!.height
                        }
                    }
                }
                <<< NibContainerComponent<UserProfile>(){
                    $0.render = { view in
                        view.userName = "111"
                    }
                    $0.children
                        <<< Label(){
                            $0.text = self.state.userName
                            $0.layout = { c, view in
                                constrain(view){ view in
                                    view.width == 200
                                    view.height == 200
                                    view.center == view.superview!.center
                                }
                            }
                        }
                        <<< Label(){
                            $0.text = self.state.userName
                            $0.layout = { root, current in
                                constrain(current){ current in
                                    current.width == 200
                                    current.height == 200
                                    current.center == current.superview!.center
                                }
                            }
                    }
                }
                <<< StackComponent(){
                    $0.axis = StackComponent.Axis.vertical
                    $0.distribution = StackComponent.Distribution.fillEqually
                    $0.children
                        <<< Label(){
                            $0.text = self.state.userName
                        }
                        <<< Label(){
                            $0.text = self.state.userName
                    }
                }
    
            }
    }
}
