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
    timeLabel = UILabel(), seekSlider : UISlider!
    var duration: CMTime {
        return self.playerView.player!.currentItem!.asset.duration
    }
    public var isPlay = true
    
    @objc func clickPlayButton(_ sender: UIButton) {
        self.isPlay = !self.isPlay
        self.playButton.setTitle(isPlay ? "PLAY" : "STOP", for: .normal)
        self.isPlay ? self.playerView.player?.pause() : self.playerView.player?.play()
    }
    
//    @objc func changeSeekSlider(_ sender: UISlider) {
//        let seekTime = CMTime(seconds: Double(sender.value) * self.duration.asDouble, preferredTimescale: 100)
//        self.seekToTime(seekTime)
//    }
//
//    private func seekToTime(_ seekTime: CMTime) {
//        print(seekTime)
//        self.playerView.player?.seek(to: seekTime)
//        self.timeLabel.text = seekTime.description
//    }
    
    private func setSeekSlider() -> UISlider {
        let slider = UISlider()
        slider.addTarget(
            self,
            action: #selector(self.changeSeekSlider(_:)),
            for: UIControlEvents.valueChanged)
        return slider
    }
    
    @objc func changeSeekSlider(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value) * self.duration.asDouble, preferredTimescale: 100)
        self.seekToTime(seekTime)
    }
    
    private func seekToTime(_ seekTime: CMTime) {
        print(seekTime)
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
        playButton.setTitle("PLAY", for: .normal)
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
//        seekSlider.addTarget( self, action: #selector(changeSeekSlider), for: .valueChanged)
        
        seekSlider = setSeekSlider()
        playerView.player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 100),
            queue: DispatchQueue.main,
            using: { (cmtime) in
                print(cmtime)
                self.timeLabel.text = cmtime.description
        })
        seekSlider.addTarget(self, action: #selector(changeSeekSlider), for: .valueChanged)
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
            
            timeLabel.top == playerView.bottom
            timeLabel.height == 20
            timeLabel.width == 100
            timeLabel.left == playerView.left
            
            playButton.top == playerView.bottom
            playButton.height == 20
            playButton.width == 100
            playButton.right == playerView.right
            
            seekSlider.top == timeLabel.bottom
            seekSlider.left == playerView.left
            seekSlider.right == playerView.right
            seekSlider.height == 30
        }
    }
}

extension VideoComponent: UIKitRenderable {
    public func renderUIKit() -> UIKitRenderTree {
        let playerView = DefaultPlayerView()
        playerView.setupView()
        playerView.isPlay = self.isPlay
        playerView.playerView.player = AVPlayer(url: self.videoURL!)
        self.applyBaseAttributes(to: playerView)
        self.isPlay = true
        return .leaf(self, playerView)

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
    @objc public func onButtonDidTouch(sender:UIButton){
        self.isPlay = !self.isPlay
        self.isPlay ? self.callbackOnStop?(sender) : self.callbackOnPlay?(sender)
    }
}
