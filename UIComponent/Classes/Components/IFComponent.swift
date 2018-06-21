////  IFComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/20/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class IFComponent: BaseComponent, ComponentType {
    public var when:(()->Bool)?
    public var thenComponent:Component?
    public var elseWhen:(()->Bool)?
    public var elseComponent:Component?    
    internal var vars = IFComponentVars()
}
