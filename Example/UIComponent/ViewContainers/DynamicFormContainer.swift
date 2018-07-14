//
//  DynamicFormContainer.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

struct DynamicFormState{
    var names:[String:[String]]
}

protocol DynamicFormContainerDelegate:class {
    func onLoadMoreClick()
    func onRefresh()
}

class DynamicFormContainer: BaseComponentRenderable<DynamicFormState>{
    weak var viewController: DynamicFormViewController?
    weak var delegate:DynamicFormContainerDelegate?
    
    public init(controller: DynamicFormViewController, state: DynamicFormState){
        self.viewController = controller
        super.init(state: state)
    }
    
    lazy var formItems:((Form, DynamicFormState)->Void) = { form, state in
        let sortedKeys = Array(self.state.names.keys).sorted(by: {return $0 < $1})
        for key in sortedKeys{
        
            form +++ Section(key)
            for item in self.state.names[key]!{
                form.last! <<< LabelRow(){$0.title = item}
            }
        }
        
    }
    
    override func render(_ state: DynamicFormState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.backgroundColor = Color.green
            $0.layout = {c, v in
                constrain(v){ view in
                    view.left == view.superview!.left
                    view.right == view.superview!.right
                    view.top == view.superview!.top + 64
                    view.bottom == view.superview!.bottom
                }
            }
            $0.children
                <<< FormComponent(host:viewController!){
                        $0.render = { form
                            in self.formItems(form, self.state)
                    }
                    }.onInfiniteScroll(callback: {
                        self.delegate?.onLoadMoreClick()
                    }).onRefresh(callback: {
                        self.delegate?.onRefresh()
                    })
        }
    }
}
