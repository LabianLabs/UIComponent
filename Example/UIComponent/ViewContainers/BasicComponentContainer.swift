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
    var userName:String
    var avatarUrl:String
    var step:Int = 3
    var background: String
    var url: String
    var isAutoPlay: Bool
    var isPlay: Bool
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
                <<< VideoPlayerComponent() {
                    
                    $0.layout = { c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top
                            view.left == view.superview!.left
                            view.right == view.superview!.right
                            view.height == 300
                        })
                    }
                    $0.isPlay = state.isPlay
                    $0.isAutoPlay = state.isAutoPlay
                    $0.url = state.url
                    }.onFailure{ (_, error) in
                        print("ERROR")
                    }.onPause({ (_) in
                        print("PAUSE")
                    }).onPlay({ (_) in
                        print("PLAY")
                    }).onStateChanged({ (player) in
                        print("CHANGE")
                    })
                <<< FollowComponent(){
                    $0.backgroundImage = UIImage(named: state.background)
                    $0.layout = { c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top
                            view.left == view.superview!.left
                            view.right == view.superview!.left + 100
                            view.height == 100
                        })
                    }
                    }.onFollow({ (_) in
                        print("follow")
                        self.update {
                            self.state = BasicViewState(userName: "", avatarUrl: "", step: 5, background: "download",
                                                        url: "blob:https://www.youtube.com/f275a1ae-0f2c-4f62-a3b3-28f1ce029cf7",
                                                        isAutoPlay: false, isPlay: true)
                        }
                    }).onUnFollow({ (_) in
                        print("unFollow")
                        self.update {
                            self.state = BasicViewState(userName: "", avatarUrl: "", step: 5, background: "download1",
                                                        url: "https://mnmedias.api.telequebec.tv/m3u8/29340.m3u8",
                                                        isAutoPlay: true, isPlay: false)
                        }
                    })
                <<< NavigationBarComponent(){
                        $0.host = viewController
                        $0.setupTitle = {
                            return "Custom Title"
                        }
                        $0.rightButtonTitle = "Done"
                    }.OnClickLeftButton {
                        print("OnClickLeftButton")
                    }.OnClickRightButton {
                        print("OnClickRightButton")
                    }
//                <<< SegmentComponent(["1", "2", "3"]){
//                    $0.tag = "SEGMENT"
//                    $0.layout = { c, view in
//                        constrain(c.viewByTag("SEARCHBAR") as! UIView, view) { v1, v2 in
//                            v2.top == v1.bottom
//                            v2.left == v2.superview!.left
//                            v2.right == v2.superview!.right
//                            v2.height == 44
//                        }
//                    }
//                }
//                <<< ViewComponent<CustomViewComponent>(){
//                    $0.nibFile = "CustomViewComponent"
//                    $0.render = { view in
//                        view.userName = "111"
//                    }
//                    $0.layout = { c, view in
//                        view.loHeightInParent(0.3).loBellow(c.viewByTag("SEGMENT") as! UIView)
//                    }
//                }
//                <<< FloatComponent<CustomViewComponent>(){
//                    $0.nibFile = "CustomViewComponent"
//                }
            }
    }
}
