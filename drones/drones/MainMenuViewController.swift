import UIKit

class MainMenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    @IBOutlet var MainMenuPicker: UIPickerView!
    @IBOutlet var back_btn: UIButton!
    @IBOutlet var forward_btn: UIButton!
    
    var pickerData: [NSString] = [NSString]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure current view
        pickerData = ["Create a new dance", "Playback a dance", "Live mode", "Edit a dance", "Options", "Help"]
        self.MainMenuPicker.delegate = self
        self.MainMenuPicker.dataSource = self
       userpicked = pickerData[0]
    }
    
    @IBAction func forward_touched(_ sender: Any) {
        switch userpicked{
        case "Create a new dance":
            performSegue(withIdentifier: "mainToeditor", sender: self)
        case "Playback a dance":
            performSegue(withIdentifier: "mainToplayback", sender: self)
        case "Live mode":
            performSegue(withIdentifier: "mainTolive", sender: self)
        case "Edit a dance":
            performSegue(withIdentifier: "mainToeditor", sender: self)
        case "Options":
            performSegue(withIdentifier: "mainTooption", sender: self)
        case "Help":
            performSegue(withIdentifier: "mainTooption", sender: self)
        default:
            print("welcome")
        }
    }
}
