//
//  FormComponent.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation
import Eureka

public final class FormComponent: BaseComponent, ComponentType{
    public var render:((Form)->Void)?
    var host:Any?
}
