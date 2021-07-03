//
//  AddDeviceViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/6/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import Reachability
import CoreLocation


@objc class AddDeviceViewController: UIViewController, CLLocationManagerDelegate
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
    
    
    
    @IBAction func backArrow(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            backgroundImage.image = UIImage(named: "add-device-ipad")
        }
        
        if LanguageManager.shared.currentLanguage == .ar
        {
            navigationItem.title = "إضافة جهاز"
            
            secondLabel.textAlignment = .right
            
        }
        
        if LanguageManager.shared.currentLanguage == .en{
            firstLabel.textAlignment = .right
        }
        
        firstLabel.text = "Tap the".localiz()
        secondLabel.text = "to add a device".localiz()
        
        //self.getLocation()
        
        
    }
    
//    func getLocation() {
//        // 1
//        let status = CLLocationManager.authorizationStatus()
//
//        switch status {
//        // 1
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            return
//
//        // 2
//        case .denied, .restricted:
//            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//
//            present(alert, animated: true, completion: nil)
//            return
//        case .authorizedAlways, .authorizedWhenInUse:
//            break
//
//        }
//
//        // 4
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
//    }
//
//    // 1
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let currentLocation = locations.last {
//            print("Current location: \(currentLocation)")
//        }
//    }
//
//    // 2
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
    
    @IBAction func addNewDevice(_ sender: UIButton)
    {
        let reachability = Reachability()
        
        switch reachability!.connection
        {
        case .wifi:
            performSegue(withIdentifier: "AddDevice", sender: self)
        case .cellular, .none:
          let alert = UIAlertController(title: "No WiFi Connection".localiz(), message: "Please connect to wifi to configure new device".localiz(), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK".localiz(), style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        default:
            break
        }
        
    }
    
    



}
