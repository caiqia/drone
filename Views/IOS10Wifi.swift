//
//  IOS10Wifi.swift
//  drones
//
//  Created by Shawky on 08/05/2018.

//

import Foundation

class IOS10Wifi : UIViewController
{
    var NT : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NT = Timer(timeInterval: 5, repeats: true) { _ in
            if(DroneController.isReady())
            {
                let vi = UIAlertController.init(title: "Connected", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
                self.present(vi, animated: true) {
                    self.dismiss(animated: true, completion: nil)
                }}
        }}
    
    @IBAction func exit_touched(_ sender: Any) {
        NT.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

