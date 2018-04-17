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
    
    @IBAction func Connect_touched(_ sender: Any) {
        DroneController.droneControllerInit()
        var devs = DroneController.getDeviceList()
        if(devs != nil)
        {
            if((devs?.count)! > 0){DroneController.takeoff()}
        }
    }
    
    @IBAction func back_btn_touched(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
}
