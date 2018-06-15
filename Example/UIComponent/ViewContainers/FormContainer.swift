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

class FormContainer:BaseComponentRenderable<FormContainer.ViewState>{
    struct ViewState{
        var userName:String
        var avatarUrl:String
        var step:Int = 3
    }
    
    weak var viewController: ViewController?
    
    public init(controller: ViewController, state: FormContainer.ViewState){
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: FormContainer.ViewState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.children
                <<< FormComponent(viewController!){
                    $0.render = { form in
                        form +++ Section()
                            <<< TableRow<String> { row in
                                row.tableCellNibName = "LabelCell"
                                row.options = ["1", "2", "3"]
                            }
                        
                            <<< TableInlineRow<String> { row in
                                row.tableCellNibName = "LabelCell"
                                row.options = ["1", "2", "3"]
                        }
                    }
                    $0.layout = { c, view in
                        view.loFillInParent()
                    }
                }
        }
    }
}
