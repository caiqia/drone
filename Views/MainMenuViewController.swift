//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//
import UIKit

class MainMenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //Picker view delegation functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    var userpicked = NSString();
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userpicked = pickerData[row]
        self.view.endEditing(true)
    }
    //Outlets and global variables
    @IBOutlet var MainMenuPicker: UIPickerView!
    @IBOutlet var back_btn: UIButton!
    @IBOutlet var forward_btn: UIButton!
    var pickerData: [NSString] = [NSString]()
    
    //On load finished
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure current pickerview options
        pickerData = ["Create a new dance", "Playback a dance", "Live mode", "Edit a dance", "Options", "Help"]
        self.MainMenuPicker.delegate = self
        self.MainMenuPicker.dataSource = self
       userpicked = pickerData[0]
    }
    //Back button touched
    @IBAction func back_touched(_ sender: Any) {
 UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    //Forward button touched
    @IBAction func forward_touched(_ sender: Any) {
        //Switch option and perform segue
        switch userpicked{
        case pickerData[0]:
            performSegue(withIdentifier: "mainToeditor", sender: self)
        case pickerData[1]:
            performSegue(withIdentifier: "mainToplayback", sender: self)
        case pickerData[2]:
            performSegue(withIdentifier: "mainTolive", sender: self)
        case pickerData[3]:
            performSegue(withIdentifier: "mainToeditor", sender: self)
        case pickerData[4]:
            performSegue(withIdentifier: "mainTooption", sender: self)
        case pickerData[5]:
            performSegue(withIdentifier: "mainTooption", sender: self)
        default:
            print("welcome")
        }
    }
}
