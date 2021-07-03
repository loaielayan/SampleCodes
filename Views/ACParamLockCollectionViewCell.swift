//
//  ACParamLockCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 10/8/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import ProgressHUD

class ACParamLockCollectionViewCell: UICollectionViewCell
{


    
    var delegate: ACDetailsViewController?
    @IBOutlet weak var lockSwitch: UISwitch!
    

    

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if LanguageManager.shared.currentLanguage == .ar{
            self.switch.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        let deviceService = BLDeviceService.shared()
        let did = deviceService?.manageDevices.allKeys[0]
        if let device = deviceService?.selectDevice{//.manageDevices[did!] as? BLDNADevice{
            self.lockSwitch.setOn(device.getLock, animated: true)

        }
        
        
    }
    
    func setLockStatus(lock: Bool)
    {
        DispatchQueue.main.async {
            ProgressHUD.show()
            self.delegate?.collectionView.isUserInteractionEnabled = false
        }
        
        DispatchQueue.global().async {
            let controller = BLLet.shared()?.controller
            let deviceService = BLDeviceService.shared()
            let did = deviceService?.manageDevices.allKeys[0]
            if let device = deviceService?.selectDevice{//deviceService?.manageDevices[did!] as? BLDNADevice{
                let gatewayDid = (device.ownerId != nil) ? device.deviceId : device.did
                var dataString = NSString(format: "{\"data\":{\"name\":\"%@\",\"lock\":false}}" as NSString, device.name)
                if lock == true{
                    dataString = NSString(format: "{\"data\":{\"name\":\"%@\",\"lock\":true}}", device.name)
                }else{
                    dataString = NSString(format: "{\"data\":{\"name\":\"%@\",\"lock\":false}}", device.name)
                }
                let result = controller?.dnaControl(gatewayDid!, subDevDid: nil, dataStr: dataString as String, command: "dev_info", scriptPath: nil, sendcount: 1)
                let retDic = BLCommonTools.deserializeMessageJSON(result)
                let lockValue = ((retDic as! [String:Any])["data"] as! [String:Any])["lock"] as! Int
                DispatchQueue.main.async {
                    if lockValue == 1{
                        
                        self.lockSwitch.setOn(true, animated: true)
                        self.delegate?.collectionView.isUserInteractionEnabled = true
                        ProgressHUD.dismiss()
                        
                    }else{
                        
                        self.lockSwitch.setOn(false, animated: true)
                        self.delegate?.collectionView.isUserInteractionEnabled = true
                        ProgressHUD.dismiss()
                        
                        
                    }
                }

                
            }
        }

        
        
    }
    
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch)
    {
        self.setLockStatus(lock: sender.isOn)
    }
    

    
}
