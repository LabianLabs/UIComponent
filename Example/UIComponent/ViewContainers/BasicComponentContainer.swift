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
    var data: Data
}

class BasicComponentContainer:BaseComponentRenderable<BasicViewState>{
    weak var viewController: BasicComponentViewController?

    public init(controller: BasicComponentViewController, state: BasicViewState){
        self.viewController = controller
        super.init(state: state)
    }
    
    open override func render(_ state: BasicViewState) -> ComponentContainer {
        return EmptyViewComponent(){
            $0.children
            <<< FormComponent(viewController!) {
                $0.layout = {c,v in
                    v.loFillInParent()
                }
                $0.render = {form in
                    form +++ ContainerRow() {
                        $0.children
                        <<< ViewComponent<FeedInfoUserComponent>() {
                            $0.tag = "info"
                            $0.nibFile = "FeedInfoUserComponent"
                            $0.layout = {c,v in
                                constrain(v, block: { (view) in
                                    view.top == view.superview!.top 
                                    view.left == view.superview!.left
                                    view.right == view.superview!.right
                                })
                                (v as! FeedInfoUserComponent).delegate = self
                            }
                            $0.value = state.data
                        }
                            <<< ButtonComponent() {
                                $0.tag = "l1"
                                $0.title = "Post Video"
                                $0.layout = { c, v in
                                    let infoView = (c.viewByTag("info") as! UIView)
                                    constrain(v,infoView) { v,v2 in
                                        v.left == v.superview!.left
                                        v.right == v.superview!.right
                                        v.top == v2.bottom
                                    }
                                }
                                }.onClick({ (_) in
                                    self.update {
                                        self.state = BasicViewState(data: Data(actor: "Sherwin",
                                                                               actee: "",
                                                                               rank: 0,
                                                                               url: "download",
                                                                               date: Date() + (-3).minutes))
                                    }
                                })
                            <<< ButtonComponent(){
                                $0.title  = "Change rank"
                                $0.layout = { c, v in
                                    let l1 = (c.viewByTag("l1") as! UIView)
                                    constrain(v, l1){ v, v2 in
                                        v.left == v.superview!.left
                                        v.right == v.superview!.right
                                        v.top == v2.bottom
                                        v.bottom == v.superview!.bottom
                                    }
                                }
                                }.onClick({ (_) in
                                    self.update {
                                        self.state = BasicViewState(data: Data(actor: "Sherwin",
                                                                               actee: "Adline",
                                                                               rank: 6,
                                                                               url: "download",
                                                                               date: Date() + (-6).hours))
                                    }
                                })
                    }
                }
            }
            
        }
    }
}
extension BasicComponentContainer: FeedInfoUserDelegate {
    func onOptionDidTouch() {
        print("TRS")
    }
    
    
}
