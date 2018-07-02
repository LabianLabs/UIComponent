//
//  CustomViewComponent.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent
import UIKit

class CustomViewComponent:UIViewComponent{
    @IBOutlet weak var userName :UILabel?
    
    override func setup() {
        self.userName?.text = "AAAA"//self.value as? String
    }
    
    override func update() {
        self.userName?.text = self.value as? String
    }
    
}

