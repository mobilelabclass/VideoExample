//
//  ViewController.swift
//  VideoExample
//
//  Created by Sebastian Buys on 3/22/18.
//  Copyright © 2018 mobilelab. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    // We could use an AVPlayerViewController, but since we want to do something custom, we create our own player view
    // See:
    // https://developer.apple.com/documentation/avkit/avplayerviewcontroller
    @IBOutlet weak var playerView: PlayerView!

    // AVPlayer is used to playback our videos
    // https://developer.apple.com/documentation/avfoundation/avplayer
    let player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Custom function written for setting up our video player.
        setupVideoPlayer()
    }
    
    func setupVideoPlayer() {
        
        // Guard allows us to make sure we have a valid video resource before we go any further
        guard let videoUrl = Bundle.main.url(forResource: "trailer_1080p", withExtension: "mov") else {
            print("Error: Could not find video!")
            return // If we can't find the video, we do nothing
        }
        
        // Create a video item from our resource
        // https://developer.apple.com/documentation/avfoundation/avplayeritem
        let videoItem = AVPlayerItem(url: videoUrl)
        self.player.replaceCurrentItem(with: videoItem)

        // Quick and easy way to mask
        self.playerView.layer.cornerRadius = self.playerView.frame.width / 2.0
        self.playerView.layer.masksToBounds = true
        
        // Fill the whole box
        self.playerView.playerLayer.videoGravity = .resizeAspectFill
        
        // Assign our player to our custom playerView
        self.playerView.player = self.player
        
        // Some logic for looping
        self.loopPlayer()
        
        // Start playing
        self.player.play()
    }
    
    func loopPlayer() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player.seek(to: kCMTimeZero)
            self.player.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

