////  IFComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/20/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class StateComponent: BaseContainerComponent, ComponentType {
    public var loadingComponent:ComponentContainer?
    public var errorComponent:ComponentContainer?
    public var dataComponent:ComponentContainer?
    public var emptyComponent:ComponentContainer?
    public var isLoading:(()->Bool) = {return false}
    public var isError:(()->Bool) = {return false}
    public var isEmpty:(()->Bool) = {return false}
    
}
