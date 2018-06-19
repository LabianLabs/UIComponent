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

struct FormViewState{
    var userName:String
    var avatarUrl:String    
}

class FormContainer:BaseComponentRenderable<FormViewState>{
   
    
    weak var viewController: FormTableViewController?
    
    public init(controller: FormTableViewController, state: FormViewState){
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: FormViewState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.children
                <<< FormComponent(viewController!){
                    $0.render = { form in
                        form +++ Section()
                            <<< TableRow<String> { row in
                                row.inlineCellProvider = TableCellProvider(nibName: "CustomSubCell", bundle: Bundle.main)
                                row.values = ["1"]
                            }
                            <<< TableInlineRow<String> { row in
                                row.value = "test TableInlineRow"
                                row.inlineCellProvider = TableCellProvider(nibName: "CustomCell", bundle: Bundle.main)
                                row.inlineSubCellProvider = TableCellProvider(nibName: "CustomSubCell", bundle: Bundle.main)
                                row.values = ["1", "2", "3"]
                            }.onSetupCell({ (cell) in
                                //print(cell)
                            }).onSetupSubCell({ (cell, item, index) in
                                //print(cell)
                            })
                    }
                    $0.layout = { c, view in
                        view.loFillInParent()
                    }
                }
        }
    }
}
