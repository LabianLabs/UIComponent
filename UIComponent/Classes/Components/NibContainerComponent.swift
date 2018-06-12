//
//  NibContainerComponent.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation

public final class NibContainerComponent<T>:BaseContainerComponent, ComponentType{
    public var nibFile:String?
    public var render:((T)->Void)?
    public required init(_ tag: String? = nil){
        self.nibFile = String(describing: T.self)
        super.init(tag)
    }
}
