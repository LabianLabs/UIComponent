////  BasicComponentViewController.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIComponent
import UIKit

class BasicComponentViewController:UIViewController{
    var container: BasicComponentContainer!
    var count = 12
    var section = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Basic Compomnent"
        let state = BasicViewState(userName: "test", avatarUrl: "test", step: 1)
        self.container = BasicComponentContainer(controller: self, state: state)
        RenderView.render(container: self.container, in: self)
    }
}
