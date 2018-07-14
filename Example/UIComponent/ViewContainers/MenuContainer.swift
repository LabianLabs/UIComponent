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
        return EmptyViewComponent(){
            $0.children <<< FormComponent(host:viewController!){
                $0.layout = {c, v in v.loFillInParent()}
                $0.render = { form in
                    form +++ Section("Component Kit")
                        <<< LabelRow(){
                            $0.title = "Basic components"
                        }.onCellSelection({r, l in
                            self.onMenuSelected?(.basicComponents)
                        })
                        <<< LabelRow(){
                                $0.title = "Form component"
                            }.onCellSelection({r, l in
                                self.onMenuSelected?(.form)
                            })
                        <<< LabelRow(){
                            $0.title = "Dynamic Form components"
                            }.onCellSelection({r, l in
                                self.onMenuSelected?(.dynamicForm)
                            })
                }
            }
        }
    }
}
