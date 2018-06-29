////  BasicComponentViewController.swift
//  UIComponent_Example
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import UIKit
import AVKit
import Foundation
import UIComponent
import AVFoundation


class BasicComponentViewController:UIViewController,AVPlayerViewControllerDelegate{
    var container: BasicComponentContainer?
    var count = 12
    var section = 0
    weak var timer:Timer?
    
    override func viewDidLoad() {
        let state = BasicViewState(userName: "test",
                                   avatarUrl: "test",
                                   step: 1, background: "background1",
                                   url: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8",
                                   isAutoPlay: true,
                                   isPlay: true)
        let container = BasicComponentContainer(controller: self, state: state)
        RenderView.render(container: container, in: self)
        self.container = container
    }
    
    
}







