//
//  StackComponent.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public final class StackComponent: BaseContainerComponent, ComponentType{    
    public var alignment: Alignment = Alignment.fill
    public var distribution: Distribution = Distribution.fill
    public var axis: Axis = Axis.horizontal
    
    public enum Axis {
        case vertical
        case horizontal
    }

    public enum Alignment {
        case fill
        case leading
        case center
        case trailing
    }

    public enum Distribution {
        case fill
        case fillEqually
        case fillProportionally
        case equalSpacing
        case equalCentering
    }
}
