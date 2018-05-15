//
//  LivemodeViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit
import CoreMotion


class LivemodeViewController: UIViewController, MotionManagerDelegate {
    
    func didUpdateForehandSwingCount(_ manager: MotionManager, forehandCount: Int) {
        print ("Forward count %d",forehandCount)
    }
    
    func didUpdateBackhandSwingCount(_ manager: MotionManager, backhandCount: Int) {
        print ("backward count %d",backhandCount)
    }
    
    
    @IBOutlet var xlbl: UILabel!
    @IBOutlet var ylbl: UILabel!
    @IBOutlet var zlbl: UILabel!
    @IBOutlet var gxlbl: UILabel!
    @IBOutlet var gylbl: UILabel!
    @IBOutlet var gzlbl: UILabel!
    @IBOutlet var cplbl: UILabel!
    @IBOutlet var crlbl: UILabel!
    @IBOutlet var cylbl: UILabel!
    

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
    
    func process_cmdata(){
        if(x > 0.9 ){print("Forward")}
        if(x > -0.9 && x < 0) {print("Backward")}
        if(y > 0.9) {print("left")}
        if(y > -0.9 && x < 0) { print("right")}
    }
    
    @IBAction func take_off(_ sender: Any) {
        if DroneController.isReady()
        {
            DroneController.takeoff()
            sleep(8)
            mm.startUpdates()
        }
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
        
       
        mm.delegate = self
        
      //  setupGyro()
       // setupAccelero()
       // setupMotion()
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
                self.x = data!.rotationRate.x
                self.y = data!.rotationRate.y
                self.z = data!.rotationRate.z
                self.process_cmdata()
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
                self.cplbl.text = String(format: "%.1f",data!.userAcceleration.x)
                self.crlbl.text = String(format: "%.1f",data!.userAcceleration.y)
                self.cylbl.text = String(format: "%.1f",data!.userAcceleration.z)
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
        let ops = self.view.subviews.compactMap { $0 as? CustomOpticons }
        ops.forEach { (op) in
            op.alpha = 1
        }
        if DroneController.isReady(){DroneController.emergency_land()}
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
        let ops = self.view.subviews.compactMap { $0 as? UIButton }
        ops.forEach { (op) in
            if op.accessibilityLabel == "up"
            {op.alpha = 0.2}
        }
        bg.isHidden = true
    }
    
    @objc func swipeDownOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped down")
        self.view.backgroundColor = UIColor.cyan
        gaz-=1
        print (gaz)
        bg.isHidden = true
    }
    
}
