////  VideoComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/27/18.
//  Copyright © LabianLabs 2015
//

import AVKit
import Foundation
import AVFoundation

public class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}


extension CMTime {
    var asDouble: Double {
        get {
            return Double(self.value) / Double(self.timescale)
        }
    }
    var asFloat: Float {
        get {
            return Float(self.value) / Float(self.timescale)
        }
    }
}

extension CMTime: CustomStringConvertible {
    public var description: String {
        get {
            let seconds = Int(round(self.asDouble))
            return String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }
    }
}



public final class VideoComponent : BaseComponent,ComponentType {
    public var isPlay: Bool = true
    public var videoURL: URL? = URL(string: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8")
    public var callbackOnStop:((Any?)->Void)?
    public var callbackOnPlay:((Any?)->Void)?
    public func onPlay(_ callback: ((Any?)->Void)?)->VideoComponent{
        self.callbackOnPlay = callback
        return self
    }
    
    public func onStop(_ callback: ((Any?)->Void)?)->VideoComponent{
        self.callbackOnStop = callback
        return self
    }
}
