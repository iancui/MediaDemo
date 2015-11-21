//
//  ViewController.swift
//  MediaDemo
//
//  Created by Ian on 15/11/20.
//  Copyright © 2015年 AppCode. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let sharedManager = AudioManager()  // singleton
    var audioPlayer: AVAudioPlayer!
}
class ViewController: UIViewController {

    var audioPlayer = AudioManager.sharedManager.audioPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            
        }
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")
        let pathURL=NSURL(fileURLWithPath: path!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: pathURL)
        } catch {
            audioPlayer = nil
        }
        
        audioPlayer?.prepareToPlay()
        
        
        let playbtn = UIButton()
        playbtn.frame = CGRectMake(60 , 200, 100, 40)
        playbtn.backgroundColor = UIColor.cyanColor()
        playbtn.setTitle("play", forState: .Normal)
        playbtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        
        let pausebtn = UIButton(frame: CGRectMake(180 , 200, 100, 40) )
        pausebtn.setTitle("pause", forState: .Normal)
        pausebtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        pausebtn.backgroundColor = UIColor.cyanColor()
        
        
        playbtn.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
        pausebtn.addTarget(self, action: "pause", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(playbtn)
        self.view.addSubview(pausebtn)

        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        self.setLockView()
        
    }
    
    func setLockView(){
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyTitle:"第一夫人",
            MPMediaItemPropertyArtist:"张杰",
            MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: UIImage(named: "img.jpeg")!),
            MPNowPlayingInfoPropertyPlaybackRate:1.0,
            MPMediaItemPropertyPlaybackDuration:audioPlayer.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime:audioPlayer.currentTime
        ]
    }
    
    func play(){
        audioPlayer.play()
    }
    
    func pause(){
        audioPlayer.pause()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        switch event!.subtype {
        case .RemoteControlPlay:  // play按钮
            audioPlayer.play()
        case .RemoteControlPause:  // pause按钮
            audioPlayer.pause()
        case .RemoteControlNextTrack:  // next
            // ▶▶ 押下時の処理
            break
        case .RemoteControlPreviousTrack:  // previous
            // ◀◀ 押下時の処理
            break
        default:
            break
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

