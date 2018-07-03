//
//  ViewComponent.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIComponent

struct BasicViewState{
    var data : [Data]
}

class BasicComponentContainer:BaseComponentRenderable<BasicViewState>{
    weak var viewController: BasicComponentViewController?

    public init(controller: BasicComponentViewController, state: BasicViewState){
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: BasicViewState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.layout = {c, v in
                constrain(v){ view in
                    view.left == view.superview!.left
                    view.top == view.superview!.top + 64
                    view.width == view.superview!.width
                    view.bottom == view.superview!.bottom
                }
            }
            $0.children
                <<< FormComponent(viewController!) {
                    $0.layout = {c,v in
                        v.loFillInParent()
                    }
                    $0.render = { form in
                        form +++ ContainerRow() {
                            $0.children
                                <<< ViewComponent<FeedCommentComponent>() {
                                    $0.nibFile = "FeedCommentComponent"
                                    $0.tag = "v1"
                                    $0.layout = {c,v in
                                        constrain(v , block: { (view) in
                                            view.top == view.superview!.top
                                            view.left == view.superview!.left
                                            view.right == view.superview!.right
                                        })
                                        (v as! FeedCommentComponent).delegate = self
                                    }
                                    $0.value = state.data[0]
                                }
                                <<< ViewComponent<FeedCommentComponent>() {
                                    $0.nibFile = "FeedCommentComponent"
                                    $0.tag = "v2"
                                    $0.layout = {c,v in
                                        let topView = c.viewByTag("v1") as! UIView
                                        constrain(v,topView , block: { (view,topView) in
                                            view.top == topView.bottom
                                            view.left == view.superview!.left
                                            view.right == view.superview!.right
                                        })
                                        (v as! FeedCommentComponent).delegate = self
                                    }
                                    $0.value = state.data[1]
                                }
                                <<< ViewComponent<FeedCommentComponent>() {
                                    $0.nibFile = "FeedCommentComponent"
                                    $0.layout = {c,v in
                                        let topView = c.viewByTag("v2") as! UIView
                                        constrain(v,topView , block: { (view,topView) in
                                            view.top == topView.bottom
                                            view.left == view.superview!.left
                                            view.right == view.superview!.right
                                            view.bottom == view.superview!.bottom
                                        })
                                        (v as! FeedCommentComponent).delegate = self
                                    }
                                    $0.value = state.data[2]
                                    
                            }
                        }
                    }
            }
            }
    }
}

extension BasicComponentContainer: FeedCommentComponentDeledate {
    func commentDidTouch() {
        print("Comment did touch")
    }
}
