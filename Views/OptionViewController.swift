//
//  OptionViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func land_touched(_ sender: Any) {
        DroneController.land()
    }
    
    @IBAction func Connect_touched(_ sender: Any) {
        if (DroneController.isReady() == false){
        DroneController.droneControllerInit()
            print("passed Init")}
        if (DroneController.isReady())
        {
               print("ready and flying")
                DroneController.takeoff()
        }
    }
    
    @IBAction func back_btn_touched(_ sender: Any)
    { 
        dismiss(animated: true, completion: nil)
    }
    
    
}
