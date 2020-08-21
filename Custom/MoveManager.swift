//
//  MoveManager.swift
//  drones
//
//  Created by Shawky on 06/05/2018.

//

import Foundation

var isplaying = false
var time = 0
var timer = Timer()
var moves : [Movement] = []
var done : [Movement] = []

class MoveManager {
    
    
    //Get Option Icon from Name
    class func getOptionIcon(name: String) -> UIImage
    {
        var icon = ""
        switch name {
        case "take_off":
            icon = "icon0.png"
        case "flip":
            icon = "icon1.png"
        case "gaz_up":
            icon = "icon2.png"
        case "move_forward":
            icon = "icon3.png"
        case "move_right":
            icon = "icon4.png"
        case "land":
            icon = "sicon0.png"
        case "rotate_default":
            icon = "sicon1.png"
        case "gaz_down":
            icon = "sicon2.png"
        case "move_backward":
            icon = "sicon3.png"
        case "move_left":
            icon = "sicon4.png"
        default:
            icon = "bg_wood"
        }
        return UIImage(named: icon)!
    }
    
    class func getOptionName(wheel: Int ,value: Int) -> String
    {
        if(wheel == 0)
        {
            switch(value)
            {
            case 0:
                return "take_off"
            case 1:
                return "flip"
            case 2:
                return "gaz_up"
            case 3:
                return "move_forward"
            case 4:
                return "move_right"
            default:
                return ""
            }
        }
        else
        {
            switch(value)
            {
            case 0:
                return "land"
            case 1:
                return "rotate_default"
            case 2:
                return "gaz_down"
            case 3:
                return "move_backward"
            case 4:
                return "move_left"
            default:
                return ""
            }
        }
    }
    
    class func toint8(d:Int) -> Int8
    {
        var dd = d
        if (dd > 128 || dd < -127) {dd = 0}
        return Int8(dd)
    }
    
    @objc class func updateVal()
    {
        if (isplaying == false)
        {
            timer.invalidate()
            return
        }
        time+=1
        var i = 0
        while i < moves.count {
            let m = moves[i]
            if Int(m.begin) < time && !done.contains(m)
            {
                print("processing m",m.name,m.begin,m.duration,m.arglist)
                done.append(m)
            }
            i+=1
            }
        if moves.count == 0
        {
            isplaying = false
            MoveManager.reset()
        }
    }
    
    class func playmoves(lstmoves : [Movement]){
          time = 0
         isplaying = true
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(self.updateVal)), userInfo: nil, repeats: true)
        moves.append(contentsOf: lstmoves)
    }
    
    class func pause()
    {
        isplaying = false
        timer.invalidate()
    }
    class func reset()
    {
        isplaying = false
        time = 0
        timer.invalidate()
    }
    class func domove(m : Movement)
    {
        switch (m.name)
        {
        case "take_off":
            if DroneController.isReady()
            {DroneController.takeoff()}
        case "flip":
            if DroneController.isReady()
            {
                let C = DroneController.getDeviceControllerOfApp().pointee
                if m.arglist[0] == 0 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_FRONT) == ARCONTROLLER_ERROR){print("error flip")}}
                if m.arglist[0] == 1 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_BACK) == ARCONTROLLER_ERROR){print("error flip")}}
                if m.arglist[0] == 2 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_LEFT) == ARCONTROLLER_ERROR){print("error flip")}}
                if m.arglist[0] == 3 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_RIGHT) == ARCONTROLLER_ERROR){print("error flip")}}
            }
        case "gaz_up":
            if DroneController.isReady()
            {
                DroneController.send_pilot_data(0, 0, 0, 0, toint8(d: m.arglist[0]), Int32(m.duration*1000))}
        case "move_forward":
            if DroneController.isReady()
            {
                DroneController.send_pilot_data(1, toint8(d: m.arglist[0]), 0, 0, 0, Int32(m.duration*1000))}
        case "move_right":
            if DroneController.isReady()
            {
                DroneController.send_pilot_data(1,0, toint8(d:(m.arglist[0])),0,0, Int32(m.duration*1000))}
        case "land":
            if DroneController.isReady()
            {
                DroneController.land()}
        case "rotate_default":
            print("rd")
        case "gaz_down":
            if DroneController.isReady()
            {
                DroneController.send_pilot_data(0, 0, 0, 0, -toint8(d:m.arglist[0]), Int32(m.duration*1000))}
        case "move_backward":
            if DroneController.isReady()
            {
                DroneController.send_pilot_data(1, -toint8(d:m.arglist[0]), 0, 0, 0, Int32(m.duration*1000))}
        case "move_left":
            if DroneController.isReady()
            {
                DroneController.send_pilot_data(1,0, -toint8(d:m.arglist[0]),0,0, Int32(m.duration*1000))}
        default:
            print("Error understanding move name in playmoves")
            return
        }
    }
}
