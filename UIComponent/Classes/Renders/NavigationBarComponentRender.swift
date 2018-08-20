////  NavigationBarComponentRender.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation

extension NavigationBarComponent: UIKitRenderable {
    
    public func renderUIKit() -> UIKitRenderTree {
        let emptyView = UIView()
        emptyView.isHidden = true
        self.setupNavigationBar()
        self.config?(self.controller!.navigationController!.navigationBar)
        return .leaf(self, emptyView)
    }
    
    public func autoLayout(view: UIView) {}
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let navComp = newComponent as? NavigationBarComponent else {fatalError()}
        navComp.applyBaseAttributes(to: view)
        navComp.setupNavigationBar()
        return .leaf(newComponent, view)
    }
    
    private func createBarButton(title:String, action:Selector?)->UIBarButtonItem{
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: action)
        return button
    }
    
    @objc func onLeftButtonDidTouch(sender:UIButton){
        self.callbackOnClickLeftButton?()
    }
    
    @objc func onRightButtonDidTouch(sender:UIButton){
        self.callbackOnClickRightButton?()
    }
    
    private func setupNavigationBar(){
        guard let controller = self.controller, let _ = controller.navigationController  else {fatalError()}
        let setupTitle = self.setupTitle?()
        if let title = setupTitle{
            controller.navigationItem.title = title
        }
        if let leftButton = self.setupLeftButton?(){
            leftButton.action = #selector(self.onLeftButtonDidTouch)
            leftButton.target = self
            controller.navigationItem.leftBarButtonItem = leftButton
        }else if let title = self.leftButtonTitle{
            controller.navigationItem.leftBarButtonItem = createBarButton(title: title, action: #selector(self.onLeftButtonDidTouch))
        }
        if let rightButton = self.setupRightButton?(){
            rightButton.action = #selector(self.onRightButtonDidTouch)
            rightButton.target = self
            controller.navigationItem.rightBarButtonItem = rightButton
        }else if let title = self.rightButtonTitle{
            controller.navigationItem.rightBarButtonItem = createBarButton(title: title, action: #selector(self.onRightButtonDidTouch))
        }
    }
}
