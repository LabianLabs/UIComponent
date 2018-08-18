////  IFComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 6/20/18.
//  Copyright © LabianLabs 2015
//

import Foundation

struct IFComponentVars{
    var thenTree:UIKitRenderTree?
    var elseTree:UIKitRenderTree?
    var containerCG:ConstraintGroup = ConstraintGroup()
    var thenCG:ConstraintGroup = ConstraintGroup()
    var elseCG:ConstraintGroup = ConstraintGroup()
    var thenHeight:CGFloat = 0
    var elseHeight:CGFloat = 0
}

extension IFComponent: UIKitRenderable{
    
    public func renderUIKit() -> UIKitRenderTree {
        let containerView = UIView()
        var children = [UIKitRenderTree]()
        if let thenCmp = self.thenComponent, let renderThenComp = thenCmp as? UIKitRenderable{
            self.vars.thenTree = renderThenComp.renderUIKit()
            (thenCmp as! BaseComponent).onRendered?(thenCmp as! BaseComponent, self.vars.thenTree!.view)
            children.append(self.vars.thenTree!)
            containerView.addSubview(self.vars.thenTree!.view)
        }
        if let otherComp = self.elseComponent, let renderOtherComp = otherComp as? UIKitRenderable{
            self.vars.elseTree = renderOtherComp.renderUIKit()
            (otherComp as! BaseComponent).onRendered?(otherComp as! BaseComponent, self.vars.elseTree!.view)
            children.append(self.vars.elseTree!)
            containerView.addSubview(self.vars.elseTree!.view)
        }
        return .node(self, containerView, children)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let ifComponent = newComponent as? IFComponent else {fatalError()}
        var children = [UIKitRenderTree]()
        if let when = ifComponent.when, when() == true {
            if let trueComp = ifComponent.thenComponent, let renderTrueComp = trueComp as? UIKitRenderable, let renderedView = self.vars.thenTree?.view{
                children.append(self.vars.thenTree!)
                _ = renderTrueComp.updateUIKit(renderedView, change:change, newComponent:renderTrueComp, renderTree:renderTree)
                if let baseComp = renderTrueComp as? BaseComponent{
                    baseComp.onRendered?(baseComp, renderedView)
                }
            }
        } else if let otherComp = ifComponent.elseComponent, let renderOtherComp = otherComp as? UIKitRenderable, let renderedView = self.vars.elseTree?.view{
            children.append(self.vars.elseTree!)
            _ = renderOtherComp.updateUIKit(renderedView, change:change, newComponent:renderOtherComp, renderTree:renderTree)
            if let baseComp = renderOtherComp as? BaseComponent{
                baseComp.onRendered?(baseComp, renderedView)
            }
        }
        return .node(ifComponent, view, children)
    }
    
    public func autoLayout(view: UIView) {
        let layoutContentView:(UIView, ConstraintGroup)->Void = { view, group in
            constrain(view, replace:group){ v in
                v.top  == v.superview!.top
                v.bottom == v.superview!.bottom
                v.leading == v.superview!.leading
                v.trailing == v.superview!.trailing
            }
        }
        if let layout = self.layout{
            layout(view)
        }else{
            constrain(view, replace:self.vars.containerCG){ v in
                v.top  == v.superview!.top
                v.leading == v.superview!.leading
                v.trailing == v.superview!.trailing
                v.width == v.superview!.width
            }
        }
        // Clear all sub view
        _ = view.subviews.map({$0.removeFromSuperview()})
        if let when = self.when, when() == true {
            if let thenView = self.vars.thenTree?.view{
                view.addSubview(thenView)
                self.vars.thenTree?.renderable.autoLayout(view: thenView)
                if thenView.constraints.count == 0{
                    layoutContentView(thenView, self.vars.thenCG)
                }
                constrain(view, thenView){ v1, v2 in
                    v1.bottom == v2.bottom
                }
            }
        } else{
            let displayElseView:((UIView)->Void) = { elseView in
                view.addSubview(elseView)
                self.vars.elseTree?.renderable.autoLayout(view: elseView)
                if elseView.constraints.count == 0{
                    layoutContentView(elseView, self.vars.elseCG)
                }
                constrain(view, elseView){ v1, v2 in
                    v1.bottom == v2.bottom
                }
            }
            let hideContainer = {
                // hide container
                _ = constrain(view){ v in
                    v.height == 0
                }
            }
            if let elseView = self.vars.elseTree?.view{
                if let elseWhen = self.elseWhen {
                    if elseWhen() == true{
                        displayElseView(elseView)
                    }else{
                        hideContainer()
                    }
                } else {
                    displayElseView(elseView)
                }
            } else{
                hideContainer()
            }
        }
    }
    
}
