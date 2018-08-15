//
//  SearchBarComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/12/18.
//

import Foundation
import UIKit

public final class SearchBarComponent: BaseComponent, ComponentType {
    internal var kbTimer:Timer?
    
    public enum ReturnKey {
        case goKey, doneKey, continueKey, googleKey, searchKey
    }
    
    public var text:String?
    public var placeholder:String?
    public var returnKey = ReturnKey.searchKey
    public var barTintColor:Color?
    public var enablesReturnKeyAutomatically:Bool = true
    
    public var config:((UISearchBar)->Void)?
    internal var callbackOnEndEditing: ((_ text:String?) -> Void)?
    internal var callbackOnTextChanged: ((_ text:String?) -> Void)?
    internal var callbackOnLazyTextChanged: ((_ text:String?) -> Void)?
    internal var callbackOnCancel: (() -> Void)?
    internal var callbackOnSearchClick: ((String?) -> Void)?
    
    public func onEndEditing(_ callback:@escaping (_ text:String?)->Void)->SearchBarComponent{
        self.callbackOnEndEditing = callback
        return self
    }
    
    public func onTextChanged(_ callback:@escaping (_ text:String?)->Void)->SearchBarComponent{
        self.callbackOnTextChanged = callback
        return self
    }
    
    public func onLazyTextChanged(_ callback:@escaping (_ text:String?)->Void)->SearchBarComponent{
        self.callbackOnLazyTextChanged = callback
        return self
    }
    
    public func onCancel(_ callback:@escaping ()->Void)->SearchBarComponent{
        self.callbackOnCancel = callback
        return self
    }
    
    public func onSearchClick(_ callback:@escaping (String?)->Void)->SearchBarComponent{
        self.callbackOnSearchClick = callback
        return self
    }
    
}
