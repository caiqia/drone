//
//  DataViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit
import MediaPlayer

class DanceEditorViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var sliderTimer: UISlider!
    var dataObject: String = ""
    // qiaoshan :
    var audioPlayer = AVAudioPlayer()
    let mp = MPMusicPlayerController.systemMusicPlayer()
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // qiaoshan : The audio file is extracted from the Application's bundle
        mp.prepareToPlay()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.timerFired(_:)), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        mp.beginGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.updateNowPlayingInfo), name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }
    //qioashan :
    func updateNowPlayingInfo(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.timerFired(_:)), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
    }

}

