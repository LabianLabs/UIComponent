//
//  Button.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation
import UIKit

public final class ButtonComponent: BaseComponent, ComponentType{
    public var title: String?
    internal var callbackOnClick:((UIButton?)->Void)?
    public var config:((UIButton)->Void)?
    
    func onClick(_ callback:((UIButton?)->Void)?) -> ButtonComponent{
        callbackOnClick = callback
        return self
    }
}

