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
    var container: BasicComponentContainer?
    var count = 12
    var section = 0
    weak var timer:Timer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Basic Compomnent"
        let state = BasicViewState(data: [Data(url: "download",
                                              message: "Sweet voice, I wish i can speak like you!"),
                                          Data(url: "download" ,
                                               message: "Yeah!"),
                                          Data(url: "download",
                                               message: "")])
        let container = BasicComponentContainer(controller: self, state: state)
        RenderView.render(container: container, in: self)
        self.container = container
    }
}
