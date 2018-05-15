/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the CoreMotion interactions and 
 provides a delegate to indicate changes in data.
 */

import Foundation
import CoreMotion
import WatchKit

/**
 `MotionManagerDelegate` exists to inform delegates of motion changes.
 These contexts can be used to enable application specific behavior.
 */
protocol MotionManagerDelegate: class {
    func didUpdateForehandSwingCount(_ manager: MotionManager, forehandCount: Int)
    func didUpdateBackhandSwingCount(_ manager: MotionManager, backhandCount: Int)
}

var drone = DroneController.getDeviceControllerOfApp().pointee

class MotionManager {
    // MARK: Properties
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = true//WKInterfaceDevice.current().wristLocation == .left
   
    // MARK: Application Specific Constants
    
    // These constants were derived from data and should be further tuned for your needs.
    let yawThreshold = 0.45 // Radians
    let rateThreshold = 0.5	// Radians/sec
    let resetThreshold = 0.5 * 0.05 // To avoid double counting on the return swing.
    
    // The app is using 50hz data and the buffer is going to hold 1s worth of data.
    let sampleInterval = 1.0 / 50
    let rateAlongGravityBufferx = RunningBuffer(size: 50)
    let rateAlongGravityBuffery = RunningBuffer(size: 50)
    let rateAlongGravityBufferz = RunningBuffer(size: 50)
    
    weak var delegate: MotionManagerDelegate?
    
    /// Swing counts.
    var forehandCount = 0
    var backhandCount = 0
    
    var recentxDetection = false
    var recentyDetection = false
    var recentzDetection = false
    // MARK: Initialization
    
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }
    
    // MARK: Motion Manager
    
    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        // Reset everything when we start.
        //resetAllState()
        
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
                self.processDeviceMotion(deviceMotion!)
            }
        }
    }
    
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    // MARK: Motion Processing
    
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        let gravity = deviceMotion.gravity
        let rotationRate = deviceMotion.rotationRate
        //print (deviceMotion.gravity.y)
        
        let rateAlongGravity = rotationRate.x * gravity.z // r⃗ · ĝ
       //  + rotationRate.y * gravity.y // r⃗ · ĝ
        // + rotationRate.z * gravity.z // r⃗ · ĝ
        
        let rateAlongGravityy = rotationRate.y
        let rateAlongGravityz = rotationRate.z
        //+ rotationRate.y * gravity.y
        // + rotationRate.z * gravity.z
        rateAlongGravityBufferx.addSample(rateAlongGravity)
        rateAlongGravityBuffery.addSample(rateAlongGravityy)
        rateAlongGravityBufferz.addSample(rateAlongGravityz)
        if !rateAlongGravityBufferx.isFull() {
            return
        }
        
        let accumulatedXRot = rateAlongGravityBufferx.sum() * sampleInterval
        let accumulatedYRot = rateAlongGravityBuffery.sum() * sampleInterval
        let accumulatedZRot = rateAlongGravityBufferz.sum() * sampleInterval
        
        if(accumulatedZRot > 0.45)
        {print ("Moving Left", abs(deviceMotion.userAcceleration.z*10));rateAlongGravityBufferz.reset()
            DroneController.send_pilot_data(1, 1, 0, 0, 0, Int32(deviceMotion.userAcceleration.z*10))
        }
        if(accumulatedZRot < -0.45)
        {print ("Moving Right");rateAlongGravityBufferz.reset()}
        if(accumulatedYRot < -0.8)
        {print ("Moving Down");rateAlongGravityBuffery.reset()}
        //print("Yz", accumulatedYRot)
        if(accumulatedYRot > 0.8)
        {print ("Moving Up");rateAlongGravityBuffery.reset()}
        if(accumulatedXRot > 0.9)
        {print ("Moving Backwards");rateAlongGravityBufferx.reset()}
        if(accumulatedXRot < -0.9)
        {print ("Moving Forward");rateAlongGravityBufferx.reset()}
        
        // Reset after letting the rate settle to catch the return swing.
        if (recentxDetection && abs(rateAlongGravityBufferx.recentMean()) < resetThreshold) {
            recentxDetection = false
          //  rateAlongGravityBufferx.reset()
        }
        if (recentyDetection && abs(rateAlongGravityBuffery.recentMean()) < resetThreshold) {
            recentyDetection = false
         //   rateAlongGravityBuffery.reset()
        }
        if (recentzDetection && abs(rateAlongGravityBufferz.recentMean()) < resetThreshold) {
            recentzDetection = false
         //   rateAlongGravityBufferz.reset()
        }
    }
    
}
