//
//  ComponentRenderable.swift
//  UILib
//
//  Created by Benji Encz on 5/14/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol Renderer:class{
    func renderComponent(_ component: ComponentContainer, animated: Bool)
}

public protocol ComponentRenderable {
    var renderer: Renderer? { get set }
}

open class BaseComponentRenderable<State>: ComponentRenderable {
    var _noRender = false
    var _animateChanges = false

    public weak var renderer: Renderer? {
        didSet {
            guard !_noRender else { return }
            let component = self.render(state)
            self.renderer?.renderComponent(component, animated: self._animateChanges)
        }
    }

    public var state: State {
        didSet {
            guard !_noRender else { return }
            let component = self.render(state)
            self.renderer?.renderComponent(component, animated: self._animateChanges)
        }
    }

    public init(state: State) {
        self.state = state
    }
    
    public func update(_ update: () -> Void) {
        self.update(animated: false, rerender:true, update)
    }
    
    public func update(animated:Bool = false,_ update: () -> Void) {
        self.update(animated: animated, rerender:true, update)
    }
    
    public func update(rerender:Bool = false,_ update: () -> Void) {
        self.update(animated: false, rerender:rerender, update)
    }
    
    public func update(animated:Bool = false, rerender:Bool = true, _ update: () -> Void) {
        self._animateChanges = animated
        self._noRender = !rerender
        update()
        self._animateChanges = false
        self._noRender = false
    }

    open func render(_ state: State) -> ComponentContainer {
        fatalError()
    }
    
}
