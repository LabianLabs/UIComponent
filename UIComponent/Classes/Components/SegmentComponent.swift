//
//  SegmentComponent.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/12/18.
//

import Foundation
public final class SegmentComponent: BaseComponent, ComponentType {
    public var items:[String]?
    public var selectedIndex:Int = 0
    var callbackOnSelectedChanged:((Int)->Void)?
    
    public init(_ items:[String]? = nil, _ tag:String? = nil, _ initializer:(BaseComponent)->Void = {_ in}){
        self.items = items
        super.init(tag)
        self.backgroundColor = Color.white
        initializer(self)
    }
    
    public required init(_ tag: String?) {
        super.init(tag)
    }
    
    public func onSelectedChanged(_ callback:((Int)->Void)?){
        self.callbackOnSelectedChanged = callback
    }
}
