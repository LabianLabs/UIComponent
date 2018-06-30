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
    var url: String
    var isAutoPlay: Bool
    var isPlay: Bool
    var seek: Double
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
                    $0.seekValue = Float(state.seek)
                    }.onFailure{ (_, error) in
                        print("ERROR")
                    }.onPause({ (_) in
                        print("PAUSE")
                    }).onPlay({ (_) in
                        print("PLAY")
                    }).onStateChanged({ (player) in
                        print("CHANGE")
                    })
                <<< ButtonComponent() {
                    $0.title = "Change video"
                    $0.layout = {c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top + 300
                            view.left == view.superview!.left
                            view.right == view.superview!.right
                            view.height == 50
                        })
                    }
                    }.onClick({ (_) in
                        self.update {
                            let url = state.url != "https://mnmedias.api.telequebec.tv/m3u8/29346.m3u8"
                                ? "https://mnmedias.api.telequebec.tv/m3u8/29346.m3u8"
                                : "https://mnmedias.api.telequebec.tv/m3u8/29340.m3u8"
                            self.state = BasicViewState(url: url ,
                                                        isAutoPlay: state.isAutoPlay,
                                                        isPlay: state.isPlay,
                                                        seek: 0)
                        }
                    })
                <<< ButtonComponent() {
                    $0.title = "Re-render(state not change)"
                    $0.layout = {c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top + 350
                            view.left == view.superview!.left
                            view.right == view.superview!.right
                            view.height == 50
                        })
                    }
                    }.onClick({ (_) in
                        self.update {
                            self.state = BasicViewState(url: state.url,
                                                        isAutoPlay: state.isAutoPlay,
                                                        isPlay: state.isPlay,
                                                        seek: 0)
                        }
                    })
                <<< ButtonComponent() {
                    $0.title = "PLAY"
                    $0.layout = {c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top + 400
                            view.left == view.superview!.left
                            view.right == view.superview!.right
                            view.height == 50
                        })
                    }
                    }.onClick({ (_) in
                        self.update {
                            self.state = BasicViewState(url: state.url,
                                                        isAutoPlay: state.isAutoPlay,
                                                        isPlay: true,
                                                        seek: 0 )
                        }
                    })
                <<< ButtonComponent(tag: "pause") {
                    $0.title = "PAUSE"
                    $0.layout = {c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top + 450
                            view.left == view.superview!.left
                            view.right == view.superview!.right
                            view.height == 50
                        })
                    }
                    }.onClick({ (_) in
                        self.update {
                            self.state = BasicViewState(url: state.url,
                                                        isAutoPlay: state.isAutoPlay,
                                                        isPlay: false,
                                                        seek: 0)
                        }
                    })
                <<< ButtonComponent() {
                    $0.title = "SEEK change value"
                    $0.layout = {c,view in
                        constrain(view, block: { (view) in
                            view.top == view.superview!.top + 500
                            view.left == view.superview!.left
                            view.right == view.superview!.right
                            view.height == 50
                        })
                    }
                    }.onClick({ (_) in
                        self.update {
                            self.state = BasicViewState(url: state.url,
                                                        isAutoPlay: state.isAutoPlay,
                                                        isPlay: state.isPlay,
                                                        seek: 0.25 )
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
            }
    }
}
