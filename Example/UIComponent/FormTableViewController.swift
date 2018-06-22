//
//  FormTableViewController.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent
import UIKit

class FormTableViewController:UIViewController{
    var container: FormContainer!
    var count = 12
    var section = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form Tableview"
        let state = FormViewState(userName: "test", avatarUrl: "")
        self.container = FormContainer(controller: self, state: state)
        RenderView.render(container: self.container, in: self)
    }
}
