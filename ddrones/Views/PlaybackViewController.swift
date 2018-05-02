//
//  PlaybackViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit


class PlaybackViewController: UIViewController {

    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var timer_label: UILabel!
    
    var Timer_val = 0
    var playing = false
    var timer = Timer()
    var readString = ""
    var moveArray : [Movement] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.value = 0
        self.slider.maximumValue = 1000

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func closeAction(_ sender: Any){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func listFile(controller:UIAlertController){
        let myView = UIView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.size.width-100, height: self.view.frame.size.height-100))
        myView.tag = 100
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("close", for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        myView.addSubview(button)
        let posx = 0
        let posy = 20
        let cenx = 120
        let ceny = 120
        var count = 0
        var nameArray = ""
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        do {
            let filelist = try FileManager.default
                .contentsOfDirectory(atPath: dirUrl.path)
            for filename in filelist {
                print(filename)
                nameArray.append(filename)
                nameArray.append("; ")
                if(count < 4){
                    let label = UILabel(frame: CGRect(x: posx+count*120, y: posy, width: 200, height: 21))
                    label.center = CGPoint(x: cenx+count*120, y: ceny)
                    label.textAlignment = .center
                    label.text = filename
                    myView.addSubview(label)
                }
                if(3 < count && count < 8){
                    let label = UILabel(frame: CGRect(x: posx+(count-4)*120, y: posy+20, width: 200, height: 21))
                    label.center = CGPoint(x: cenx+count*120, y: ceny)
                    label.textAlignment = .center
                    label.text = filename
                    myView.addSubview(label)
                }
                count = count+1
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        self.view.addSubview(myView)
    }
    

    //playing timer
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
         self.moveArray.forEach { onemove in
         if(Int(onemove.begin) < self.Timer_val && self.Timer_val < (Int(onemove.begin) + onemove.duration)){
         self.myImage.image = UIImage(named: self.findImage(name: onemove.name))
            print("affich!!")
         }
         }
    }
    
    func findImage(name : String) -> String {
        var res = ""
        switch name {
        case "take off":
            res = "icon0.png"
        case "land":
            res = "icon1.png"
        case "rotate":
            res = "icon2.png"
        case "lockx":
            res = "icon3.png"
        case "locky":
            res = "icon4.png"
        case "lockz":
            res = "icon5.png"
        case "Swirl":
            res = "icon6.png"
        case "3 circles":
            res = "icon7.png"
        default:
            break
        }
        return res
    }


    func readFile(controller:UIAlertController){
        let dancename = String((controller.textFields?[0].text)!)
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filUrl = dirUrl.appendingPathComponent(dancename).appendingPathExtension("txt")
        do{
            self.readString = try String(contentsOf: filUrl)
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
        print(self.readString)
        let seperated = self.readString.split(separator: ";")
        seperated.forEach { element in

            let newlist = element.split(separator: ":")
            if(element.contains("time")){
                self.slider.maximumValue = Float(newlist[1])!
            }else{
                let name = newlist[1]
                let begin = newlist[3]
                let duration = newlist[5]
                let newMove = Movement(name: String(name),begin: Float(begin)!,duration: Int(duration)!)
                self.moveArray.append(newMove)
            }

            var name = ""
            var begin : Float = 0
            var duration = 0
            if(element.contains("name")){
                name = String(element.suffix(element.count - 7))
            }
            if(element.contains("begin")){
                begin = Float(element.suffix(element.count - 8))!
            }
            if(element.contains("duration")){
                duration = Int(element.suffix(element.count - 11))!
            }
            let newMove = Movement(name: name,begin: begin,duration:duration)
            self.moveArray.append(newMove)
        }
    }
    
    // Play button touched
    @IBAction func play_touched(_ sender: UIButton) {
         if(playing)
         {
         playing = false
         timer.invalidate()
         let img = UIImage(named: "play_icon.png")
         playButton.setImage(img, for: .normal)
         }
         else
         {
         playing = true
         let img = UIImage(named: "pause_icon.png")
         playButton.setImage(img, for: .normal)
         timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(DanceEditorViewController.updateTimer)), userInfo: nil, repeats: true)
         }
    }
    
    @IBAction func selectAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Dance", message: "Enter dance neme:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default){
            (_) in
            self.readFile(controller: alertController)
        }
        let listAction = UIAlertAction(title: "List", style: .default){
            (_) in
            self.listFile(controller: alertController)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter dance name"
            textField.keyboardType = .namePhonePad
        }
        alertController.addAction(confirmAction)
        alertController.addAction(listAction)
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Function to make adjusting the slider move through the song.
    @IBAction func slider_value_changed(_ sender: Any) {
        self.Timer_val = Int(self.slider.value)
        self.Timer_val-=1
        self.updateTimer()

    }
    
    @IBAction func cancelTomain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
