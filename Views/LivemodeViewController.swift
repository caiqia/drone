//
//  LivemodeViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit
import CoreMotion


class LivemodeViewController: UIViewController {
    
    @IBOutlet var bg: UILabel!
    var gaz = 0
    var motionManager = CMMotionManager()
    var timer = Timer()
    var comtimer = Timer()
    var started = false
    var isflying = false
    let mm = MotionManager()
    var x = 0.0
    var y = 0.0
    var z = 0.0
    
    
    @IBAction func take_off(_ sender: Any) {
    }
    
    @IBAction func back_touched(_ sender: Any) {
        if DroneController.isReady()
        {
            DroneController.land()
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DroneController.droneControllerInit()
        // Create gesture recognizers and add them to super view
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeLeftOccured))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 2
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeRightOccured))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 2
        view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeUpOccured))
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 2
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeDownOccured))
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 2
        view.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LivemodeViewController.TapOccured))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func TapOccured(swipe: UITapGestureRecognizer){
        if (started)
        {
            print("Live Ending")
            mm.stopUpdates()
            if(DroneController.isReady())
            {DroneController.land()}
            started = false
        }
        else
        {
            if DroneController.isReady()
            {
                DroneController.takeoff()
                sleep(5)
            }
            mm.startUpdates()
            print("Live Starting.. Took off")
            self.view.backgroundColor = UIColor.white
            bg.isHidden = false
            started = true
            let ops = self.view.subviews.compactMap { $0 as? UIButton }
            ops.forEach { (op) in
                op.alpha = 1
            }
        }
    }
    
    @objc func swipeRightOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped right")
        self.view.backgroundColor = UIColor.yellow
        bg.isHidden = true
        
    }
    @objc func swipeLeftOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped left")
        self.view.backgroundColor = UIColor.red
        bg.isHidden = true
    }
    
    @objc func swipeUpOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped up")
        self.view.backgroundColor = UIColor.green
        bg.isHidden = true
    }
    
    @objc func swipeDownOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped down")
        self.view.backgroundColor = UIColor.cyan
        bg.isHidden = true
    }
    
}
