//
//  DynamicFormViewController.swift
//  UIComponent_Example
//
//  Created by Duc Ngo on 6/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent
import UIKit

class DynamicFormViewController:UIViewController{
    var dynamicFormContainer: DynamicFormContainer!
    var count = 12
    var section = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dynamic Form"
        let state = DynamicFormState(names: ["Section 0":genItems()])
        self.dynamicFormContainer = DynamicFormContainer(controller: self, state: state)
        self.dynamicFormContainer.delegate = self
        RenderView.render(container: self.dynamicFormContainer, in: self)
    }
    func genItems()->[String]{
        var items = [String]()
        for i in 0..<self.count{
            items.append("Item \(i)")
        }
        return items
    }
}

extension DynamicFormViewController: DynamicFormContainerDelegate{
    func onLoadMoreClick(){
        //count += 10
        let res = self.genItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dynamicFormContainer.update(animated: false) {
                var names = self.dynamicFormContainer.state.names
                self.section += 1
                names["Section \(self.section)"] = res
                self.dynamicFormContainer.state.names = names
            }
        })
    }
    
    func onRefresh() {
        count = 12
        let res = self.genItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dynamicFormContainer.update(animated: false) {
                self.dynamicFormContainer.state.names = ["Section 0":res]
            }
        })
        
    }
}
