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
}
