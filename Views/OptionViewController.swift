//
//  OptionViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    
    @IBOutlet var wifi_lbl: UILabel!
    @IBOutlet var land_on_bat: UILabel!
    @IBOutlet var matitude: UILabel!
    @IBOutlet var mspeed: UILabel!
    
    var timer = Timer()
    var ospeed = 60.0
    var att = 150.0
    var low = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filUrl = dirUrl.appendingPathComponent("psarops").appendingPathExtension("dini")
        let readString = try? String(contentsOf: filUrl)
        //If valid pass to load function of corresponding controller
        if ((readString) != nil)
        {
            let seperated = readString!.components(separatedBy: ";")
            ospeed  = Double(seperated[0])!
            att = Double(seperated[1])!
            low = Double(seperated[2])!
            mspeed.text = String(ospeed)
            mspeed.text!.append(" km/h")
            matitude.text = String(att)
            matitude.text!.append(" Meters")
            land_on_bat.text = String(low)
            land_on_bat.text!.append(" %")
        }
        else
        {
            mspeed.text  =  "60 km/h"
            matitude.text = "150 Meters"
            land_on_bat.text = "10 %"
        }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(self.check_wifi)), userInfo: nil, repeats: true)
        if (!DroneController.isReady()){DroneController.droneControllerInit()}
    }
    
    @objc func check_wifi()
    {
        if DroneController.isReady()
        {
            wifi_lbl.text = "OK"
        }
        else
        {
            wifi_lbl.text = "-"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func wifi_touched(_ sender: Any) {
        if #available(iOS 11.0, *) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "IOS11Wifi") as! IOS11Wifi
            self.present(newViewController, animated: true, completion: nil)
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "IOS10Wifi") as! IOS10Wifi
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func mspeed_touch(_ sender: Any) {
        let insertAlert = UIAlertController(title: "Max Movement Speed", message: "Enter Max Speed: ", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            var speed = insertAlert.textFields?[0].text
            if(speed == nil){return}
            var speedint = Float(speed!)
            if speedint! > 60 || speedint! <= 0
            {
                speedint = 60
            }
            if(speedint != 60){
                speed?.append(contentsOf: " km/h")}
            else
            {speed = "60 km/h"}
            self.mspeed.text = speed
            self.ospeed = Double(speedint!)
            if(DroneController.isReady())
            {
                let C = DroneController.getDeviceControllerOfApp().pointee
                
                if( C.sendSpeedSettingsMaxVerticalSpeed(DroneController.getDeviceControllerOfApp(),Float(speedint!/3.6)) == ARCONTROLLER_ERROR){print("error set speed")}
            }
        }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Max Speed in km/h (<60)"
            textField.keyboardType = .numberPad
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //adding the action to dialog box
        insertAlert.addAction(confirmAction)
        insertAlert.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(insertAlert, animated: true, completion: nil)
    }
    @IBAction func mattitude_touch(_ sender: Any) {
        let insertAlert = UIAlertController(title: "Max Altitude", message: "Enter Max Altitude:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            let altitude = insertAlert.textFields?[0].text
            if(altitude == nil){return}
            var alt = Float(altitude!)
            if(alt == nil){return}
            if (alt! > 150.0 || alt! <= 0){alt = 150.0}
            var mytext = String(alt!)
            mytext.append(" Meters")
            self.matitude.text = mytext
            self.att = Double(alt!)
            if(DroneController.isReady())
            {
                let C = DroneController.getDeviceControllerOfApp().pointee
                if( C.sendPilotingSettingsMaxAltitude(DroneController.getDeviceControllerOfApp(),alt!) == ARCONTROLLER_ERROR){print("error setting altitude")}
            }
        }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Max altitude in meters (<150)"
            textField.keyboardType = .numberPad
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //adding the action to dialog box
        insertAlert.addAction(confirmAction)
        insertAlert.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(insertAlert, animated: true, completion: nil)
    }
    
    @IBAction func bat_touch(_ sender: Any) {
        let insertAlert = UIAlertController(title: "Land When Low Battery", message: "Enter Threshold:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            let speed = insertAlert.textFields?[0].text
            if(speed == nil){return}
            self.land_on_bat.text = speed
            self.low = Double(Int(speed!)!)
            self.land_on_bat.text!.append(contentsOf: " %")
        }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Percentage"
            textField.keyboardType = .numberPad
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //adding the action to dialog box
        insertAlert.addAction(confirmAction)
        insertAlert.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(insertAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func back_btn_touched(_ sender: Any)
    {
        timer.invalidate()
        // Get App Support Directory
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // Build file name
        let filUrl = dirUrl.appendingPathComponent("psarops").appendingPathExtension("dini")
        // Save options on at a time
        var res = ""
        res.append(String(ospeed))
        res.append(";")
        res.append(String(att))
        res.append(";")
        res.append(String(low))
        res.append(";")
        do{
            // Write File
            try res.write(to: filUrl, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print("fail to write options")
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
