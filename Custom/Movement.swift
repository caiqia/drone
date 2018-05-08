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
    var arglist : [Int]

    init(name:String,begin:Float,duration:Int,arglist:[Int]) {
        self.name = name
        self.begin = begin
        self.duration = duration
        self.arglist = arglist
    }
    
    //Movement to String
    func toString() -> String{
        var res = ""
        res.append(self.name)
        res.append(";")
        res.append(String(self.begin))
        res.append(";")
        res.append(String(self.duration))
        if (self.arglist.count > 0)
        {
        self.arglist.forEach { (arg) in
            res.append(";")
            res.append(String(arg))
            }}
        res.append("/")
        return res
    }
    
}

