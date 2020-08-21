//
//  FileTools.swift
//  drones
//
//  Created by Shawky on 18/04/2018.

//

import Foundation
class FileTools
{
    class func save(name : String, current_view:DanceEditorViewController)
    {
        // Get App Support Directory
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // Build file name
        let filUrl = dirUrl.appendingPathComponent(name).appendingPathExtension("ddnc")
        // Save dance time
        var res = ""
        res.append(String(current_view.slider.maximumValue))
        res.append("/")
        // Save movements
        current_view.moveArray.forEach { oneMove in
            res.append(oneMove.toString())
        }
        do{
            // Write File
            try res.write(to: filUrl, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print("fail to write")
            print(error)
        }
    }
    
    // Create a save dance dialog for the user
    class func showSaveFileNameInputDialog(current_view:DanceEditorViewController) {
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Save Song", message: "Enter song file name:", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        {
            (_) in
            //getting File input value from user
            let myname = alertController.textFields?[0].text
            self.save(name : myname!, current_view : current_view)
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
    
    //Create a load dance dialog for the user
    class func showloadfilescreen(current_view: UIViewController)
    {
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Load Dance", message: "Pick your Dance:", preferredStyle: .alert)
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var FileNames = [String]()
        do {
            // Get the directory contents urls (including subfolders urls)
            var directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
    
            directoryContents = directoryContents.filter{ $0.pathExtension == "ddnc" }
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
                //Load File Handler
                LoadDance(name: name, current_view: current_view)
            }
            alertController.addAction(FileAction)
        }
        
        //the cancel action doing dismiss view
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in alertController.dismiss(animated: true, completion: nil)}
        
        //adding the cancel to dialog box
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        current_view.present(alertController, animated: true, completion: nil)
    }
    
    class func LoadDance(name: String, current_view: UIViewController)
    {
        //Read File
        let dirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filUrl = dirUrl.appendingPathComponent(name).appendingPathExtension("ddnc")
        let readString = try? String(contentsOf: filUrl)
        //If valid pass to load function of corresponding controller
        if ((readString) != nil)
        {
            let cv = (current_view as? DanceEditorViewController)
            if ( cv != nil) {
                //Load into Dance Modifier
                cv!.loaddance(read : readString!)
            }
            let pb = (current_view as? PlaybackViewController)
            if (pb != nil){ // Load it in Playback
                pb!.playdance(read : readString!)
            }
        }
    }
}
