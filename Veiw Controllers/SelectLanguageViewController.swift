//
//  SelectLanguageViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/16/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import DLRadioButton

class SelectLanguageViewController: UIViewController
{
    
    @IBAction func revealMenu(_ sender: UIBarButtonItem)
    {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! SideMenuNavigationController
        if LanguageManager.shared.currentLanguage == .ar{
            menu.leftSide = false
        }else{
            menu.leftSide = true
        }
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.backgroundColor = UIColor.clear
        self.present(menu, animated: true, completion: nil)

    }
    
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var defaultLanguageButton: UIButton!
    @IBOutlet weak var changeLanguageNote: UILabel!
    @IBOutlet weak var setDefaultLanguageButton: DLRadioButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var languageSelectionsContentView: UIView!
    @IBOutlet weak var languageDefaultContentView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    
    var presentedFromMainPage = false
    
    var availlableDevices = [BLDNADevice]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            backgroundImage.image = UIImage(named: "select-language-ipad")
        }
        
        setDefaultLanguageButton.imageView?.contentMode = .scaleToFill
        setDefaultLanguageButton.contentMode = .scaleToFill
        languageSelectionsContentView.semanticContentAttribute = .forceLeftToRight
        
        
        if let defaultLanguageUserSelection = UserDefaults.standard.value(forKey: "UserHasSelectedDefaultLanguage") as? Bool
        {
            if defaultLanguageUserSelection{
                
                if let defaultLanguageSelection = UserDefaults.standard.value(forKey: "UserSelectedDefaultLanguage") as? String
                {
                    
                    if defaultLanguageSelection == "English"{
                        
                        self.selectedLanguage = .en
                        
                        
                    }else if defaultLanguageSelection == "Arabic"{
                        
                        self.selectedLanguage = .ar
                        
                        
                    }
                }

                
            }
            
        }

        
        navigationItem.title = "Select Language" + " - " + "اختيار اللغة"
        


    }
    
    @objc func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any)
    {
        if (selectedLanguage != nil){
            
            if self.presentedFromMainPage{
                let vc = storyboard?.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
                LanguageManager.shared.setLanguage(language: selectedLanguage!, rootViewController: vc, animation: nil)
                return
            }
            
            if BLDeviceService.shared()?.manageDevices.count != 0{
                let vc = storyboard?.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
                LanguageManager.shared.setLanguage(language: selectedLanguage!, rootViewController: vc, animation: nil)
                
                return
            }
            
            
            
            if self.availlableDevices.count != 0{
                let vc = storyboard?.instantiateViewController(withIdentifier: "AvaillableDevicesNavigation") as! UINavigationController
                let dvc = vc.viewControllers[0] as! AvaillableDevicesListViewController
                dvc.availlableDevices = self.availlableDevices
                LanguageManager.shared.setLanguage(language: selectedLanguage!, rootViewController: vc, animation: nil)
                return
            }else{ //  availlable devices are empty because its not passed from other vc
                let deviceService = BLDeviceService.shared()
                if let devices = deviceService?.scanDevices.allValues as? [BLDNADevice]{
                    
                    if devices.count != 0
                    {
                        for device in devices{
                            self.availlableDevices.append(device)
                            let vc = storyboard?.instantiateViewController(withIdentifier: "AvaillableDevicesNavigation") as! UINavigationController
                            let dvc = vc.viewControllers[0] as! AvaillableDevicesListViewController
                            dvc.availlableDevices = self.availlableDevices
                            LanguageManager.shared.setLanguage(language: selectedLanguage!, rootViewController: vc, animation: nil)
                            return
                        }
                    }
                    
                }
            }
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddDeviceNavigation")
            LanguageManager.shared.setLanguage(language: selectedLanguage!, rootViewController: vc, animation: nil)
            
        }else{
            let alert = UIAlertController(title: NSLocalizedString("Please choose language", comment: ""), message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    func pairDevices()
    {
        
        let deviceService = BLDeviceService.shared()
        let devices = deviceService?.scanDevices.allValues as? [BLDNADevice]
        
        if devices!.count != 0
        {
            
        }
    }
    
    var selectedLanguage: Languages? = nil{
        didSet{
            setDefaultLanguageButton.semanticContentAttribute = .forceLeftToRight
            if self.selectedLanguage == .en{
                changeLanguageNote.isHidden = false
                defaultLanguageButton.isHidden = false
                setDefaultLanguageButton.isHidden = false
                nextButton.isHidden = false
                
                
                englishLabel.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
                englishLabel.font = UIFont.boldSystemFont(ofSize: 24)
                arabicLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                arabicLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                
                
                changeLanguageNote.text = "You can change the language from the settings"
                defaultLanguageButton.setTitle("Set as default language", for: .normal)
                //defaultLanguageButton.semanticContentAttribute = .forceLeftToRight
                nextButton.setTitle("Done", for: .normal)
                //setDefaultLanguageButton.semanticContentAttribute = .forceLeftToRight
                //defaultLanguageButton.semanticContentAttribute = .forceLeftToRight
                changeLanguageNote.semanticContentAttribute = .forceLeftToRight
                //defaultLanguageButton.contentHorizontalAlignment = .left
                languageDefaultContentView.semanticContentAttribute = .forceLeftToRight

                
                if let defaultLanguageUserSelection = UserDefaults.standard.value(forKey: "UserHasSelectedDefaultLanguage") as? Bool
                {
                    if defaultLanguageUserSelection{
                        if let defaultLanguageSelection = UserDefaults.standard.value(forKey: "UserSelectedDefaultLanguage") as? String
                        {
                            //self.selected = true
                            if defaultLanguageSelection == "English"{
                                
                                
                                self.setDefaultLanguageButton.isSelected = true
                                self.selected = true
                                
                            }else if defaultLanguageSelection == "Arabic"{
                                
                                
                                self.setDefaultLanguageButton.isSelected = false
                                self.selected = false
                                
                                
                            }
                        }
                    }

                    
                } // if let

                
            }else{
                
                changeLanguageNote.isHidden = false
                defaultLanguageButton.isHidden = false
                setDefaultLanguageButton.isHidden = false
                nextButton.isHidden = false

                
                englishLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                englishLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                arabicLabel.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
                arabicLabel.font = UIFont.boldSystemFont(ofSize: 24)
                
                changeLanguageNote.text = "يمكنك تغيير اللغة من الإعدادات"
                defaultLanguageButton.setTitle("إختيار كلغة مفضلة", for: .normal)
                //defaultLanguageButton.semanticContentAttribute = .forceRightToLeft
                nextButton.setTitle("تم", for: .normal)
                //setDefaultLanguageButton.semanticContentAttribute = .forceRightToLeft
                //defaultLanguageButton.semanticContentAttribute = .forceRightToLeft
                changeLanguageNote.semanticContentAttribute = .forceRightToLeft
                defaultLanguageButton.contentHorizontalAlignment = .right
                languageDefaultContentView.semanticContentAttribute = .forceRightToLeft
                
                
                
                if let defaultLanguageUserSelection = UserDefaults.standard.value(forKey: "UserHasSelectedDefaultLanguage") as? Bool
                {
                    if defaultLanguageUserSelection{
                        
                        
                        if let defaultLanguageSelection = UserDefaults.standard.value(forKey: "UserSelectedDefaultLanguage") as? String
                        {
                            //self.selected = true
                            if defaultLanguageSelection == "English"{
                                
                                
                                self.setDefaultLanguageButton.isSelected = false
                                self.selected = false
                                
                            }else if defaultLanguageSelection == "Arabic"{
                                
                                self.setDefaultLanguageButton.isSelected = true
                                self.selected = true
                                
                                
                            }
                        } // inner if let
                    } // if statement
                    
                    
                } // outter if let
                
            } // else
        } // did Set
    } // var declaration
    
    @IBAction func EnglishSelected(_ sender: UIButton)
    {
        selectedLanguage = .en

    }
    
    @IBAction func ArabicSelected(_ sender: UIButton)
    {
        selectedLanguage = .ar

    }
    
    var selected = false
    @IBAction func setAsDefaultLanguage(_ sender: UIButton)
    {
        print(selected)
        if selectedLanguage == nil{
            return
        }
        selected = !selected
        

    
        if !selected
        {
            setDefaultLanguageButton.isSelected = false
            UserDefaults.standard.set(false, forKey: "UserHasSelectedDefaultLanguage")
        }else{
            setDefaultLanguageButton.isSelected = true
            UserDefaults.standard.set(true, forKey: "UserHasSelectedDefaultLanguage")
            UserDefaults.standard.set(selectedLanguage! == .en ? "English" : "Arabic", forKey: "UserSelectedDefaultLanguage")
        }

        
    }

    
    

}
