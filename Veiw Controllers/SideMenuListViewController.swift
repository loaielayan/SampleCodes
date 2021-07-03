//
//  SideMenuListViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/29/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import BLLetCore


class SideMenuListViewController: UIViewController
{
    var showDevices = [BLDNADevice]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let sideMenuList = ["Device List", "Language", "Support", "Help", "V 2.2.1"]
    let sideMenuArabic = ["التحكم بمكيف أخر","اللغة","الدعم","المساعدة", "V 2.2.1"]
    
    var presentedFromHomePage = false
    
    @objc func setPresentedFromHomePage()
    {
        self.presentedFromHomePage = true
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        let label = UILabel(frame: CGRect(x: tableView.frame.size.width / 2 - 100, y: tableView.frame.size.height - 250, width: 100, height: 50))
//        label.text = "V 2.0.1"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        tableView.addSubview(label)

    }
    

}

extension SideMenuListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sideMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuTableViewCell
        
        if LanguageManager.shared.currentLanguage == .ar{
           cell.menuItemName.text = sideMenuArabic[indexPath.row]
        }else{
          cell.menuItemName.text = sideMenuList[indexPath.row]
        }
        if indexPath.row == 4{
            cell.lineView.isHidden = true
            cell.menuItemName.font = UIFont.boldSystemFont(ofSize: 20)
            cell.menuItemName.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        if indexPath.row == 0{
            let deviceService = BLDeviceService.shared()
            let dids = deviceService?.manageDevices.allKeys
            if dids?.count == 0{
                let deviceService = BLDeviceService.shared()
                let devices = deviceService?.scanDevices.allValues as? [BLDNADevice]
                if devices!.count != 0
                {
                    for device in devices!{
                        
                        self.showDevices.append(device)
                        let AvaillableDevicesNavigation = self.storyboard?.instantiateViewController(withIdentifier: "AvaillableDevicesNavigation") as! UINavigationController
                        let dvc = AvaillableDevicesNavigation.viewControllers[0] as! AvaillableDevicesListViewController
                        dvc.availlableDevices = self.showDevices
                        self.present(AvaillableDevicesNavigation, animated: true, completion: nil)
                        
                    }
                    
                }else{
                    let AddDeviceNavigation = self.storyboard?.instantiateViewController(withIdentifier: "AddDeviceNavigation")
                    self.present(AddDeviceNavigation!, animated: true, completion: nil)
                }
                return
                
            }else{
                let HomeNavigation = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigation")
                self.present(HomeNavigation!, animated: true, completion: nil)
            }
            
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageNavigation") as! UINavigationController
            let dvc = vc.viewControllers[0] as! SelectLanguageViewController
            dvc.presentedFromMainPage = self.presentedFromHomePage
            self.present(vc, animated: true, completion: nil)
        }else if indexPath.row == 2{
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "SupportNavigation"))!
            self.present(vc, animated: true, completion: nil)
        }else if indexPath.row == 3{
            
            
            if LanguageManager.shared.currentLanguage == .en{
                
                if let url = URL(string: "http://sadaalmaarfa.com/contact.php"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
                
            }else{
                
                if let url = URL(string: "http://sadaalmaarfa.com/ar/contact.php"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
                
            }
            
            

        }
        
    }
    
    
}


