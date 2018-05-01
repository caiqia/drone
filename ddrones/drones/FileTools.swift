//
//  FileTools.swift
//  drones
//
//  Created by Shawky on 18/04/2018.
//  Copyright © 2018 PSAR. All rights reserved.
//

import Foundation
class FileTools
{
    class func save(name : String)
    {
        let file = name //this is the file. we will write to and read from it
        
        let text = "some text" //just a text
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                /* error handling here */
            }
        }
    }
    class func showSaveFileNameInputDialog(current_view:UIViewController) {
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Save Song", message: "Enter song file name:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting File input value from user
            let myname = alertController.textFields?[0].text
            self.save(name : myname!)
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter File Name"
        }
        //adding the action to dialog box
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        current_view.present(alertController, animated: true, completion: nil)
    }
    class func showloadfilescreen(current_view: UIViewController)
    {
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Load Dance", message: "Pick your Dance:", preferredStyle: .alert)
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        var FileNames = [String]()
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            FileNames = directoryContents.map{ $0.deletingPathExtension().lastPathComponent }
            
        } catch {
            print(error.localizedDescription)
        }
        
        for name in FileNames
        {
            // process files names using buttons
            let FileAction = UIAlertAction(title: name, style: .default)
            {
                (_) in
                //getting File input value from user
                LoadDance(name: name)
            }
            alertController.addAction(FileAction)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding the cancel to dialog box
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        current_view.present(alertController, animated: true, completion: nil)
    }
    
    class func LoadDance(name: String)
    {
        
    }
}
