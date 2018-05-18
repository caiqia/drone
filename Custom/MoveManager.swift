//
//  MoveManager.swift
//  drones
//
//  Created by Shawky on 06/05/2018.
//  Copyright © 2018 PSAR. All rights reserved.
//

import Foundation

var isplaying = false
var i = 0
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
    
    class func playmoves(lstmoves : [Movement]){
        if !DroneController.isReady()
        {return}
        isplaying = true
        var j = 0
        lstmoves.forEach { (m) in
            if j < i
            {
                j+=1
                print("resuming from i", i)
            }
            else
            {
                if (isplaying == false)
                {
                    return
                }
                switch (m.name)
                {
                case "take_off":
                    DroneController.takeoff()
                case "flip":
                    let C = DroneController.getDeviceControllerOfApp().pointee
                    if m.arglist[0] == 0 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_FRONT) == ARCONTROLLER_ERROR){print("error flip")}}
                    if m.arglist[0] == 1 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_BACK) == ARCONTROLLER_ERROR){print("error flip")}}
                    if m.arglist[0] == 2 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_LEFT) == ARCONTROLLER_ERROR){print("error flip")}}
                    if m.arglist[0] == 3 {if( C.sendAnimationsFlip(DroneController.getDeviceControllerOfApp(),ARCOMMANDS_ARDRONE3_ANIMATIONS_FLIP_DIRECTION_RIGHT) == ARCONTROLLER_ERROR){print("error flip")}}
                case "gaz_up":
                    DroneController.send_pilot_data(0, 0, 0, 0, toint8(d: m.arglist[0]), Int32(m.duration*1000))
                case "move_forward":
                    DroneController.send_pilot_data(1, toint8(d: m.arglist[0]), 0, 0, 0, Int32(m.duration*1000))
                case "move_right":
                    DroneController.send_pilot_data(1,0, toint8(d:(m.arglist[0])),0,0, Int32(m.duration*1000))
                case "land":
                    DroneController.land()
                case "rotate_default":
                    print("rd")
                case "gaz_down":
                    DroneController.send_pilot_data(0, 0, 0, 0, -toint8(d:m.arglist[0]), Int32(m.duration*1000))
                case "move_backward":
                    DroneController.send_pilot_data(1, -toint8(d:m.arglist[0]), 0, 0, 0, Int32(m.duration*1000))
                case "move_left":
                    print("well its posit",m.arglist[0])
                    DroneController.send_pilot_data(1,0, -toint8(d:m.arglist[0]),0,0, Int32(m.duration*1000))
                default:
                    print("Error understanding move name in playmoves")
                    return
                }
                usleep(useconds_t(m.duration*10000))
                i+=1
                j+=1
            }
        }
        isplaying = false
    }
    
    class func sim(lstmoves : [Movement]){
        isplaying = true
        var j = 0
        lstmoves.forEach { (m) in
            if j < i
            {
                j+=1
                print("resuming from i", i)
            }
            else
            {
                print(m.name, m.begin, m.duration, m.arglist)
                if (isplaying == false)
                {
                    return
                }
                usleep(useconds_t(m.duration*10000))
                i+=1
                j+=1
            }
        }
        isplaying = false
    }
    
    class func pause()
    {
        isplaying = false
    }
    class func reset()
    {
        isplaying = false
        i = 0
    }
}
