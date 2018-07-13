////  NavigationBarComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation
public typealias BarButtonItem = Any?
public typealias NavigationTitle = Any?
public typealias HostViewController = Any?

public final class NavigationBarComponent: BaseComponent, ComponentType{
    public weak var host:AnyObject?
    public var leftButtonTitle:String?
    public var rightButtonTitle:String?    
    public var setupLeftButton:(()->BarButtonItem)?
    public var setupRightButton:(()->BarButtonItem)?
    public var setupTitle:(()->NavigationTitle)?
    internal var callbackOnClickLeftButton:(()->Void)?
    internal var callbackOnClickRightButton:(()->Void)?
    
    public func onClickLeftButton(_ callback:@escaping ()->Void)->NavigationBarComponent{
        self.callbackOnClickLeftButton = callback
        return self
    }
    
    public func onClickRightButton(_ callback:@escaping ()->Void)->NavigationBarComponent{
        self.callbackOnClickRightButton = callback
        return self
    }

}
