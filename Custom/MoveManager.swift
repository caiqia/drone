//
//  MoveManager.swift
//  drones
//
//  Created by Shawky on 06/05/2018.
//  Copyright © 2018 PSAR. All rights reserved.
//

import Foundation

class MoveManager {
    //Get Option Icon from Name
    class func getOptionIcon(name: String) -> UIImage
    {
        var icon = ""
        switch name {
        case "takeoff":
            icon = "icon0.png"
        case "rotate":
            icon = "icon1.png"
        case "lockx":
            icon = "icon2.png"
        case "locky":
            icon = "icon3.png"
        case "lockz":
            icon = "icon4.png"
        case "land":
            icon = "sicon0.png"
        case "rotate_default":
            icon = "sicon1.png"
        case "unlockx":
            icon = "sicon2.png"
        case "unlocky":
            icon = "sicon3.png"
        case "unlockz":
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
                return "takeoff"
            case 1:
                return "rotate"
            case 2:
                return "lockx"
            case 3:
                return "locky"
            case 4:
                return "lockz"
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
                return "unlockx"
            case 3:
                return "unlocky"
            case 4:
                return "unlockz"
            default:
                return ""
            }
        }
    }
}
