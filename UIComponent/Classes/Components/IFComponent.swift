////  IFComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/20/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class IFComponent: BaseComponent, ComponentType {
    
    public var thenComponent:Component?
    public var elseComponent:Component?
    public var when:(()->Bool)?
    public var elseWhen:(()->Bool)?
    internal var vars = IFComponentVars()
}
