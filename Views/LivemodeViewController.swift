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
    @IBOutlet var xlbl: UILabel!
    @IBOutlet var ylbl: UILabel!
    @IBOutlet var zlbl: UILabel!
    @IBOutlet var gxlbl: UILabel!
    @IBOutlet var gylbl: UILabel!
    @IBOutlet var gzlbl: UILabel!
    @IBOutlet var cplbl: UILabel!
    @IBOutlet var crlbl: UILabel!
    @IBOutlet var cylbl: UILabel!
    
    @IBOutlet var bg: UIImageView!
    
    var gaz = 0
    var motionManager = CMMotionManager()
    var timer = Timer()
    var comtimer = Timer()
    var started = false
    var isflying = false
    
    func process_cmdata(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DroneController.controllerInit()
        // Create gesture recognizers and add them to super view
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeLeftOccured))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeRightOccured))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeUpOccured))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(LivemodeViewController.swipeDownOccured))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LivemodeViewController.TapOccured))
        tap.numberOfTapsRequired = 2
        tap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tap)
        
        setupGyro()
        setupAccelero()
        setupMotion()
    }
    func setupAccelero()
    {
        //If accelerometer ready set timer and start updates
        if(motionManager.isAccelerometerAvailable == true){
            //Set update interval for accelerometer
            motionManager.accelerometerUpdateInterval = 0.05
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                self.xlbl.text = String(format: "%.1f",data!.acceleration.x)
                self.ylbl.text = String(format: "%.1f",data!.acceleration.y)
                self.zlbl.text = String(format: "%.1f",data!.acceleration.z)
                
                if data!.acceleration.x < 0 {
                    //drone will move left.
                    //print("trun left")
                }
                else if data!.acceleration.x > 0 {
                    //drone will move right.
                    //print("trun right")
                }
                if data!.acceleration.y < 0 {
                    //drone will move down.
                    //print(" down")
                }
                else if data!.acceleration.y > 0 {
                    //drone will move up.
                    //print(" up")
                }
                if data!.acceleration.z < 0 {
                    //drone will move backword.
                    // print("backward")
                }
                else if data!.acceleration.z > 0 {
                    //drone will move forwardsssss.
                    // print("forward")
                }
            })
        }
    }
    
    func setupGyro(){
        //Gyroscope Setup
        if motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = 1.0 / 60.0
            self.motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                self.gxlbl.text = String(format: "%.1f",data!.rotationRate.x)
                self.gylbl.text = String(format: "%.1f",data!.rotationRate.y)
                self.gzlbl.text = String(format: "%.1f",data!.rotationRate.z)
            }
            )
        }
    }
    func setupMotion(){
        //Motion Setup
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                self.cplbl.text = String(format: "%.1f",data!.attitude.pitch)
                self.crlbl.text = String(format: "%.1f",data!.attitude.roll)
                self.cylbl.text = String(format: "%.1f",data!.attitude.yaw)
            }
            )
        }
    }
    func stopSensing() {
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func TapOccured(swipe: UITapGestureRecognizer){
        print("Back to default")
        self.view.backgroundColor = UIColor.white
        bg.isHidden = false
    }
    
    @objc func swipeRightOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped right")
        self.view.backgroundColor = UIColor.yellow
        bg.isHidden = true
    }
    @objc func swipeLeftOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped left")
        self.view.backgroundColor = UIColor.red
        stopSensing()
        bg.isHidden = true
    }
    
    @objc func swipeUpOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped up")
        self.view.backgroundColor = UIColor.green
        gaz+=1
        print(gaz)
        bg.isHidden = true
    }
    
    @objc func swipeDownOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped down")
        self.view.backgroundColor = UIColor.cyan
        gaz-=1
        print (gaz)
        bg.isHidden = true
    }
    
    
    
    @IBAction func start_touched(_ sender: Any) {
        if (started == false)
        {
            if(DroneController.isReady())
            {
                started = true
                DroneController.takeoff()
                DroneController.send_pilot_data(0, 0, 0, 0, 0, 50)
            }
            else
            {
                DroneController.droneControllerInit()
            }
        }
        else
        {
            if(DroneController.isReady())
            {DroneController.land()}
        }
    }
    @IBAction func start_test(_ sender: Any) {
        if (started == true)
        {
            if(DroneController.isReady())
            {
                //flying test
                isflying = true
                DroneController.send_pilot_data(1, 10, 0, 0, 0, 50)
                sleep(1)
                DroneController.send_pilot_data(1, -10, 0, 0, 0, 50)
                sleep(1)
                DroneController.send_pilot_data(0, 0, 10, 0, 0, 50)
                sleep(1)
                DroneController.send_pilot_data(0, 0, -10, 0, 0, 50)
                sleep(1)
                DroneController.send_pilot_data(0, 0, 0, 10, 0, 50)
                sleep(1)
                DroneController.send_pilot_data(0, 0, 0, -10, 0, 50)
                sleep(1)
                DroneController.send_pilot_data(0, 0, 0, 0, 5, 50)
                sleep(1)
                DroneController.send_pilot_data(0, 0, 0, 0, -5, 50)
                print("Test OK")
            }
        }
    }
    
    
    @IBAction func FlipButton_touched(_ sender: Any) {
        if(isflying)
        {
            let C = DroneController.getDeviceControllerOfApp().pointee
            if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_FRONT) == ARCONTROLLER_ERROR){print("error flip")}
        }
    }
    @IBAction func back_touched(_ sender: Any) {
        if (timer.isValid)
        {timer.invalidate()}
        if(started && isflying)
        {DroneController.emergency_land()}
        started = false
        dismiss(animated: true, completion: nil)
    }
    
    
}
