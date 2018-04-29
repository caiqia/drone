//
//  PlaybackViewController.swift
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

import UIKit


class PlaybackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func readFile(controller:UIAlertController){
        var readString = ""
        let dancename = String((controller.textFields?[0].text)!)
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filUrl = dirUrl.appendingPathComponent(dancename).appendingPathExtension("txt")
        do{
            readString = try String(contentsOf: filUrl)
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
        print(readString)
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
    
    @IBAction func cancelTomain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
