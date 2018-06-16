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

class BasicComponentContainer:BaseComponentRenderable<ViewState>{
    weak var viewController: ViewController?
    
    public init(controller: ViewController, state: ViewState){
      
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: ViewState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.children
                <<< SearchBarComponent(){
                        $0.placeholder = "Search"
                        $0.tag = "SEARCHBAR"
                    }
                <<< SegmentComponent(["1", "2", "3"]){                    
                    $0.tag = "SEGMENT"
                    $0.layout = { c, view in
                        view.loBellow(c.viewByTag("SEARCHBAR") as! UIView)
                    }
                }
                <<< ViewComponent<CustomViewComponent>(){
                    $0.nibFile = "CustomViewComponent"
                    $0.render = { view in
                        view.userName = "111"
                    }
                    $0.layout = { c, view in
                        view.loHeightInParent(0.3).loBellow(c.viewByTag("SEGMENT") as! UIView)
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
            }
    }
}
