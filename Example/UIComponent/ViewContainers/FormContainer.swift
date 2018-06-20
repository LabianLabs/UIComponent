//
//  ViewComponent.swift
//  UIComponent_Example
//
//  Created by Duc Ngo on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

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
                        form.inlineRowHideOptions = InlineRowHideOptions.Never
                        form +++ Section()
                            <<< TableRow<CustomType> { row in
                                row.inlineCellProvider = TableCellProvider(nibName: "CustomSubCell", bundle: Bundle.main)
                                row.values = [CustomType2()]
                            }
                            <<< TableInlineRow<CustomType> { row in
                                row.value = CustomType1()
                                row.inlineCellProvider = TableCellProvider(nibName: "CustomCell", bundle: Bundle.main)
                                row.inlineSubCellProvider = TableCellProvider(nibName: "CustomSubCell", bundle: Bundle.main)
                                row.subValues = [CustomType2(), CustomType2()]
                            }.onSetupCell({ (cell) in
                                //print(cell)
                            }).onSetupSubCell({ (cell, item, index) in
                                //print(cell)
                            })
                            <<< TableInlineRow<CustomType> { row in
                                row.value = CustomType1()
                                row.inlineCellProvider = TableCellProvider(nibName: "CustomCell", bundle: Bundle.main)
                                row.inlineSubCellProvider = TableCellProvider(nibName: "CustomSubCell", bundle: Bundle.main)
                                row.subValues = [CustomType2(), CustomType2()]
                            }
                    }
                    $0.layout = { c, view in
                        view.loFillInParent()
                    }
                    }.onRefresh(callback: {
                        self.update {
                            self.state.userName = "aaa"
                        }
                    })
        }
    }
}
