//
//  InitialViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/1/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import BLLetCore
import LanguageManager_iOS



class InitialViewController: UIViewController
{
    var timer: Timer!
    var showDevices = [BLDNADevice]()
    
    @IBOutlet weak var welcomingMessageEnglish: UILabel!
    @IBOutlet weak var welcomingMessageArabic: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var labelToSafeAreaTopConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            backgroundImage.image = UIImage(named: "splash-ipad")
            labelToSafeAreaTopConstraint.constant = 400
        }
    }
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        
        welcomingMessageEnglish.animate(newText: "Welcome to Aukia", characterDelay: 0.1)
        welcomingMessageArabic.animate(newText: "اهلا بك في تطبيق اوكيا", characterDelay: 0.1)


        let account = BLAccount.shared()
        let userName = "loaielayan@yahoo.com"
        let password = "Az123***"
        account?.login(userName, password: password, completionHandler: { (result) in
            if result.succeed(){

                DispatchQueue.main.async {
                  let userDefault = BLUserDefaults.share()
                    userDefault?.setUserName(userName)
                    userDefault?.setUserId(result.userid)
                    userDefault?.setSessionId(result.loginsession)
                }
            }else{
                DispatchQueue.main.async {

                }
            }
        })



        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(start), userInfo: nil, repeats: false)
        
        
    }
    
    
    @objc func start()
    {
        
        let deviceService = BLDeviceService.shared()
        let dids = deviceService?.manageDevices.allKeys
        
        
        if dids?.count == 0
        {
            self.pairDevices()
            
        }else{
            
            /////
            if let defaultLanguageUserSelection = UserDefaults.standard.value(forKey: "UserHasSelectedDefaultLanguage") as? Bool{
                if defaultLanguageUserSelection{
                    
                    if let defaultLanguageSelection = UserDefaults.standard.value(forKey: "UserSelectedDefaultLanguage") as? String
                    {
                        if defaultLanguageSelection == "English"{
                            LanguageManager.shared.setLanguage(language: .en, rootViewController: storyboard?.instantiateViewController(withIdentifier: "HomeNavigation"), animation: nil)
                            
                        }else if defaultLanguageSelection == "Arabic"{
                            LanguageManager.shared.setLanguage(language: .ar, rootViewController: storyboard?.instantiateViewController(withIdentifier: "HomeNavigation"), animation: nil)
                        }
                    }
                    
                    
                }else{ // user has not selected default language
                    self.performSegue(withIdentifier: "Main", sender: self)
                    //self.performSegue(withIdentifier: "ShowDevices", sender: self)
                }
            }else{
                self.performSegue(withIdentifier: "Main", sender: self)
                //self.performSegue(withIdentifier: "ShowDevices", sender: self)
            }
            /////
            
            //self.performSegue(withIdentifier: "ShowDevices", sender: self)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        
        timer.invalidate()
    }
    
//    func storeDeviceIndex() // add device
//    {
//
//        for device in showDevices
//        {
//            let result = BLLet.shared()?.controller.pair(with: device)
//
//            if (result?.succeed())!{
//
//                device.controlId = UInt(result!.getId())
//                device.controlKey = result?.getKey()
//
//                let deviceService = BLDeviceService.shared()
//                deviceService?.addNewDeivce(device)
//                print("Device added \(device)")
//
//                self.performSegue(withIdentifier: "ShowDevices", sender: self)
//            }
//        }
//
//
//
//    }
    
    //    var isSecondPairingCall = false
    //    var counter = 0
    
    func pairDevices()
    {
        
        let deviceService = BLDeviceService.shared()
        
        let devices = deviceService?.scanDevices.allValues as? [BLDNADevice]
        
        if devices!.count != 0
        {
            for device in devices!{
                if let did = device.did{
                    if (deviceService?.manageDevices[did]) != nil {
                        self.performSegue(withIdentifier: "ShowDevices", sender: self)
                    }else{
                        self.showDevices.append(device)
                        
                        
                        if let defaultLanguageUserSelection = UserDefaults.standard.value(forKey: "UserHasSelectedDefaultLanguage") as? Bool{
                            if defaultLanguageUserSelection{
                                if let defaultLanguageSelection = UserDefaults.standard.value(forKey: "UserSelectedDefaultLanguage") as? String
                                {
                                    if defaultLanguageSelection == "English"{
                                        let navVC = storyboard?.instantiateViewController(withIdentifier: "AvaillableDevicesNavigation") as! UINavigationController
                                        let dvc = navVC.viewControllers[0] as! AvaillableDevicesListViewController
                                        dvc.availlableDevices = self.showDevices
                                        LanguageManager.shared.setLanguage(language: .en, rootViewController: navVC, animation: nil)
                                        
                                    }else if defaultLanguageSelection == "Arabic"{
                                        let navVC = storyboard?.instantiateViewController(withIdentifier: "AvaillableDevicesNavigation") as! UINavigationController
                                        let dvc = navVC.viewControllers[0] as! AvaillableDevicesListViewController
                                        dvc.availlableDevices = self.showDevices
                                        LanguageManager.shared.setLanguage(language: .en, rootViewController: navVC, animation: nil)
                                    }
                                }
                                
                                //self.performSegue(withIdentifier: "AvaillableDevices", sender: self)
                                
                            }else{
                                self.performSegue(withIdentifier: "Main", sender: self) // in that case then go to availlable devices and pass the availlable devices
                            }
                        }else{
                            
                            self.performSegue(withIdentifier: "Main", sender: self)
                        }

                        //
                    }
                }
                
            }
            
        }else{
            
            if let defaultLanguageUserSelection = UserDefaults.standard.value(forKey: "UserHasSelectedDefaultLanguage") as? Bool{
                if defaultLanguageUserSelection{
                    
                    if let defaultLanguageSelection = UserDefaults.standard.value(forKey: "UserSelectedDefaultLanguage") as? String
                    {
                        if defaultLanguageSelection == "English"{
                            LanguageManager.shared.setLanguage(language: .en, rootViewController: storyboard?.instantiateViewController(withIdentifier: "AddDeviceNavigation"), animation: nil)
                            
                        }else if defaultLanguageSelection == "Arabic"{
                            LanguageManager.shared.setLanguage(language: .ar, rootViewController: storyboard?.instantiateViewController(withIdentifier: "AddDeviceNavigation"), animation: nil)
                        }
                    }
                    
                    //self.performSegue(withIdentifier: "ShowAddDevice", sender: self)
                }else{
                    self.performSegue(withIdentifier: "Main", sender: self)
                }
            }else{
                
               self.performSegue(withIdentifier: "Main", sender: self)
            }
            
            
            
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AvaillableDevices"{
            let navvc = segue.destination as! UINavigationController
            let dvc = navvc.viewControllers[0] as! AvaillableDevicesListViewController
            dvc.availlableDevices = self.showDevices
            
        }else if segue.identifier == "Main"{
            let navvc = segue.destination as! UINavigationController
            let dvc = navvc.viewControllers[0] as! SelectLanguageViewController
            dvc.availlableDevices = self.showDevices
        }
    }
    
    
    
}

extension UILabel {
    
    func animate(newText: String, characterDelay: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.text = ""
            
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
}
