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
    public var callbackOnClick:((Any?)->Void)?
    public func onClick(_ callback: ((Any?)->Void)?)->ButtonComponent{
        self.callbackOnClick = callback
        return self
    }
}
