//
//  ProgressViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/24/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import UICircularProgressRing
import BLLetCore
import LanguageManager_iOS

@objc protocol CompleteProgress
{
    func complete()
    func startConfiguration(completion: @escaping ( _ success: Bool)->Void)
}


@objc class ProgressViewController: UIViewController, UICircularProgressRingDelegate
{
    @objc var delegate: CompleteProgress?

    @objc var ssidName = ""
    @objc var password = ""
    
    var showDevices = [BLDNADevice]()
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var configurationStatusLabel: UILabel!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var configItemsButton: UIButton!
    
    
    lazy var progressSize = progressView.frame.size
    lazy var progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: progressSize.width, height: progressSize.height))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        cancelButton.setTitle("Cancel".localiz(), for: .normal)
        configurationStatusLabel.text = "Configuration in progress, please wait ...".localiz()
        
        //configItemsButton.setTitle("Items to check if adding a device fails".localiz(), for: .normal)

        if LanguageManager.shared.currentLanguage == .en{
            let attributedString = NSAttributedString(string: "Items to check if adding a device fails", attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0),
                 NSAttributedString.Key.foregroundColor : UIColor.red,
                NSAttributedString.Key.underlineStyle:1.0
                ])
            configItemsButton.setAttributedTitle(attributedString, for: .normal)
            
        }else{
            let attributedString = NSAttributedString(string: "الشروط التي يجب التحقق منها", attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0),
                 NSAttributedString.Key.foregroundColor : UIColor.red,
                NSAttributedString.Key.underlineStyle:1.0
                ])
            configItemsButton.setAttributedTitle(attributedString, for: .normal)
        }
        
        
        contentView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        contentView.layer.borderWidth = 0.5
        
        contentView.layer.cornerRadius = 10
        
        
        progressRing.style = .ontop
        progressRing.innerRingColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        progressRing.outerRingColor = #colorLiteral(red: 0.6588235294, green: 0.7529411765, blue: 0.1607843137, alpha: 1)
        progressRing.outerRingWidth = 20
        progressRing.innerRingWidth = 12
        progressRing.delegate = self
        progressRing.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        progressView.addSubview(progressRing)
        

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        progressRing.startProgress(to: 100, duration: 5)
        
        self.startConfiguration()

    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        progressRing.pauseProgress()
        BLLet.shared()?.controller.deviceConfigCancel()
    }
    

    @IBAction func cancelAction(_ sender: Any)
    {
        if configurationDone{
            self.pairDevices()
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func itemsToCheckAction(_ sender: UIButton)
    {
        //let navVC = (storyboard?.instantiateViewController(withIdentifier: "AddDeviceInstructionNavigation"))!
        let navVC = (storyboard?.instantiateViewController(withIdentifier: "AddDeviceNavigation"))! as! UINavigationController
        //let addDeviceVC = navVC.viewControllers[0] as! AddDeviceViewController
        let addDeviceInstructionsVC = (storyboard?.instantiateViewController(withIdentifier: "AddDeviceInstructions"))!
        //addDeviceVC.navigationController?.pushViewController(addDeviceInstructionsVC, animated: true)
        //navVC.pushViewController(navVC.viewControllers[1], animated: true)
        self.present(navVC, animated: true, completion: nil)
        navVC.pushViewController(addDeviceInstructionsVC, animated: true)
    }
    
    var configurationDone = false
    
    func startConfiguration()
    {
        
        delegate?.startConfiguration {success in
            
            if success{
                
                self.configurationStatusLabel.text = "Configuration Done!".localiz()
                self.cancelButton.setTitle("Ok".localiz(), for: .normal)
                self.configurationDone = true
                
                self.progressRing.pauseProgress()
                self.progressRing.removeFromSuperview()
                let failureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.progressView.frame.size.width, height: self.progressView.frame.size.height))
                failureImageView.image = UIImage(named: "ConfigSuccessicon")
                self.progressView.addSubview(failureImageView)
                
            }else{
                self.configurationStatusLabel.text = "Configuration Failed!".localiz()
                self.configItemsButton.isHidden = false
                self.progressRing.pauseProgress()
                self.progressRing.removeFromSuperview()
                let failureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.progressView.frame.size.width, height: self.progressView.frame.size.height))
                failureImageView.image = UIImage(named: "ConfigFailedIcon")
                self.progressView.addSubview(failureImageView)
            }
            
        }
        
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
                self.dismiss(animated: true, completion: nil)
                self.delegate?.complete()
            }else{
                // TODO
            }
        }
        
        
        
    }
    
    
    func pairDevices()
    {
        
        let deviceService = BLDeviceService.shared()
        
        let devices = deviceService?.scanDevices.allValues as? [BLDNADevice]
        
        if devices!.count != 0
        {
            for device in devices!{
                if let did = device.did{
                    if (deviceService?.manageDevices[did]) != nil {
                        self.dismiss(animated: true, completion: nil)
                        delegate?.complete()
                    }else{
                        self.showDevices.append(device)
                        self.storeDeviceIndex()
                    }
                }
                
            }
            
            
            
        }else{
            
           //TODO
        }
        
        
        
        
    }

        

    // #Mark: progress delegate
    
    func didFinishProgress(for ring: UICircularProgressRing)
    {
        ring.resetProgress()
        ring.startProgress(to: 100, duration: 5)
    }
    
    func didPauseProgress(for ring: UICircularProgressRing) {
        
    }
    
    func didContinueProgress(for ring: UICircularProgressRing) {
        
    }
    
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: CGFloat) {
        
        
    }
    
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
        
    }
    
}
