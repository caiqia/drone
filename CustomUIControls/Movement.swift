//
//  Movement.swift
//  drones
//
//  Created by Qiaoshan Cai on 23/04/2018.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit

class Movement: NSObject {
    
    var name : String
    var begin : Float
    var duration : Int
    
    init(name:String,begin:Float,duration:Int) {
        self.name = name
        self.begin = begin
        self.duration = duration
    }
    
}
