//
//  OptionViewController.swift
//  drones
//
//  Created by Qiaoshan Cai on 18/03/2018.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerData: [String] = []
    
    var userpicked :String = ""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userpicked = pickerData[row]
        self.view.endEditing(true)
    }

    @IBOutlet weak var optionPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //qiaoshan :
        pickerData = ["Manage My Choregraphes", "Calibration", "Wifi connexion"]
        self.optionPicker.delegate = self
        self.optionPicker.dataSource = self
    }

    @IBAction func save_options(_ sender: Any)
    {
        
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
    @IBAction func cancelTomain(_ sender: Any) {
        performSegue(withIdentifier: "optionTomain", sender: self)
    }
    
}
