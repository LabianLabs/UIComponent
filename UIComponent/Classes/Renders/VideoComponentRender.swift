////  VideoComponentRender.swift
//  UIComponent
//
//  Created by labs01 on 6/27/18.
//  Copyright © LabianLabs 2015
//

import UIKit
import AVKit
import Foundation
import AVFoundation

public class DefaultPlayerView: UIView {
    var playerView = PlayerView(),playButton = UIButton(),
    timeLabel = UILabel(), seekSlider = UISlider()
    var duration: CMTime {
        return self.playerView.player!.currentItem!.asset.duration
    }
    
    public var isPlay: Bool = false
    public var isAutoPlay: Bool = false
    public var callbackOnPlay: ((AVPlayer?)->Void)?
    public var callbackOnPause: ((AVPlayer?)->Void)?
    
    public func onPlay(_ callback: ((AVPlayer?)->Void)?) -> DefaultPlayerView{
        self.callbackOnPlay = callback
        return self
    }
    
    public func onPause(_ callback: ((AVPlayer?)->Void)?) -> DefaultPlayerView{
        self.callbackOnPause = callback
        return self
    }
    
    @objc func clickPlayButton(_ sender: UIButton) {
        isPlay = !isPlay
        isPlay ? self.callbackOnPlay?(nil) : self.callbackOnPause?(nil)
    }
    
    @objc func changeSeekSlider(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value) * self.duration.asDouble, preferredTimescale: 100)
        self.seekToTime(seekTime)
    }
    
    private func seekToTime(_ seekTime: CMTime) {
        self.playerView.player?.seek(to: seekTime)
        self.timeLabel.text = seekTime.description
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
        playerView.player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 100),
            queue: DispatchQueue.main,
            using: { (cmtime) in
                self.timeLabel.text = cmtime.description
        })
        _ = self.onPlay { (_) in
            print("Play")
            self.playButton.setTitle("STOP" , for: .normal)
            self.playerView.player?.play()
            }.onPause({ (_) in
                print("Pause")
                self.playButton.setTitle("PLAY" , for: .normal)
                self.playerView.player?.pause()
            })
        if isAutoPlay {
            playerView.player?.play()
            isPlay = isAutoPlay
        }
        playButton.setTitle(isPlay ? "STOP" : "PLAY" , for: .normal)
    }
    
    public func setupConstraints() {
        for item in [playerView,playButton,timeLabel,seekSlider] {
            self.addSubview(item)
        }
        constrain(playerView,playButton,timeLabel,seekSlider) {
            playerView,playButton,timeLabel,seekSlider in
            
            playerView.top == playerView.superview!.top
            playerView.left == playerView.superview!.left
            playerView.right == playerView.superview!.right
            playerView.height == playerView.superview!.height - 50
            
            timeLabel.height == 20
            timeLabel.width == 100
            timeLabel.left == playerView.left
            timeLabel.top == playerView.bottom
            
            playButton.height == 20
            playButton.width == 100
            playButton.right == playerView.right
            playButton.top == playerView.bottom
            
            seekSlider.top == timeLabel.bottom
            seekSlider.left == playerView.left + 50
            seekSlider.right == playerView.right - 50
            seekSlider.height == 30
        }
    }
}

extension VideoPlayerComponent: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        let defaultView = DefaultPlayerView()
        if let _ = self.url,let url = URL(string: self.url!) {
            let item = AVPlayerItem(url: url)
            defaultView.playerView.player = AVPlayer(playerItem: item)
            defaultView.isAutoPlay = self.isAutoPlay
            defaultView.isPlay = self.isAutoPlay
        }
        defaultView.setupView()
        self.applyBaseAttributes(to: defaultView)
        return .leaf(self, defaultView)
    }
    
    public func updateUIKit( _ view: UIView, change: Changes,
                             newComponent: UIKitRenderable, renderTree: UIKitRenderTree ) -> UIKitRenderTree {
        
        guard let defaultView = view as? DefaultPlayerView else { fatalError() }
        guard let newComponent = newComponent as? VideoPlayerComponent else { fatalError() }
        if self.url != newComponent.url, let _ = newComponent.url, let url = URL(string: newComponent.url!) {
            let item = AVPlayerItem(url: url)
            defaultView.playerView.player?.replaceCurrentItem(with: item)
//            defaultView.callbackOnPlay?(nil)
            return .leaf(newComponent, defaultView)
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
                view.height == 200
            }
        }
    }
    
    private func onFall(_ sender: AVPlayer,error: Error) {
        self.callbackOnFailure?(sender,error)
    }
}
extension VideoPlayerComponent: AVPlayerViewControllerDelegate,AVPlayerItemOutputPushDelegate{
    public func playerViewController(_ playerViewController: AVPlayerViewController,
                                     failedToStartPictureInPictureWithError error: Error) {
        self.callbackOnFailure?(playerViewController.player,error)
    }
    
}
