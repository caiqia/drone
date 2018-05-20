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
    @IBOutlet var up: UIButton!
    
    @IBOutlet var down: UIButton!
    
    @IBOutlet var forward: UIButton!
    
    @IBOutlet var backward: UIButton!
    
    @IBOutlet var right: UIButton!
    
    @IBOutlet var left: UIButton!
    
    @IBOutlet var flip_front: UIButton!
    
    @IBOutlet var flip_back: UIButton!
    
    @IBOutlet var flip_right: UIButton!
    
    @IBOutlet var flip_left: UIButton!
    
    @IBOutlet var wifi_icon: UIButton!
    
    @IBOutlet var batt_icon: UIButton!
    
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
        ui_will_hide()
    }
    
    @objc func ui_will_hide()
    {
        mm.stopUpdates()
        mm.stablisie()
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
        
        let swipeforward = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeforwardOccured))
        swipeforward.direction = .up
        swipeforward.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipeforward)
        
        let swipebackward = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipebackwardOccured))
        swipebackward.direction = .down
        swipebackward.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipebackward)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LivemodeViewController.TapOccured))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 2
        let tape = UITapGestureRecognizer(target: self, action: #selector(LivemodeViewController.DTapOccured))
        tape.numberOfTapsRequired = 2
        tape.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tape)
        bg.isHidden = true
        let flipg = UIRotationGestureRecognizer(target: self, action: #selector(self.flips))
        
        view.addGestureRecognizer(flipg)
        NotificationCenter.default.addObserver(self, selector: #selector (self.ui_will_hide), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (self.ui_will_hide), name: NSNotification.Name.UIWindowDidResignKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (self.ui_will_hide), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func flips()
    {
        if(mm.flip_back_enabled == false)
        {mm.flip_back_enabled = true
            mm.flip_left_enabled = true
            mm.flip_front_enabled = true
            mm.flip_right_enabled = true
            flip_back.alpha = 1
            flip_left.alpha = 1
            flip_front.alpha = 1
            flip_right.alpha = 1
        }
        else
        {mm.flip_back_enabled = false
            mm.flip_left_enabled = false
            mm.flip_front_enabled = false
            mm.flip_right_enabled = false
            flip_left.alpha = 0.2
            flip_front.alpha = 0.2
            flip_right.alpha = 0.2
            flip_back.alpha = 0.2
        }
    }
    @objc func TapOccured(swipe: UITapGestureRecognizer){
        if (started)
        {
            print("Live Ending")
            mm.stopUpdates()
            if(DroneController.isReady())
            {DroneController.land()}
            mm.stablisie()
            started = false
            bg.isHidden = true
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
            bg.backgroundColor = UIColor.white
            bg.isHidden = false
            started = true
            let ops = self.view.subviews.compactMap { $0 as? UIButton }
            ops.forEach { (op) in
                op.alpha = 1
            }
        }
    }
    
    @objc func DTapOccured(swipe: UITapGestureRecognizer){
        print("land emergency")
        DroneController.emergency_land()
    }
    
    @objc func swipeRightOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped right")
        bg.backgroundColor = UIColor.yellow
        bg.isHidden = false
        if(mm.right_enabled == false)
        {mm.right_enabled = true
            right.alpha = 1
        }
        else
        {mm.right_enabled = false
            right.alpha = 0.2
        }
    }
    @objc func swipeLeftOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped left")
        bg.backgroundColor = UIColor.red
        bg.isHidden = false
        if(mm.left_enabled == false)
        {mm.left_enabled = true
            left.alpha = 1
        }
        else
        {mm.left_enabled = false
            left.alpha = 0.2
        }
    }
    
    @objc func swipeUpOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped up")
        bg.backgroundColor = UIColor.green
        bg.isHidden = false
        if(mm.up_enabled == false)
        {mm.up_enabled = true
            up.alpha = 1
        }
        else
        {mm.up_enabled = false
            up.alpha = 0.2
        }
    }
    
    @objc func swipeDownOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped down")
        bg.backgroundColor = UIColor.cyan
        bg.isHidden = false
        if(mm.down_enabled == false)
        {mm.down_enabled = true
            down.alpha = 1
        }
        else
        {mm.down_enabled = false
            down.alpha = 0.2
        }
    }
    
    @objc func swipeforwardOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped up")
        bg.backgroundColor = UIColor.darkGray
        bg.isHidden = false
        if(mm.forward_enabled == false)
        {mm.forward_enabled = true
            forward.alpha = 1
        }
        else
        {mm.forward_enabled = false
            forward.alpha = 0.2
        }
    }
    
    @objc func swipebackwardOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped down")
        bg.backgroundColor = UIColor.lightGray
        bg.isHidden = false
        if(mm.backward_enabled == false)
        {mm.backward_enabled = true
            backward.alpha = 1
        }
        else
        {mm.backward_enabled = false
            backward.alpha = 0.2
        }
    }
}
