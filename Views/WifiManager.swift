//
//  WifiManager.swift
//  drones
//
//  Created by Shawky on 06/05/2018.

//

import UIKit
import Foundation
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

final class WifiManager: UIViewController {
    
    private let SSID = ""

    
    func getInterfaces() -> Bool {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getInterfaces())
        // Do any additional setup after loading the view, typically from a nib.
    }}
    /*
    @IBAction func connectAction(_ sender: Any) {
        if #available(iOS 11.0, *) {
            let hotspotConfig = NEHotspotConfiguration(ssid: SSID, passphrase: "", isWEP: false)
            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[unowned self] (error) in
                
                if let error = error {
                    self.showError(error: error)
                }
                else {
                    self.showSuccess()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func disconnectAction(_ sender: Any) {
        if #available(iOS 11.0, *) {
            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: SSID)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Darn", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func showSuccess() {
        let alert = UIAlertController(title: "", message: "Connected", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cool", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
 }*/
