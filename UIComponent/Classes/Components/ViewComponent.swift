//
//  ViewComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/10/18.
//

import Foundation

public final class ViewComponent<T:Initializable>: BaseContainerComponent, ComponentType{
    public var nibFile:String?
    public var config:((T)->Void)?
    public var value:Any?
    public required init(_ tag: String? = nil){
        super.init(tag)
    }
}
