//
//  DataViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit
import MediaPlayer

class DanceEditorViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIWheelDelegate{
    
    init(sectorLbl: UILabel, aDecoder: NSCoder) {
        self.sectorLabel = sectorLbl
        super.init(coder: aDecoder)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sectorLabel = UILabel()
        super.init(coder: aDecoder)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    var pickerData: [NSString] = [NSString]()
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var sliderTimer: UISlider!
    // qiaoshan :
    @IBOutlet var wheel1: UIImageView!
    
    @IBOutlet weak var editorPicker: UIPickerView!
    var userpicked = NSString();
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userpicked = pickerData[row]
        self.view.endEditing(true)
    }
    var sectorLabel: UILabel
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // qiaoshan : The audio file is extracted from the Application's bundle
        sectorLabel = UILabel(frame: CGRect(x: 100, y: 350, width: 120, height: 30))
        sectorLabel.textAlignment = NSTextAlignment.center
        view.addSubview(sectorLabel)
        let wheel = UIWheel(frame: CGRect(x: 0, y: 0, width: 200, height: 200), andDelegate: self, withSections: 8)
        wheel?.delegate = self
        wheel?.center = wheel1.center
        wheel1.isHidden = true
        view.addSubview(wheel!)
        pickerData = ["Ascend", "Descend", "Move Left", "Move right", "Forward", "Backward"]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //qioashan :
   
    
    //Function to make adjusting the slider move through the song.
    @IBAction func sliderTimeChanged(sender: AnyObject) {
        
    }
    
    func wheelDidChangeValue(_ newValue: String?) {
        sectorLabel.text = newValue as String?
        print(newValue)
    }
    
    @IBAction func cancelTomain(_ sender: Any) {
        performSegue(withIdentifier: "editorTomain", sender: self)
    }
    
}

