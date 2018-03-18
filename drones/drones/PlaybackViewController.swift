//
//  PlaybackViewController.swift
//  drones
//
//  Created by Qiaoshan Cai on 18/03/2018.
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
    @IBAction func cancelTomain(_ sender: Any) {
        performSegue(withIdentifier: "playbackTomain", sender: self)
    }
    
}
