//
//  DataViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit
import MediaPlayer

class DanceEditorViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    var pickerData: [NSString] = [NSString]()
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var sliderTimer: UISlider!
    var dataObject: String = ""
    // qiaoshan :
   
    @IBOutlet weak var editorPicker: UIPickerView!
    var userpicked = NSString();
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userpicked = pickerData[row]
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // qiaoshan : The audio file is extracted from the Application's bundle
        pickerData = ["Ascend", "Descend", "Move Left", "Move right", "Forward", "Backward"]
        self.editorPicker.delegate = self
        self.editorPicker.dataSource = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }
    //qioashan :
   
    
    //Function to make adjusting the slider move through the song.
    @IBAction func sliderTimeChanged(sender: AnyObject) {
        
    }
    
    
    @IBAction func cancelTomain(_ sender: Any) {
        performSegue(withIdentifier: "editorTomain", sender: self)
    }
    
}

