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
    var gaz = 0
    var motionManager = CMMotionManager()
    var timer = Timer()
    var started = false
    //   var stateSem : dispatch_semaphore_t
    //   var bebopDrone : DroneController
    
    //    var connectionAlertView : UIAlertController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //Gyroscope Setup
        if motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = 1.0 / 60.0
            self.motionManager.startGyroUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if let data = self.motionManager.gyroData {
                                    self.gxlbl.text = String(data.rotationRate.x)
                                    self.gylbl.text = String(data.rotationRate.y)
                                    self.gzlbl.text = String(data.rotationRate.z)
                                    
                                    // Use the gyroscope data in your app.
                                    self.start_touched(self)
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: .defaultRunLoopMode)
            
            //If accelerometer ready set timer and start updates
            if(motionManager.isAccelerometerAvailable == true){
                //Set update interval for accelerometer
                motionManager.accelerometerUpdateInterval = 0.05
                motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                    data, error in
                    self.xlbl.text = String(data!.acceleration.x)
                    self.ylbl.text = String(data!.acceleration.y)
                    self.zlbl.text = String(data!.acceleration.z)
                    
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
        
        // motionManager.startAccelerometerUpdates()
        // motionManager.startGyroUpdates()
        // motionManager.startDeviceMotionUpdates()
        //       timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(LivemodeViewController.update), userInfo: nil, repeats: true)
        // Do any additional setup after loarefersrefersding the view.
        //      stateSem = dispatch_semaphore_create(0)
        //      bebopDrone = DroneController.initWithService(_service)
        //      bebopDrone.setDelegate(self)
        //      bebopDrone.startDiscovering()
        //      connectionAlertView = UIAlertController(title:_service.name, message: "Connecting ...", preferredStyle: UIAlertControllerStyle.Alert)
    }
    
    func stopGyros() {
        self.timer.invalidate()
        self.motionManager.stopGyroUpdates()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /*
         if (_connectionAlertView && !_connectionAlertView.isHidden) {
         [_connectionAlertView dismissWithClickedButtonIndex:0 animated:NO];
         }
         _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Disconnecting ..."
         delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
         [_connectionAlertView show];
         
         // in background, disconnect from the drone
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [_bebopDrone disconnect];
         // wait for the disconnection to appear
         dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
         _bebopDrone = nil;
         
         // dismiss the alert view in main thread
         dispatch_async(dispatch_get_main_queue(), ^{
         [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
         });
         });
         */
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    /*    @objc func update(){
     if let accelerometerData = motionManager.accelerometerData {
     print(accelerometerData)
     }
     if let gyroData = motionManager.gyroData {
     print(gyroData)
     }
     if let magnetometerData = motionManager.magnetometerData {
     print(magnetometerData)
     }
     if let deviceMotion = motionManager.deviceMotion {
     print(deviceMotion)
     }
     }
     */
    
    @objc func swipeRightOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped right")
        self.view.backgroundColor = UIColor.yellow
    }
    @objc func swipeLeftOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped left")
        self.view.backgroundColor = UIColor.red
        stopGyros()
        motionManager.stopAccelerometerUpdates()
    }
    
    @objc func swipeUpOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped up")
        self.view.backgroundColor = UIColor.green
        gaz+=1
        print(gaz)
    }
    
    @objc func swipeDownOccured(swipe: UISwipeGestureRecognizer){
        print("screen swiped down")
        self.view.backgroundColor = UIColor.cyan
        gaz-=1
        print (gaz)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        /*
         switch(bebopDrone.flyingState){
         case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
         bebopDrone.takeOff()
         break
         case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
         break
         case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:
         break
         bebopDrone.land()
         default: break
         }
         */
    }
    
    @IBAction func start_touched(_ sender: Any) {
        if (DroneController.isReady() == false){
            DroneController.droneControllerInit()
            print("passed Init")}
        //if (started == false)
        started = true
        while(started)
        {
            
            let x = Int(gxlbl.text!)
            let y = Int(gylbl.text!)
            let z = Int(gzlbl.text!)
            if(x != nil && y != nil && z != nil){
                DroneController.send_pilot_data(1, (Int32((x!*10)+5)), (Int32((y!*10)+5)), (Int32((z!*10)+5)), Int32(gaz))
            }
        }
    }
    
    @IBAction func back_touched(_ sender: Any) {
        timer.invalidate()
        started = false
        DroneController.land()
        dismiss(animated: true, completion: nil)
    }
    
    
}
