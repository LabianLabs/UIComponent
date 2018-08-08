////  NavigationBarComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIKit

public final class NavigationBarComponent: BaseComponent, ComponentType{
    public weak var host:UIViewController?
    public var leftButtonTitle:String?
    public var rightButtonTitle:String?    
    public var setupLeftButton:(()->UIBarButtonItem)?
    public var setupRightButton:(()->UIBarButtonItem)?
    public var setupTitle:(()->String)?
    internal var callbackOnClickLeftButton:(()->Void)?
    internal var callbackOnClickRightButton:(()->Void)?
    
    public func onLeftButtonClick(_ callback:@escaping ()->Void)->NavigationBarComponent{
        self.callbackOnClickLeftButton = callback
        return self
    }
    
    public func onRightButtonClick(_ callback:@escaping ()->Void)->NavigationBarComponent{
        self.callbackOnClickRightButton = callback
        return self
    }

}
