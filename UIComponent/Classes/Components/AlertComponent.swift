////  AlertComponent.swift
//  UIComponent
//
//  Created by labs01 on 7/14/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class AlertComponent: BaseComponent, ComponentType {
    internal var alert:UIAlertController?
    public weak var controller:UIViewController?
    public var okButtonTitle:String?
    public var cancelButtonTitle:String?
    public var title:String?
    public var message:String?
    internal var callbackOnOk:(()->Void)?
    internal var callbackOnCancel:(()->Void)?
    
    public convenience init(controller: UIViewController?,_ initializer: (AlertComponent)->Void = {_ in}) {
        self.init(controller:controller, tag:"AlertComponent", initializer)
    }
    
    public convenience init(controller: UIViewController?, tag: String? = nil,_ initializer: (AlertComponent)->Void = {_ in}) {
        self.init(tag)
        self.controller = controller
        initializer(self)
    }
    
    public func onOkButtonClick(_ callback:@escaping ()->Void)->AlertComponent{
        self.callbackOnOk = callback
        return self
    }
    
    public func onCancelButtonClick(_ callback:@escaping ()->Void)->AlertComponent{
        self.callbackOnCancel = callback
        return self
    }
}
