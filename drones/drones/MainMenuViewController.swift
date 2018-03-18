//
//  MainMenuViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UIPageViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITapGestureRecognizer {
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
    
    var pageViewController: UIPageViewController?

    @IBOutlet weak var MainMenuPicker: UIPickerView!
     var pickerData: [NSString] = [NSString]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure current view
        pickerData = ["Create a new dance", "Playback a dance", "Live mode", "Edit a dance", "Options", "Help"]
        self.MainMenuPicker.delegate = self
        self.MainMenuPicker.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(OCAccountSettingsViewController.pickerTapped(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        pickerView.addGestureRecognizer(tap)
        
    }
    // Add listener to picker menu
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true}
    // Callback for listener when user touchs an item
    func pickerTapped(tapRecognizer:UITapGestureRecognizer)
    {
        if (tapRecognizer.state == UIGestureRecognizerState.Ended)
        {
            let rowHeight : CGFloat  = self.pickerView.rowSizeForComponent(0).height
            let selectedRowFrame: CGRect = CGRectInset(self.pickerView.bounds, 0.0, (CGRectGetHeight(self.pickerView.frame) - rowHeight) / 2.0 )
            let userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, tapRecognizer.locationInView(pickerView)))
            if (userTappedOnSelectedRow)
            {
                let selectedRow = self.pickerView.selectedRowInComponent(0)
                //here goes the transitions to other screens
            }
        }
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    

}

