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






class PlayerView: UIView {
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
    override static var layerClass: AnyClass {
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

class BasicComponentViewController:UIViewController,AVPlayerViewControllerDelegate{
    var container: BasicComponentContainer?
    var count = 12
    var section = 0
    weak var timer:Timer?
    
    var playButton: UIButton!
    var playerView: PlayerView!
    var playerTimeLabel: UILabel!
    var seekSlider: UISlider!
    var isPlay: Bool = false
    var videoURL: URL! = URL(string: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8")
    
    var duration: CMTime {
        return self.playerView.player!.currentItem!.asset.duration
    }
    
    convenience init(url: String) {
        self.init()
        self.videoURL = URL(string: url)!
    }
    
    override func viewDidLoad() {
        let state = BasicViewState(userName: "test",
                                   avatarUrl: "test",
                                   step: 1, background: "background1",
                                   url: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8",
                                   isAutoPlay: true,
                                   isPlay: false)
        let container = BasicComponentContainer(controller: self, state: state)
        RenderView.render(container: container, in: self)
        self.container = container
    }
    
    private func setTextLabel(cmtime: CMTime) -> UILabel {
        let label = UILabel()
        label.text = cmtime.description
        label.frame = CGRect(x: 0, y: 350, width: 100, height: 50)
        return label
    }
    
    private func setSeekSlider() -> UISlider {
        let slider = UISlider()
        slider.frame = CGRect(x: 0, y: 400, width: 320, height: 50)
        slider.addTarget(
            self,
            action: #selector(self.changeSeekSlider(_:)),
            for: .valueChanged)
        return slider
    }
    
    @objc func changeSeekSlider(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value) * self.duration.asDouble, preferredTimescale: 100)
        self.seekToTime(seekTime)
    }
    
    private func seekToTime(_ seekTime: CMTime) {
        print(seekTime)
        self.playerView.player?.seek(to: seekTime)
        self.playerTimeLabel.text = seekTime.description
    }
    
    private func setPlayerView() -> PlayerView {
        let player = AVPlayer(url: self.videoURL)
        let playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        playerView.player = player
        return playerView
    }
    
    private func setPlayButton() -> UIButton {
        let playButton = UIButton()
        playButton.frame = CGRect(x: 0, y: 300, width: 100, height: 30)
        playButton.backgroundColor = UIColor.gray
        playButton.layer.masksToBounds = true
        playButton.setTitle("PLAY", for: .normal)
        playButton.layer.cornerRadius = 8.0
        playButton.addTarget(
            self,
            action: #selector(self.clickPlayButton(_:)),
            for: .touchUpInside)
        return playButton
    }
    
    @objc func clickPlayButton(_ sender: UIButton) {
        playButton.setTitle(isPlay ? "PLAY" : "STOP", for: .normal)
        isPlay ? playerView.player?.pause() : playerView.player?.play()
        self.isPlay = !self.isPlay
        print("clicked -> \(isPlay)")
    }
}







