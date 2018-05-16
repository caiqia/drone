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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filUrl = dirUrl.appendingPathComponent("psarops").appendingPathExtension("dini")
        let readString = try? String(contentsOf: filUrl)
        //If valid pass to load function of corresponding controller
        if ((readString) != nil)
        {
            let seperated = readString!.components(separatedBy: ";")
            mspeed.text  = seperated[0]
            matitude.text = seperated[1]
            land_on_bat.text = seperated[2]
        }
        else
        {
            mspeed.text  =  "100%"
            matitude.text = "100%"
            land_on_bat.text = "10%"
        }
        if DroneController.isReady()
        {
            wifi_lbl.text = "OK"
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
        let insertAlert = UIAlertController(title: "Max Movement Speed", message: "Enter Max Speed:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            var speed = insertAlert.textFields?[0].text
            if(speed == nil){return}
            speed?.append("%")
            self.mspeed.text = speed
        }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Max Speed"
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
            var speed = insertAlert.textFields?[0].text
            if(speed == nil){return}
            speed?.append("%")
            self.matitude.text = speed
        }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Max Altitude"
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
            var speed = insertAlert.textFields?[0].text
            if(speed == nil){return}
            speed?.append("%")
            self.land_on_bat.text = speed
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
        // Get App Support Directory
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // Build file name
        let filUrl = dirUrl.appendingPathComponent("psarops").appendingPathExtension("dini")
        // Save options on at a time
        var res = ""
        mspeed.text!.removeLast()
        let s = mspeed.text!
        res.append(Int(s)!>100 || Int(s)! < 0 ? "100" : s)
        res.append("%;")
          matitude.text!.removeLast()
        let a = matitude.text!
        res.append(Int(a)!>100 || Int(a)! < 0 ? "100" : a)
        res.append("%;")
        land_on_bat.text!.removeLast()
        let b = land_on_bat.text!
        res.append(Int(b)! > 100 || Int(b)! < 0 ? "100" : b)
        res.append("%;")
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
