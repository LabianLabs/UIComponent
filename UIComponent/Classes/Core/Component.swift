//
//  Component.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol Initializable:class{
    init()
}


/**
 Type for a simple component without child components, such as a Button
 or a text field.
*/
public protocol Component{
    var componentIdentifier: String { get }
    var tag: String? { get set}
    init(_ tag:String?)
    var viewByTag:(String)->Any? {get set}
}

public extension Component{
    var componentIdentifier: String { return String(describing: type(of: self)) }
}

public protocol ComponentType{
    init(tag:String?, _ initializer:(Self)->Void)
}

extension ComponentType where Self:BaseComponent{
    public init(tag:String? = nil, _ initializer:(Self)->Void = {_ in}){
        self.init(tag)
        initializer(self)
    }
}

/**
 Type for a component that manages subcomponents, such as a Table View or
 Stack Component.
*/
public protocol ComponentContainer: Component {
    var children: Children { get }
    func append(_ component: Component)->ComponentContainer
}

public extension ComponentContainer{
    public func append(_ component: Component)->ComponentContainer{
        self.children.append(component)
        return self
    }
}


open class BaseComponent: NSObject, Component{
    public var tag:String?
    public var layout:LayoutBlock?
    public var viewByTag: (String) -> Any? = {_ in return nil }
    public var alpha:CGFloat = 1.0
    public var backgroundColor:Color?
    public var tintColor:Color?
    public var isUserInteractionEnabled:Bool = true
    public var isHidden:Bool = false
    public var cornerRadius:CGFloat = -1.0
    public var borderWidth:CGFloat = -1.0
    public var borderColor:Color?
    public required init(_ tag: String? = nil) {
        self.tag = tag
    }
}

open class BaseContainerComponent: BaseComponent, ComponentContainer{
    public var children: Children = Children()
    
    public func append(_ component: Component)->ComponentContainer{
        children.append(component)
        return self
    }
}

public class Children:Sequence{
    
    private var items:[Component] = [Component]()
    
    var count:Int{
        return items.count
    }
    
    public init(){
        
    }
    
    public func append(_ item:Component){
        items.append(item)
    }
    
    public subscript(_ index: Int)->Component{
        get{
            return items[index]
        }
        set{
            items[index] = newValue
        }
    }
    
    public func makeIterator() -> AnyIterator<Component> {
        var iterator = self.items.makeIterator()
        return AnyIterator{
            return iterator.next()
        }
    }
}

