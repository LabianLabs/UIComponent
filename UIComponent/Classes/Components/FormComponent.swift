//
//  FormComponent.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation

public final class FormComponent: BaseComponent, ComponentType{
    public var render:((Form)->Void)?    
    public var host:Any?
    public var hasMoreItems:Bool = true
    public var callbackOnInfiniteScroll:(()->Void)?
    public var callbackOnRefresh:(()->Void)?    
    public var isPullToRefreshEnabled:Bool = true
    public var isInfiniteScrollEnabled:Bool = true
    
    public func onInfiniteScroll(callback:(()->Void)?)->FormComponent{
        self.callbackOnInfiniteScroll = callback
        return self
    }
    
    public func onRefresh(callback:(()->Void)?)->FormComponent{
        self.callbackOnRefresh = callback
        return self
    }
}
