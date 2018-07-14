//
//  ViewComponent.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

struct FormViewState{
    var userName:String = "11"
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
            $0.layout = {c, v in
                constrain(v){ view in
                    view.left == view.superview!.left
                    view.right == view.superview!.right
                    view.top == view.superview!.top + 64
                    view.bottom == view.superview!.bottom
                }
            }
            $0.children
                <<< IFComponent(tag:"AA"){
                    $0.when = { return self.state.userName == "test"}
                    $0.thenComponent = LabelComponent() {$0.text = "These errors don't appear right away. The app was running fine doing stuff with RemoteShell and LocalShell and suddenly, the first stack trace happened once, and all subsequent calls to shell.run started giving the second stack trace, every time."}
                    $0.elseWhen = { return self.state.userName == "222"}
                    $0.elseComponent = LabelComponent() {$0.text = "else is wrong"}
                }
                <<< FormComponent(host:viewController!){
                    $0.render = { form in
                        form.inlineRowHideOptions = InlineRowHideOptions.Never
                        form +++ Section()
                            <<< ContainerRow(){
                                $0.children
                                    <<< ViewComponent<CustomViewComponent>(){
                                        $0.tag = "l1"
                                        $0.value = "user1@gmail.com"
                                        $0.nibFile = "CustomViewComponent"
                                        $0.layout = { c, v in
                                            constrain(v){ v in
                                                v.left == v.superview!.left
                                                v.right == v.superview!.right
                                                v.top == v.superview!.top                                                
                                            }
                                        }
                                    }
                                    <<< LabelComponent(){
                                        $0.text  = "222"
                                        $0.layout = { c, v in
                                            let l1 = (c.viewByTag("l1") as! UIView)
                                            constrain(v, l1){ v, v2 in
                                                v.left == v.superview!.left
                                                v.right == v.superview!.right
                                                v.top == v2.bottom
                                                v.bottom == v.superview!.bottom
                                            }
                                            
                                        }
                                    }
                            }
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
                        if let v = c.viewByTag("AA") as? UIView{
                            view.loBellow(v)
                        }else{
                            view.loFillInParent()
                        }
                    }
                    }.onRefresh(callback: {
                        self.update {
                            self.state.userName = "aaa"
                        }
                    })
        }
    }
}
