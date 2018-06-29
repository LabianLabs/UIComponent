////  VideoComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 6/27/18.
//  Copyright © LabianLabs 2015
//

import AVKit
import Foundation
import AVFoundation

internal protocol DefaultPlayerDelegate: class {
    func onPlay(_ player: AVPlayer?)
    func onPause(_ player: AVPlayer?)
    func onStateChanged(_ player: AVPlayer?)
    func onFailure(_ player: AVPlayer?, error: Error?)
}

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

// DefaultPlayerView
class DefaultPlayerView: UIView {
    var playerView = PlayerView(),playButton = UIButton(),
    timeLabel = UILabel(), seekSlider = UISlider()
    var duration: CMTime {
        return self.playerView.player!.currentItem!.asset.duration
    }
    internal var delegate: DefaultPlayerDelegate?
    public var isPlay: Bool = false
    public var isAutoPlay: Bool = false
    public var callbackOnPlay: ((AVPlayer?)->Void)?
    public var callbackOnPause: ((AVPlayer?)->Void)?
    
    private func onPlay(_ callback: ((AVPlayer?)->Void)?) -> DefaultPlayerView{
        self.callbackOnPlay = callback
        return self
    }
    
    private func onPause(_ callback: ((AVPlayer?)->Void)?) -> DefaultPlayerView{
        self.callbackOnPause = callback
        return self
    }
    
    @objc func clickPlayButton(_ sender: UIButton) {
        isPlay ? self.callbackOnPause?(nil) : self.callbackOnPlay?(nil)
    }
    
    @objc func changeSeekSlider(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value) * self.duration.asDouble, preferredTimescale: 100)
        self.playerView.player?.seek(to: seekTime)
        self.timeLabel.text = seekTime.description
        self.delegate?.onStateChanged(self.playerView.player)
    }
    
    public func setupView() {
        commonSetup()
        setupConstraints()
    }
    
    public func commonSetup() {
        playButton.backgroundColor = UIColor.gray
        playerView.backgroundColor = UIColor.gray
        timeLabel.text = kCMTimeZero.description
        
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        seekSlider.addTarget( self, action: #selector(changeSeekSlider), for: .valueChanged)
        playerView.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status),
                                       options:[.new, .initial], context: nil)
        
        playerView.player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 100),
            queue: DispatchQueue.main,
            using: { (cmtime) in
                self.timeLabel.text = cmtime.description
                self.seekSlider.value = cmtime.asFloat / self.duration.asFloat
        })
        
        if isAutoPlay {
            playerView.player?.play()
        }
        
        _ = self.onPlay { (_) in
            self.isPlay = true
            self.playButton.setTitle("STOP" , for: .normal)
            self.playerView.player?.play()
            self.delegate?.onPlay(self.playerView.player)
            self.delegate?.onStateChanged(self.playerView.player)
            }
        _ = onPause({ (_) in
                self.isPlay = false
                self.playButton.setTitle("PLAY" , for: .normal)
                self.playerView.player?.pause()
                self.delegate?.onPause(self.playerView.player)
                self.delegate?.onStateChanged(self.playerView.player)
            })
    }
    
    public func setupConstraints() {
        for item in [playerView,playButton,timeLabel,seekSlider] {
            self.addSubview(item)
        }
        constrain(playerView,playButton,timeLabel,seekSlider) {
            playerView,playButton,timeLabel,seekSlider in
            
            timeLabel.width == 50
            timeLabel.height == 30
            playButton.width == 100
            timeLabel.top == playerView.bottom
            playerView.height == playerView.superview!.height - 30
            
            align(top: [playerView,playerView.superview!])
            align(top: [timeLabel,seekSlider,playButton])
            align(bottom: [timeLabel,seekSlider,playButton])
            align(left: [playerView,playerView.superview!,timeLabel])
            align(right: [playerView,playerView.superview!,playButton])
            distribute(by: 10, leftToRight: [timeLabel,seekSlider,playButton])
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        guard context == nil else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                print("readyToPlay")
                break
            case .failed:
                delegate?.onFailure(self.playerView.player, error: self.playerView.player?.error)
                break
            case .unknown:
                print("unknown")
                break
            }
        }
    }
}

// extension for VideoPlayerComponent
extension VideoPlayerComponent: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        let defaultView = DefaultPlayerView()
        defaultView.delegate = self
        if let _ = self.url,let url = URL(string: self.url!) {
            defaultView.playerView.player = AVPlayer(playerItem: getAVPlayerItem(url: url))
            defaultView.isAutoPlay = self.isAutoPlay
        }
        defaultView.setupView()
        self.isPlay ? defaultView.callbackOnPlay?(nil) : defaultView.callbackOnPause?(nil)
        self.applyBaseAttributes(to: defaultView)
        return .leaf(self, defaultView)
    }
    
    public func updateUIKit( _ view: UIView, change: Changes,
                             newComponent: UIKitRenderable, renderTree: UIKitRenderTree ) -> UIKitRenderTree {
        
        guard let defaultView = view as? DefaultPlayerView else { fatalError() }
        guard let newComponent = newComponent as? VideoPlayerComponent else { fatalError() }
        if self.url != newComponent.url, let _ = newComponent.url,  let url = NSURL(string: newComponent.url!) {
            defaultView.playerView.player?.replaceCurrentItem(with: getAVPlayerItem(url: url as URL))
            defaultView.isAutoPlay = self.isAutoPlay
        }
        newComponent.isPlay ? defaultView.callbackOnPlay?(nil) : defaultView.callbackOnPause?(nil)
        return .leaf(newComponent, defaultView)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(self, view)
        } else {
            constrain(view) { view in
                view.top == view.superview!.top
                view.left == view.superview!.left
                view.right == view.superview!.right
                view.height == 300
            }
        }
    }
    
    private func getAVPlayerItem(url:URL) -> AVPlayerItem {
        let asset = AVAsset(url: url)
        let assetKeys = [ "playable", "hasProtectedContent" ]
        let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        return item
    }
}

extension VideoPlayerComponent: DefaultPlayerDelegate {
    internal func onPause(_ player: AVPlayer?) {
        self.callbackOnPause?(player)
    }
    
    internal func onPlay(_ player: AVPlayer?) {
        self.callbackOnPlay?(player)
    }
    
    internal func onStateChanged(_ player: AVPlayer?) {
        self.callbackOnStateChanged?(player)
    }
    
    internal func onFailure(_ player: AVPlayer?, error: Error?) {
        self.callbackOnFailure?(player,error)
    }
}
