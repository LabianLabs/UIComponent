//
//  Button.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public final class ButtonComponent: BaseComponent, ComponentType{
    public var title: String?
    internal var callbackOnClick:((Any?)->Void)?
    internal var callbackOnConfig:((Any?)->Void)?
    
}

