////  VideoComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/27/18.
//  Copyright © LabianLabs 2015
//

import AVKit
import Foundation
import AVFoundation

public final class VideoPlayerComponent : BaseComponent,ComponentType {
    public var isPlay: Bool = true
    public var isAutoPlay: Bool = true
    public var render:((VideoPlayerComponent)->Void)?
    public var url: String?
    public var callbackOnPlay:((AVPlayer?)->Void)?
    public var callbackOnPause:((AVPlayer?)->Void)?
    public var callbackOnStateChanged:((AVPlayer?)->Void)?
    public var callbackOnFailure:((AVPlayer?,Error?)->Void)?
    
    public func onPlay(_ callback: ((AVPlayer?)->Void)?) -> VideoPlayerComponent{
        self.callbackOnPlay = callback
        return self
    }

    public func onPause(_ callback: ((AVPlayer?)->Void)?) -> VideoPlayerComponent{
        self.callbackOnPause = callback
        return self
    }
    
    public func onStateChanged(_ callback: ((AVPlayer?)->Void)?) -> VideoPlayerComponent{
        self.callbackOnStateChanged = callback
        return self
    }
    
    public func onFailure(_ callback: ((AVPlayer?,Error?)->Void)?) -> VideoPlayerComponent{
        self.callbackOnFailure = callback
        return self
    }
}
