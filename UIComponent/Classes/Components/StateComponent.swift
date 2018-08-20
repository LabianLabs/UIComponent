////  IFComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/20/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class StateComponent: BaseContainerComponent, ComponentType {
    public var loadingComponent:Component?
    public var errorComponent:Component?
    public var dataComponent:Component?
    public var emptyComponent:Component?
    public var isLoading:(()->Bool) = {return false}
    public var isError:(()->Bool) = {return false}
    public var isEmpty:(()->Bool) = {return false}
    
    public override var children: Children{
        get{
            return Children()
        }
        set{
            _children =  newValue
        }
    }
}


