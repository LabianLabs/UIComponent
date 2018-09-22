//
//  StackComponentRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension StackComponent: UIKitRenderable {

    public func renderUIKit() -> UIKitRenderTree {
        var childViews: [UIView]

        let childComponents = self.children.compactMap { $0 as? UIKitRenderable }
        let children = childComponents.map { component -> UIKitRenderTree in
            let res = component.renderUIKit()
            (component as! BaseComponent).onRendered?(component as! BaseComponent, res.view)
            return res
        }
        childViews = children.map { $0.view }
        let container = UIView()
        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = convertAxis(self.axis)
        stackView.backgroundColor = .white
        stackView.alignment = convertAlignment(self.alignment)
        stackView.distribution = convertDistribution(self.distribution)
        container.addSubview(stackView)
        self.applyBaseAttributes(to: container)        
        return .node(self, container, children)
    }
    
    public func autoLayout(view: UIView) {
        self.layout?(view)
        view.subviews.first?.loFillInParent()
    }

    public func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {

        guard let newComponent = newComponent as? StackComponent else { fatalError() }

        guard let stackView = view.subviews.first as? UIStackView else { fatalError() }
        stackView.axis = convertAxis(newComponent.axis)
        stackView.backgroundColor = .white

        let newAlignment = convertAlignment(newComponent.alignment)

        if newAlignment != stackView.alignment {
            stackView.alignment = newAlignment
        }
        stackView.distribution = convertDistribution(newComponent.distribution)
        
        newComponent.applyBaseAttributes(to: view)
        
        let children = updateChildren(view: stackView, change: change, newComponent: newComponent, renderTree: renderTree, insertSubview: {view, index in
            stackView.insertArrangedSubview(view, at: index)
        }, removeSubview: { view, index in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        })
        return .node(newComponent, view, children)
    }
    
}


private func convertAlignment(_ alignment: StackComponent.Alignment) -> UIStackViewAlignment {
    switch alignment {
    case .center:
        return UIStackViewAlignment.center
    case .fill:
        return UIStackViewAlignment.fill
    case .leading:
        return UIStackViewAlignment.leading
    case .trailing:
        return UIStackViewAlignment.trailing
    }
}

private func convertDistribution(_ distribution: StackComponent.Distribution) -> UIStackViewDistribution {
    switch distribution {
    case .fill:
        return UIStackViewDistribution.fill
    case .fillEqually:
        return UIStackViewDistribution.fillEqually
    case .fillProportionally:
        return UIStackViewDistribution.fillProportionally
    case .equalSpacing:
        return UIStackViewDistribution.equalSpacing
    case .equalCentering:
        return UIStackViewDistribution.equalCentering
    }
}

private func convertAxis(_ axis: StackComponent.Axis) -> UILayoutConstraintAxis {
    switch axis {
    case .horizontal:
        return UILayoutConstraintAxis.horizontal
    case .vertical:
        return UILayoutConstraintAxis.vertical
    }
}
