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
    @IBOutlet var wheel2: UIImageView!
    @IBOutlet var insert_btn: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var play_btn: UIButton!
    @IBOutlet var timer_label: UILabel!
    @IBOutlet var delete_btn: UIButton!
    @IBOutlet var show_all_btn: UIButton!
    
    var playing = false
    var sectorLabel = UILabel()
    var wheel = UIWheel()
    var swheel = UIWheel()
    var cwheel = UIWheel()
    var curr_wheel = 0
    var timer = Timer()
    var Timer_val = 0
    var moveArray : [Movement] = []
    var readString = ""
    var selectedWheelOption = ""
    
    //Setup after load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add wheel to placeholder and initialise view
        sectorLabel = UILabel(frame: CGRect(x: 100, y: 350, width: 120, height: 30))
        sectorLabel.textAlignment = NSTextAlignment.center
        view.addSubview(sectorLabel)
        wheel = UIWheel( frame: CGRect(x: 0, y: 0, width: 200, height: 200), andDelegate: self, withSections: 5, withBackground: "wheel1_bg.png", withIconsPrefix: "icon", withCenterIcon: "centerButton.png")
        wheel.delegate = self
        wheel.center = wheel1.center
        swheel = UIWheel( frame: CGRect(x: 0, y: 0, width: 200, height: 200), andDelegate: self, withSections: 5, withBackground: "wheel1_bg.png", withIconsPrefix: "sicon", withCenterIcon: "centerButton.png")
        swheel.delegate = self
        swheel.center = wheel2.center
        slider.value = 0
        slider.maximumValue = 1000
        view.addSubview(wheel)
        view.addSubview(swheel)
        cwheel = wheel
    }
    
    // Iphone low on memory asking us to dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Load handling
    func load()
    {
        FileTools.showloadfilescreen(current_view: self)
    }
    //Funciton to load a Dance
    func loaddance(read: String)
    {
        var i = 0
        self.readString = read
        self.moveArray.removeAll()
        let seperated = self.readString.components(separatedBy: "/")
        seperated.forEach { element in
            if(i==0){
                self.slider.maximumValue = Float(element)!
                i+=1
            }else{
                let line = element.split(separator: ";")
                if(line.count > 1)
                {
                    let name = line[0]
                    let begin = line[1]
                    let duration = line[2]
                    var i = 3
                    var args : [Int] = []
                    while( i < line.count)
                    {
                        args.append(Int(line[i])!)
                        i+=1
                    }
                    let newMove = Movement(name: String(name),begin: Float(begin)!,duration: Int(duration)!,arglist: args)
                    self.moveArray.append(newMove)
                }
            }
        }
    }
    //User touched change track time handler
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
    
    // User touched save dance
    @IBAction func save_touched(_ sender: Any) {
        FileTools.showSaveFileNameInputDialog(current_view: self)
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
    
    
    
    // Update the moves on GUI
    func updateMoves()
    {
        //Get the options image holders
        let opt_col = self.view.subviews.compactMap { $0 as? CustomOpticons }
        //Get the options for the current second
        let moves = getmovesofsec(value: Int(slider.value))
        let moves_count = getnmovesof(value: Int(slider.value))
        var i = 0
        //For each movement get icon and put in holder
        moves.forEach { (move) in
            if(i <= moves_count)
            {
                opt_col[i].image = MoveManager.getOptionIcon(name: move.name)
                opt_col[i].isHidden = false
                i+=1
            }
        }
        //hide the rest empty holders
        while (i < 12)
        {
            opt_col[i].isHidden = true
            i+=1
        }
        //Draw on screen
        if(moves_count>0){delete_btn.isHidden = false}
        else
        {delete_btn.isHidden = true}
        if(moves_count>11){insert_btn.isHidden = true}
        else
        {insert_btn.isHidden = false}
        self.view.updateConstraints()
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
        updateMoves()
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
        //Delete option from movement list
        let m = getmovesofsec(value: Int(slider.value))
        if(!self.moveArray.isEmpty){
            if(!m.isEmpty){
                self.moveArray.remove(at: moveArray.index(of: m.last!)!)
            }}
        updateMoves()
    }
    //Count moves in this second
    func getnmovesof(value: Int) -> Int
    {
        var end = 0
        var count = 0
        moveArray.forEach { (move) in
            end = Int(move.begin) + move.duration
            if (Int(slider.value) <= end && Int(slider.value) >= Int(move.begin))
            {
                count+=1
            }}
        return count
    }
    //Get the moves
    func getmovesofsec(value: Int) -> [Movement]
    {
        var moves : [Movement] = []
        var end = 0
        moveArray.forEach { (move) in
            end = Int(move.begin) + move.duration
            if (Int(slider.value) <= end && Int(slider.value) >= Int(move.begin))
            {
                moves.append(move)
            }}
        return moves
    }
    
    //Function to make adjusting the slider move through the song.
    @IBAction func slider_value_changed(_ sender: Any) {
        Timer_val = Int(slider.value)
        Timer_val-=1
        updateTimer()
        updateMoves()
    }
    
    //Wheel Rotation handling
    func wheelDidChangeValue(_ newValue: String!, withwheel wheel: NSObject!) {
        if (wheel == self.wheel)
        {
            swheel.alpha = 0.2
            self.wheel.alpha = 1
            curr_wheel=0
            selectedWheelOption = newValue
        }
        else
        {
            self.wheel.alpha = 0.2
            swheel.alpha = 1
            curr_wheel=1
            selectedWheelOption = swheel.getCloveName((swheel.currentValue)+5)
        }
    }
    
    //Get Selected Wheel
    func getCurrWheel() -> UIWheel
    {
        if(curr_wheel > 0)
        {
            return swheel
        }
        else
        {
            return wheel
        }
    }
    
    //Option Insertion handling
    @IBAction func insert_option(_ sender: Any) {
        if selectedWheelOption.contains("take_off") { let newMove = Movement(name:"take_off"
            ,begin:self.slider.value,duration:1*100, arglist: [1])
            self.moveArray.append(newMove)
            self.updateMoves();return}
        if selectedWheelOption.contains("land") { let newMove = Movement(name:"land"
            ,begin:self.slider.value,duration:1*100, arglist: [])
            self.moveArray.append(newMove)
            self.updateMoves();return}
        if selectedWheelOption.contains("flip") {
            let insertAlert = UIAlertController(title: "Choose Flip Direction", message: "Select Direction:", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            //adding the action to dialog box
            let forward = UIAlertAction(title: "Forward", style: .default)
            {
                (_) in
                let newMove = Movement(name:"flip"
                    ,begin:self.slider.value,duration:1*100, arglist: [0])
                self.moveArray.append(newMove)
                self.updateMoves()
            }
            let backward = UIAlertAction(title: "Backward", style: .default)
            {
                (_) in
                let newMove = Movement(name:"flip"
                    ,begin:self.slider.value,duration:1*100, arglist: [1])
                self.moveArray.append(newMove)
                self.updateMoves()
            }
            let left = UIAlertAction(title: "Left", style: .default)
            {
                (_) in
                let newMove = Movement(name:"flip"
                    ,begin:self.slider.value,duration:1*100, arglist: [2])
                self.moveArray.append(newMove)
                self.updateMoves()
            }
            let right = UIAlertAction(title: "Right", style: .default)
            {
                (_) in
                let newMove = Movement(name:"flip"
                    ,begin:self.slider.value,duration:1*100, arglist: [3])
                self.moveArray.append(newMove)
                self.updateMoves()
            }
            insertAlert.addAction(forward)
            insertAlert.addAction(backward)
            insertAlert.addAction(left)
            insertAlert.addAction(right)
            insertAlert.addAction(cancelAction)
            //finally presenting the dialog box
            self.present(insertAlert, animated: true, completion: nil)
            return
        }
        //Ask user for movement duration
        //Setting title and message for the alert dialog
        let insertAlert = UIAlertController(title: "Insert Movement", message: "Enter movement data:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting the input values from user
            var seconds = Int((insertAlert.textFields?[0].text)!)
            let speed = Int((insertAlert.textFields?[1].text)!)
            if(speed == nil || seconds == nil){return}
            let args = [speed!]
            if(seconds != nil && speed != nil){
                //Set slider value
                if(!(seconds != nil)){seconds = 0}
                let newMove = Movement(name:MoveManager.getOptionName(wheel: self.curr_wheel, value: Int(self.getCurrWheel().currentValue))
                    ,begin:self.slider.value,duration:seconds!*100, arglist: args)
                self.moveArray.append(newMove)
                self.updateMoves()}
        }
        //adding textfields to our dialog box
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Seconds"
            textField.keyboardType = .numberPad
        }
        insertAlert.addTextField { (textField) in
            textField.placeholder = "Speed percentage"
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
    
    
    //Go back to main function
    @IBAction func back_pressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Show last movement button touched
    @IBAction func show_all_touched(_ sender: Any) {
        if(!moveArray.isEmpty)
        {
            slider.value = Float((moveArray.last?.begin)!)
        }
    }
    //Requiered Constructors
    /*
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
     */
}

