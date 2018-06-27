////  CardComponentRender.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/26/18.
//  Copyright © LabianLabs 2015
//

import Foundation


extension CardComponent: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        var childViews: [UIView]
        
        let children = self.children.compactMap {$0 as? UIKitRenderable}.map { $0.renderUIKit() }
        childViews = children.map{ $0.view }
        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.backgroundColor = UIColor.lightGray
        stackView.alignment = UIStackViewAlignment.fill
        stackView.isUserInteractionEnabled = true
        
        stackView.distribution = UIStackViewDistribution.fillEqually
        self.applyBaseAttributes(to: stackView)
        return .node(self, stackView, children)
    }
    
    public func autoLayout(view: UIView) {
        self.layout?(self,view)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes,
                            newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let newComponent = newComponent as? CardComponent else { fatalError() }
        
        guard let stackView = view as? UIStackView else { fatalError() }
        
        guard case let .node(_, _, childTree) = renderTree else { fatalError() }
        
        var children = childTree
        
        var viewsToInsert: [(index: Int, view: UIView, renderTree: UIKitRenderTree)] = []
        var viewsToRemove: [(index: Int, view: UIView)] = []
        
        if case let .root(changes) = change {
            
            for change in changes {
                
                switch change {
                case let .insert(index, _):
                    let renderTreeEntry = (newComponent.children[index] as! UIKitRenderable).renderUIKit()
                    viewsToInsert.append((index, renderTreeEntry.view, renderTreeEntry))
                case let .remove(index):
                    let childView = children[index].view
                    viewsToRemove.append((index, childView))
                default:
                    break
                }
            }
            
        }
        
        var indexOffset = 0
        
        for insert in viewsToInsert {
            stackView.insertArrangedSubview(insert.view, at: insert.index)
            children.insert(insert.renderTree, at: insert.index)
            
            indexOffset += 1
        }
        
        for remove in viewsToRemove {
            stackView.removeArrangedSubview(remove.view)
            remove.view.removeFromSuperview()
            children.remove(at: remove.index + indexOffset)
            
            indexOffset -= 1
        }
        
        return .node(newComponent, stackView, children)
    }
    
    @objc public func onIndexChanged(_ sender: UIStackView ){
        self.callBackOnIndexChanged?(sender)
    }
}
