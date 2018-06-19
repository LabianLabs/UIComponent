//
//  CustomCell.swift
//  UIComponent_Example
//
//  Created by Duc Ngo on 6/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Eureka
import UIComponent

class CustomCell:Cell<String>, CellType{
    
    override func setup() {
        print("CustomCell setup \(self.row.value)")
    }
    
    override func update() {        
        print("CustomCell update \(self.row.value)")
    }
}
