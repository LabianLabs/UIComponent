//
//  ViewController.swift
//  UIComponent
//
//  Created by ducn on 06/09/2018.
//  Copyright (c) 2018 ducn. All rights reserved.
//

import UIKit
import UIComponent

class ViewController: UIViewController {
    var viewContainer:ComponentRenderable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initState = ViewState(userName: "test", avatarUrl: "test", step:2)
        
        // Render container
        self.viewContainer = ViewContainer(controller: self, state: initState)
        
//        let initState = FormInlineContainer.ViewState(userName: "test", avatarUrl: "test", step:2)
//        self.viewContainer = FormInlineContainer(controller: self, state: initState)
        RenderView.render(container: viewContainer, in: self)
        
        // Update state
//        self.viewContainer.update(animated: true) {
//            self.viewContainer.state.step = 1
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

