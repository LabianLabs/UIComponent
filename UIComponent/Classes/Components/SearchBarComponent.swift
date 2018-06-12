//
//  SearchBarComponent.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/12/18.
//

import Foundation
public final class SearchBarComponent: BaseComponent, ComponentType {
    public enum ReturnKey {
        case goKey, doneKey, continueKey, googleKey
    }
    
    public var text:String?
    public var placeholder:String?
    public var returnKey = ReturnKey.googleKey
    public var barTintColor:Color?
    public var setupSearchBar:((Any?)->Void)?
    var callbackOnEndEditing: ((_ text:String?) -> Void)?
    var callbackOnTextChanged: ((_ text:String?) -> Void)?
    var callbackOnCancel: (() -> Void)?
    var callbackOnSearchClick: (() -> Void)?
    
    public func onEndEditing(_ callback:@escaping (_ text:String?)->Void)->SearchBarComponent{
        self.callbackOnEndEditing = callback
        return self
    }
    
    public func onTextChanged(_ callback:@escaping (_ text:String?)->Void)->SearchBarComponent{
        self.callbackOnTextChanged = callback
        return self
    }
    
    public func onCancel(_ callback:@escaping ()->Void)->SearchBarComponent{
        self.callbackOnCancel = callback
        return self
    }
    
    public func onSearchClick(_ callback:@escaping ()->Void)->SearchBarComponent{
        self.callbackOnSearchClick = callback
        return self
    }
    
}
