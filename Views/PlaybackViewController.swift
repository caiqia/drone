//
//  PlaybackViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.

//

import UIKit


class PlaybackViewController: UIViewController {
    
    //Outlets and Declarations
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet var myImage2: UIImageView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var timer_label: UILabel!
    
    var Timer_val = 0
    var playing = false
    var timer = Timer()
    var readString = ""
    var moveArray : [Movement] = []
    var ma : [Movement] = []
    var mdone : [Movement] = []
    var done = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.value = 0
        self.slider.maximumValue = 1000
        DroneController.droneControllerInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FileTools.showloadfilescreen(current_view: self)
    }
    
    // Iphone low on memory asking us to dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Playing timer handler
    @objc func updateTimer() {
        self.Timer_val+=1
        self.slider.value+=1
        let hours = self.Timer_val / 360000;
        let minutes = (self.Timer_val - (hours * 360000)) / 6000;
        let seconds = (self.Timer_val - (hours * 360000) - (minutes * 6000)) / 100;
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm:ss"
        self.timer_label.text =
            inFormatter.string(from: inFormatter.date(from: String(hours)+":"+String(minutes)+":"+String(seconds))!)
        if self.Timer_val > Int(slider.maximumValue)
        {stop_playing();return}
        var n = done
        if(n < ma.count)
        {
            self.myImage.image = MoveManager.getOptionIcon(name: ma[n].name)
            self.myImage.isHidden = false
         
            if(Int(ma[n].begin) > Timer_val)
            {self.myImage.isHidden = true}
            if(n < ma.count - 1)
            {
                self.myImage2.image = MoveManager.getOptionIcon(name: ma[n+1].name)
                self.myImage2.isHidden = false
            }
            else
            {
                self.myImage2.isHidden = true
            }
            if(self.Timer_val > (Int(ma[n].begin) + ma[n].duration) && Timer_val > (Int(ma[n].begin))){
                n+=1
                done+=1
            }
            else
            {
                if (!mdone.contains(ma[n]))
                {
                    print ("sent ", ma[n].name,ma[n].begin, ma[n].duration, ma[n].arglist)
                    MoveManager.domove(m: ma[n])
                    mdone.append(ma[n])
                }
            }
        }
        else
        {
            self.myImage.isHidden = true
            self.myImage2.isHidden = true
        }
    }
    
    func stop_playing()
    {
        playing = false
        timer.invalidate()
        done = 0
        slider.value = 0
        let img = UIImage(named: "play_icon.png")
        playButton.setImage(img, for: .normal)
        MoveManager.reset()
        mdone = []
        Timer_val = 0
    }
    // Play button touched
    @IBAction func play_touched(_ sender: UIButton) {
        if(playing)
        {
            playing = false
            timer.invalidate()
            let img = UIImage(named: "play_icon.png")
            playButton.setImage(img, for: .normal)
            MoveManager.pause()
        }
        else
        {
            DispatchQueue.global(qos: .background).async {
                MoveManager.playmoves(lstmoves: self.moveArray.sorted(by: {$0.begin < $1.begin}))
            }
            playing = true
            let img = UIImage(named: "pause_icon.png")
            playButton.setImage(img, for: .normal)
            ma = moveArray.sorted(by: { $0.begin < $1.begin })
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    
    //Function to make adjusting the slider move through the song.
    @IBAction func slider_value_changed(_ sender: Any) {
        //We're flying user must not change time
        //self.Timer_val = Int(self.slider.value)
        //self.updateTimer()
    }
    
    @IBAction func cancelTomain(_ sender: Any) {
        if playing
        {
            if DroneController.isReady() {DroneController.land()}
        }
        dismiss(animated: true, completion: nil)
    }
    
    func playdance(read : String)
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
}
