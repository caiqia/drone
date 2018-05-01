//
//  DataViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit
import MediaPlayer

class DanceEditorViewController: UIViewController, UIWheelDelegate{
    //Outlets and Declarations
    @IBOutlet var wheel1: UIImageView!
    @IBOutlet var insert_btn: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var play_btn: UIButton!
    @IBOutlet var timer_label: UILabel!
    @IBOutlet var delete_btn: UIButton!
    
    var playing = false
    var sectorLabel = UILabel()
    var wheel = UIWheel()
    var opt_curr = 0
    var timer = Timer()
    var Timer_val = 0
    var moveArray : [Movement] = []
    let completePath = "/Users/sarah/Desktop/Files.playground"

    
    
    
    //Setup after load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add wheel to placeholder
        sectorLabel = UILabel(frame: CGRect(x: 100, y: 350, width: 120, height: 30))
        sectorLabel.textAlignment = NSTextAlignment.center
        view.addSubview(sectorLabel)
        wheel = UIWheel( frame: CGRect(x: 0, y: 0, width: 200, height: 200), andDelegate: self, withSections: 8, withBackground: "wheel1_bg.png", withIconsPrefix: "icon", withCenterIcon: "centerButton.png")
        wheel.delegate = self
        wheel.center = wheel1.center
        wheel1.isHidden = true
        slider.value = 0
        slider.maximumValue = 1000
        view.addSubview(wheel)
    }
    // Iphone low on memory asking us to dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Get Song time from user
    func showTimeInputDialog() {
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Song Time", message: "Enter song time:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            var hours = Int((alertController.textFields?[0].text)!)
            var minutes = Int((alertController.textFields?[1].text)!)
            var seconds = Int((alertController.textFields?[2].text)!)
            //Set slider value
            if(!(seconds != nil)){seconds = 0}
            if(!(minutes != nil)){minutes = 0}
            if(!(hours != nil)){hours = 0}
            self.slider.maximumValue = Float(hours!*60*60*100)
            self.slider.maximumValue += Float(minutes!*60*100)
            self.slider.maximumValue += Float(seconds!*100)
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Hours (24h)"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Minutes"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Seconds"
            textField.keyboardType = .numberPad
        }
        //adding the action to dialog box
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func save_touched(_ sender: Any) {
        //FileTools.showSaveFileNameInputDialog(current_view: self)
        let alertController = UIAlertController(title: "Save Dance", message: "Enter dance neme:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Save", style: .default)
        {
            (_) in
            //getting the input values from user
            let dancename = String((alertController.textFields?[0].text)!)
            let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filUrl = dirUrl.appendingPathComponent(dancename).appendingPathExtension("txt")
            var maxTime = "time:"
            maxTime.append(String(self.slider.maximumValue))
            maxTime.append(";")
            do{
                try maxTime.write(to: filUrl, atomically: true, encoding: String.Encoding.utf8)
            }catch let error as NSError{
                print("fail to write time")
                print(error)
            }
            var res = ""
            self.moveArray.forEach { oneMove in
                res.append(oneMove.writeMove())
            }
            do{
                try res.write(to: filUrl, atomically: true, encoding: String.Encoding.utf8)
                var aff = "write success"
                aff.append(filUrl.path)
                print(aff)
            }catch let error as NSError{
                print("fail to write")
                print(error)
            }
            var readString = ""
            do{
                readString = try String(contentsOf: filUrl)
            }catch let error {
                print("Error: \(error.localizedDescription)")
            }
            print(readString)
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter dance name"
            textField.keyboardType = .namePhonePad
        }
        //adding the action to dialog box
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Play button touched
    @IBAction func play_touched(_ sender: UIButton) {
        if(playing)
        {
            playing = false
            timer.invalidate()
            let img = UIImage(named: "play_icon.png")
            play_btn.setImage(img, for: .normal)
        }
        else
        {
            playing = true
            let img = UIImage(named: "pause_icon.png")
            play_btn.setImage(img, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(DanceEditorViewController.updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    //Track time button
    @IBAction func change_track_time_touched(_ sender: Any) {
        showTimeInputDialog()
    }
    //playing timer
    @objc func updateTimer() {
        Timer_val+=1
        let hours = self.Timer_val / 360000;
        let minutes = (self.Timer_val - (hours * 360000)) / 6000;
        let seconds = (self.Timer_val - (hours * 360000) - (minutes * 6000)) / 100;
        slider.value+=1
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm:ss"
        timer_label.text =
            inFormatter.string(from: inFormatter.date(from: String(hours)+":"+String(minutes)+":"+String(seconds))!)
        if(Timer_val > Int(slider.maximumValue)){stop_touched(slider)}
    }
    //Fast Reward button
    @IBAction func fast_reward_touched(_ sender: Any) {
        if(Timer_val > 500)
        {
            Timer_val -= 500
            slider.value -= 500
        }
    }
    
    //Fast Forward Button
    @IBAction func fast_forward_touched(_ sender: Any) {
        if(Timer_val < Int(slider.maximumValue) - 500)
        {
            Timer_val += 500
            slider.value += 500
        }
    }
    
    //Stop button actions
    @IBAction func stop_touched(_ sender: Any) {
        slider.value = 0
        timer.invalidate()
        Timer_val = 0
        let img = UIImage(named: "play_icon.png")
        play_btn.setImage(img, for: .normal)
        playing = false
        timer_label.text = "00:00:00"
    }
    //Funtion to delete last option
    @IBAction func delete_option(_ sender: Any) {
        if(!self.moveArray.isEmpty){
            self.moveArray.removeLast()
        }
        let opt_col = self.view.subviews.flatMap { $0 as? CustomOpticons }
        if(opt_col.count != 0 && opt_curr != 0)
        {
            opt_col[opt_curr-1].isHidden = true
            opt_curr-=1
            if(opt_curr<=11){insert_btn.isHidden = false}
            if(opt_curr == 0){delete_btn.isHidden = true}
        }
        self.view.updateConstraints()
    }
    
    //Function to make adjusting the slider move through the song.
    @IBAction func slider_value_changed(_ sender: Any) {
        Timer_val = Int(slider.value)
        Timer_val-=1
        updateTimer()
    }
    
    // Get Song time from user
    func insertTimeDialog() {
        print(wheel.currentValue)
        
    }
    
    //Wheel Rotation handling
    func wheelDidChangeValue(_ newValue: String?) {
        sectorLabel.text = newValue as String?
        print(sectorLabel.tag)
    }
    //Option Insertion handling
    @IBAction func insert_option(_ sender: Any) {
        //Get the image and set the holder to it
        let img = UIImage(named: "icon"+String(wheel.currentValue)+".png")
        let opt_col = self.view.subviews.flatMap { $0 as? CustomOpticons }
        opt_col[opt_curr].image = img
        opt_col[opt_curr].isHidden = false
        opt_curr+=1
        if(opt_curr>0){delete_btn.isHidden = false}
        if(opt_curr>11){insert_btn.isHidden = true}
        self.view.updateConstraints()
        //insert to options list
        print(wheel.currentValue)
        print(wheel.getCloveName(wheel.currentValue))
        //Setting title and message for the alert dialog
        let insertAlert = UIAlertController(title: "movement Time", message: "Enter movement time:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            var seconds = Int((insertAlert.textFields?[0].text)!)
            //Set slider value
            if(!(seconds != nil)){seconds = 0}
            let newMove = Movement(name:self.wheel.getCloveName(self.wheel.currentValue),begin:self.slider.value,duration:seconds!)
            self.moveArray.append(newMove)
            dump(self.moveArray)
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Enter seconds"
            textField.keyboardType = .numberPad
        }
        //adding the action to dialog box
        insertAlert.addAction(confirmAction)
        insertAlert.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(insertAlert, animated: true, completion: nil)
    }
        
    
    //Go back to main function
    @IBAction func back_pressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //Save dance to file
    
    //Requiered Constructors
    init(sectorLbl: UILabel, aDecoder: NSCoder) {
        self.sectorLabel = sectorLbl
        self.wheel = UIWheel()
        super.init(coder: aDecoder)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sectorLabel = UILabel()
        self.wheel = UIWheel()
        super.init(coder: aDecoder)
    }
}

