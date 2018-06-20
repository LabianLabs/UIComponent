//
//  CustomCell.swift
//  UIComponent_Example
//
//  Created by Duc Ngo on 6/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

class CustomType:Equatable{
    static func == (lhs: CustomType, rhs: CustomType) -> Bool {
        return true
    }
    
    public init(){
        
    }
}

class CustomType1:CustomType{
    
}

class CustomType2:CustomType{
    
}

class CustomCell:Cell<CustomType>, CellType{
    
    override func setup() {
        print("CustomCell setup \(self.row.value)")
    }
    
    override func update() {        
        print("CustomCell update \(self.row.value)")
    }
}
