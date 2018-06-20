//
//  CustomInlineCell.swift
//  UIComponent_Example
//
//  Created by Duc Ngo on 6/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

class CustomSubCell:SubCell<CustomType>, CellType{
    override func setup() {
        print("CustomInlineCell setup \(self.subValue)")
    }
    
    override func update() {
        //print("\(self.row.value)")
        print("CustomInlineCell update \(self.subValue)")
    }
}
