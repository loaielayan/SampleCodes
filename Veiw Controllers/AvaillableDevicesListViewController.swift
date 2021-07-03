//
//  AvaillableDevicesListViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 10/8/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

@objc class AvaillableDevicesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddDevice
{

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    
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
//        if UIDevice.current.userInterfaceIdiom == .pad{
//            menu.menuWidth = self.view.frame.size.width / 2
//        }
        self.present(menu, animated: true, completion: nil)
        
    }
    
    
    @objc var availlableDevices = [BLDNADevice]()
    
    @objc func setAvaillableDevices(devices: [BLDNADevice]){
        self.availlableDevices = devices
    }
    
    var showDevices = [BLDNADevice]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //print(self.availlableDevices)
        
        navigationItem.title = "Availlable Devices".localiz()
        mainTitle.text = "Availlable Devices".localiz()
        nextButton.setTitle("Next".localiz(), for: .normal)
        
        if LanguageManager.shared.currentLanguage == .ar{
            arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        }

    }
    
    func addSelectedDevice(device: BLDNADevice)
    {
        if self.showDevices.contains(device){
            if let index = self.showDevices.firstIndex(of: device)
            {
                self.showDevices.remove(at: index)
                if self.showDevices.isEmpty{
                    self.nextButton.isHidden = true
                    self.arrowImage.isHidden = true
                }
                return
        
            }
        }
        self.showDevices.append(device)
        self.nextButton.isHidden = false
        self.arrowImage.isHidden = false
        
    }
    
    @IBAction func nextButton(_ sender: UIButton)
    {
        if self.showDevices.isEmpty{

            return
        }
        storeDeviceIndex()
    }
    
    @IBAction func addButtonAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "AddDevice", sender: self)
    }
    
    
    
    func storeDeviceIndex() // add device
    {
        
        for device in showDevices
        {
            let result = BLLet.shared()?.controller.pair(with: device)
            
            if (result?.succeed())!{
                
                device.controlId = UInt(result!.getId())
                device.controlKey = result?.getKey()
                
                let deviceService = BLDeviceService.shared()
                deviceService?.addNewDeivce(device)
                print("Device added \(device)")
                
                self.performSegue(withIdentifier: "ShowDevices", sender: self)
            }
        }
        
        
        
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availlableDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvaillableDevicesTableViewCell") as! AvaillableDevicesTableViewCell
        cell.deviceNameLabel.text = availlableDevices[indexPath.row].name
        cell.macAddressLabel.text = availlableDevices[indexPath.row].mac
        cell.delegate = self
        cell.device = availlableDevices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AvaillableDevicesTableViewCell
        if LanguageManager.shared.currentLanguage == .ar{
            cell.semanticContentAttribute = .forceRightToLeft
        }
        //cell.selectionStyle = .none
        tableView.deselectRow(at: indexPath, animated: true)
        cell.addDevice(UIButton())
        
    }
    
    


}
