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
            $0.layout = {v in
                constrain(v){ view in
                    view.left == view.superview!.left
                    view.right == view.superview!.right
                    view.top == view.superview!.top + 64
                    view.bottom == view.superview!.bottom
                }
            }
            $0.children
                +++ IFComponent(tag:"AA"){
                    $0.when = { return self.state.userName == "test"}
                    $0.thenComponent = LabelComponent() {$0.text = "These errors don't appear right away. The app was running fine doing stuff with RemoteShell and LocalShell and suddenly, the first stack trace happened once, and all subsequent calls to shell.run started giving the second stack trace, every time."}
                    $0.elseWhen = { return self.state.userName == "222"}
                    $0.elseComponent = LabelComponent() {$0.text = "else is wrong"}
                }
        }
    }
}
