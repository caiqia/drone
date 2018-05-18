/*
Motion Manager
 */

import Foundation
import CoreMotion


var drone = DroneController.getDeviceControllerOfApp().pointee
var dronec = DroneController.getDeviceControllerOfApp()

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
    
    var doingflip = false
    
    var recentxDetection = false
    var recentyDetection = false
    var recentzDetection = false
    // MARK: Initialization
    var recent_up = false
    var recent_down = false
    var recent_left = false
    var recent_right = false
    var recent_forward = false
    var recent_backward = false
    var last_up_on  = CACurrentMediaTime()
    var last_down_on = CACurrentMediaTime()
    var last_left_on = CACurrentMediaTime()
    var last_right_on = CACurrentMediaTime()
    var last_forward_on = CACurrentMediaTime()
    var last_backward_on = CACurrentMediaTime()
    var last_move = CACurrentMediaTime()
    var unstable = false
    var up_enabled = true
    var down_enabled = true
    var left_enabled = true
    var right_enabled = true
    var forward_enabled = true
    var backward_enabled = true
    var flip_front_enabled = true
    var flip_back_enabled = true
    var flip_left_enabled = true
    var flip_right_enabled = true
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
        
    }
    
    func toint8(d:Double) -> Int8
    {
        var dd = round(d)
        if (dd > 128 || dd < -127) {dd = 0}
        return Int8(dd)
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
        rateAlongGravityBufferx.reset()
        rateAlongGravityBuffery.reset()
        rateAlongGravityBufferz.reset()
        stablisie()
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
        
        if forward_enabled
        {check_forward(accumulatedXRot: accumulatedXRot, deviceMotion: deviceMotion)}
        if backward_enabled
        {check_backward(accumulatedXRot: accumulatedXRot, deviceMotion: deviceMotion)}
        if up_enabled
        {check_up(accumulatedYRot: accumulatedYRot, deviceMotion: deviceMotion)}
        if down_enabled
        {check_down(accumulatedYRot: accumulatedYRot, deviceMotion: deviceMotion)}
        if left_enabled{
            check_left(accumulatedZRot: accumulatedZRot, deviceMotion: deviceMotion)}
        if right_enabled{
            check_right(accumulatedZRot: accumulatedZRot, deviceMotion: deviceMotion)}
        
        if (unstable && CACurrentMediaTime() - last_move > 2)
        {
            stablisie()
        }
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
    
    func stablisie()
    {
        print("stablising")
        if (DroneController.isReady())
        {
            drone.setPilotingPCMDFlag(dronec,1)
            drone.setPilotingPCMDYaw(dronec,0)
            drone.setPilotingPCMDPitch(dronec,0)
            drone.setPilotingPCMDRoll(dronec,0)
            drone.setPilotingPCMDGaz(dronec,0)
            drone.setPilotingPCMDFlag(dronec,0)
        }
        unstable = false
        recent_forward = false
        recent_backward = false
        recent_up = false
        recent_down = false
        recent_left = false
        recent_right = false
        rateAlongGravityBufferx.reset()
        rateAlongGravityBuffery.reset()
        rateAlongGravityBufferz.reset()
    }
    
    func check_forward(accumulatedXRot : Double, deviceMotion : CMDeviceMotion){
        if(accumulatedXRot < -0.6)
        {
            if(recent_backward)
            {
                recent_backward = false
                let Now = CACurrentMediaTime()
                if(Now - last_backward_on != 0 && Now - last_backward_on < 1.0)
                {
                    if(DroneController.isReady()) {
                    stablisie()
                drone.sendAnimationsFlip(dronec,ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_FRONT)}
                    print ("Oh it's a front flip")
                }
                else
                {
                    print("back to normal from backward")
                    stablisie()
                }
                rateAlongGravityBufferx.reset()
                last_forward_on = CACurrentMediaTime()
            }
            else
            {
                recent_forward = true
                last_forward_on = CACurrentMediaTime()
                var m_value = toint8(d: deviceMotion.userAcceleration.z*10+15)
                m_value = abs(m_value) * 1
                if m_value <= 0 || m_value > 100 { m_value = 1 }
                print ("Moving Forward", m_value)
                rateAlongGravityBufferx.reset()
                if (DroneController.isReady())
                {
                 
                    drone.setPilotingPCMDFlag(dronec,1)
                    drone.setPilotingPCMDPitch(dronec,m_value)
                }
                recentxDetection = true
                last_move = CACurrentMediaTime()
                unstable = true
            }
        }
    }
    func check_backward(accumulatedXRot : Double, deviceMotion : CMDeviceMotion){
        if(accumulatedXRot > 0.6)
        {
            if(recent_forward)
            {
                recent_forward = false
                let Now = CACurrentMediaTime()
                if(Now - last_forward_on != 0 && Now - last_forward_on < 1.0)
                {
                    
                    if(DroneController.isReady()) {
                        stablisie()
                        drone.sendAnimationsFlip(dronec,ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_BACK)}
                    print ("Oh it's a back flip")
                }
                else
                {
                    print("back to normal from forward")
                    stablisie()
                }
                rateAlongGravityBufferx.reset()
                last_backward_on = CACurrentMediaTime()
            }
            else
            {
                recent_backward = true
                last_backward_on = CACurrentMediaTime()
                var m_value = toint8(d: deviceMotion.userAcceleration.z*10+15)
                m_value = abs(m_value) * -1
                if m_value >= 0 || m_value < -100 { m_value = -1 }
                print ("Moving Backwards",m_value)
                rateAlongGravityBufferx.reset()
                if (DroneController.isReady())
                {
                    
                    drone.setPilotingPCMDFlag(dronec,1)
                    drone.setPilotingPCMDPitch(dronec,m_value)
                }
                recentxDetection = true
                last_move = CACurrentMediaTime()
                unstable = true
            }
        }
    }
    
    func check_right(accumulatedZRot : Double, deviceMotion : CMDeviceMotion){
        if(accumulatedZRot < -0.7)
        {
            if(recent_left)
            {
                recent_left = false
                print("back to horizon from left")
                stablisie()
                rateAlongGravityBufferz.reset()
                last_right_on = CACurrentMediaTime()
                last_move = CACurrentMediaTime()
            }
            else
            {
                recent_right = true
                var m_value = toint8(d: deviceMotion.userAcceleration.x*10+15)
                if m_value <= 0 || m_value > 100 { m_value = 1 }
                print ("Moving Right",m_value)
                rateAlongGravityBufferz.reset()
                if (DroneController.isReady())
                {
              
                    drone.setPilotingPCMDFlag(dronec,1)
                    drone.setPilotingPCMDRoll(dronec,m_value)
                }
                recentzDetection = true
                last_move = CACurrentMediaTime()
                unstable = true
            }
        }
    }
    
    func check_left(accumulatedZRot : Double, deviceMotion : CMDeviceMotion){
        if(accumulatedZRot > 0.4){
            if(recent_right)
            {
                recent_right = false
                print("back to horizon from right")
                stablisie()
                rateAlongGravityBufferz.reset()
                last_left_on = CACurrentMediaTime()
                last_move = CACurrentMediaTime()
            }
            else
            {
                recent_left = true
                var m_value = toint8(d:deviceMotion.userAcceleration.x*10+15)
                m_value = abs(m_value) * -1
                if m_value >= 0 || m_value < -100 { m_value = -1 }
                print ("Moving Left", m_value)
                rateAlongGravityBufferz.reset()
                if (DroneController.isReady())
                {
                    drone.setPilotingPCMDFlag(dronec,1)
                   
                    drone.setPilotingPCMDRoll(dronec,m_value)
                }
                recentzDetection = true
                last_move = CACurrentMediaTime()
                unstable = true
            }
        }
    }
    // Check Up Gesture
    func check_up(accumulatedYRot : Double, deviceMotion : CMDeviceMotion)
    {
        if(accumulatedYRot > 1.0)
        {
            if(recent_down)
            {
                recent_down = false
                let Now = CACurrentMediaTime()
                if(Now - last_down_on != 0 && Now - last_down_on < 0.5)
                {
                    if(DroneController.isReady()) {
                       stablisie()
                        drone.sendAnimationsFlip(dronec,ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_LEFT)}
                    print ("Oh it's a flip Left")
                }
                else
                {
                    print("back to horizon from down")
                    stablisie()
                }
                rateAlongGravityBuffery.reset()
                last_up_on = CACurrentMediaTime()
                last_move = CACurrentMediaTime()
            }
            else
            {
                recent_up = true
                last_up_on = CACurrentMediaTime()
                var m_value = toint8(d:deviceMotion.userAcceleration.y*10+15)
                if m_value <= 0 || m_value > 100 { m_value = 1 }
                
                print ("Moving Up",m_value)
                rateAlongGravityBuffery.reset()
                if (DroneController.isReady())
                {
                    drone.setPilotingPCMDGaz(dronec,m_value)
                }
                recentyDetection = true
                last_move = CACurrentMediaTime()
                unstable = true
            }
        }
    }
    
    // Check Down Gesture
    func check_down(accumulatedYRot : Double, deviceMotion: CMDeviceMotion){
        if(accumulatedYRot < -1.0)
        {
            if(recent_up)
            {
                recent_up = false
                let Now = CACurrentMediaTime()
                if(Now - last_up_on != 0 && Now - last_up_on < 0.5)
                {
                    if(DroneController.isReady()) {
                       stablisie()
                        drone.sendAnimationsFlip(dronec,ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_RIGHT)}
                    print ("Oh it's a flip right")
                }
                else
                {
                    print("back to horizon from up")
                    stablisie()
                }
                rateAlongGravityBuffery.reset()
                last_down_on = CACurrentMediaTime()
            }
            else
            {
                recent_down = true
                last_down_on = CACurrentMediaTime()
                var m_value = toint8(d:deviceMotion.userAcceleration.y*10+15)
                m_value = abs(m_value) * -1
                if m_value >= 0 || m_value < -100 { m_value = -3 }
                
                print ("Moving Down",m_value)
                rateAlongGravityBuffery.reset()
                if (DroneController.isReady())
                {
                    drone.setPilotingPCMDGaz(dronec,m_value)
                }
                recentyDetection = true
                last_move = CACurrentMediaTime()
                unstable = true
            }
        }
    }
}
