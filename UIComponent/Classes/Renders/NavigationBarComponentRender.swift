////  NavigationBarComponentRender.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation
extension NavigationBarComponent{
    var hostController: UIViewController?{
        return host as? UIViewController
    }
    
    public convenience init(host: UIViewController,_ initializer: (NavigationBarComponent)->Void = {_ in}) {
        self.init(nil, host, initializer)
    }
    
    public convenience init(_ tag: String? = nil,_ host: UIViewController,_ initializer: (NavigationBarComponent)->Void = {_ in}) {
        self.init(tag)
        self.host = host
        initializer(self)
    }
}
extension NavigationBarComponent: UIKitRenderable {
    
    public func renderUIKit() -> UIKitRenderTree {
        let emptyView = UIView()
        emptyView.isHidden = true
        self.setupNavigationBar(for: self)
        return .leaf(self, emptyView)
    }
    
    public func autoLayout(view: UIView) {}
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let navComp = newComponent as? NavigationBarComponent else {fatalError()}
        self.setupNavigationBar(for: navComp)
        return .leaf(newComponent, view)
    }
    
    private func createBarButton(title:String, action:Selector?)->UIBarButtonItem{
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: action)
        return button
    }
    
    @objc internal func onLeftButtonDidTouch(sender:UIButton){
        self.callbackOnClickLeftButton?()
    }
    
    @objc internal func onRightButtonDidTouch(sender:UIButton){
        self.callbackOnClickRightButton?()
    }
    
    private func setupNavigationBar(for component:NavigationBarComponent){
        guard let controller = self.host as? UIViewController, let _ = controller.navigationController  else {fatalError()}
        let setupTitle = self.setupTitle?()
        if let title = setupTitle as? String{
            controller.navigationItem.title = title
        }else if let titleView = setupTitle as? UIView{
            controller.navigationItem.titleView = titleView
        }
        if let leftButton = self.setupLeftButton?(), let item = leftButton as? UIBarButtonItem{
            item.action = #selector(onLeftButtonDidTouch(sender:))
            item.target = self
            controller.navigationItem.leftBarButtonItem = item
        }else if let title = self.leftButtonTitle{
            controller.navigationItem.leftBarButtonItem = createBarButton(title: title, action: #selector(onLeftButtonDidTouch(sender:)))
        }
        if let rightButton = self.setupRightButton?(), let item = rightButton as? UIBarButtonItem{
            item.action = #selector(onRightButtonDidTouch(sender:))
            item.target = self
            controller.navigationItem.rightBarButtonItem = item
        }else if let title = self.rightButtonTitle{
            controller.navigationItem.rightBarButtonItem = createBarButton(title: title, action: #selector(onRightButtonDidTouch(sender:)))
        }
    }
}
