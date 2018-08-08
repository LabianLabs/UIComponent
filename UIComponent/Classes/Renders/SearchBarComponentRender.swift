//
//  SearchBarComponent.swift
//  UIComponent
//
//  Created by labs01 on 6/12/18.
//

import Foundation
import UIKit

extension SearchBarComponent:UIKitRenderable{    
    public func renderUIKit() -> UIKitRenderTree {
        let searchBar = UISearchBar()
        self.applyBaseAttributes(to: searchBar)
        searchBar.text = self.text
        searchBar.placeholder = self.placeholder
        searchBar.returnKeyType = ReturnKey.from(key: self.returnKey)
        if let barTintColor = self.barTintColor{
            searchBar.barTintColor = UIColor(rgba: barTintColor.hexString)
        }
        if let config = self.config{
            config(searchBar)
        }
        searchBar.delegate = self
        return .leaf(self, searchBar)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let searchBar = view as? UISearchBar else {fatalError()}
        guard let searchComponent = newComponent as? SearchBarComponent else {fatalError()}        
        searchBar.delegate = searchComponent
        searchComponent.applyBaseAttributes(to: searchBar)
        return .leaf(searchComponent, view)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(self, view)
        } else {
            constrain(view) { view in
                view.top == view.superview!.top
                view.left == view.superview!.left
                view.right == view.superview!.right
            }
        }
    }
}

extension SearchBarComponent:UISearchBarDelegate{
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.callbackOnEndEditing?(searchBar.text)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        for view1 in searchBar.subviews {
            for view2 in view1.subviews {
                if view2 is UITextField {
                    if let searchBarTextField = view2 as? UITextField{
                        searchBarTextField.enablesReturnKeyAutomatically = self.enablesReturnKeyAutomatically
                        break
                    }
                }
            }
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.callbackOnCancel?()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.callbackOnSearchClick?()
        if self.enablesReturnKeyAutomatically {
            searchBar.resignFirstResponder()
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.callbackOnTextChanged?(searchText)
    }
}

extension SearchBarComponent.ReturnKey{
    static func from(key:SearchBarComponent.ReturnKey)->UIReturnKeyType{
        switch key {
            case .goKey:
                return UIReturnKeyType.go
            case .doneKey:
                return UIReturnKeyType.done
            case .continueKey:
                return UIReturnKeyType.continue
            case .googleKey:
                return UIReturnKeyType.google
            case .searchKey:
                return UIReturnKeyType.search
        }
    }
}
