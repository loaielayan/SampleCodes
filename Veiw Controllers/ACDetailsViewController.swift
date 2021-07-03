//
//  ACDetailsViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/29/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import BLLetBase
import BLLetCore
import MSCircularSlider
import ProgressHUD

class ACDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PassCommands, MSCircularSliderDelegate
{
    
    
    @IBOutlet weak var slider: MSCircularSlider!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tempUnitLabel: UILabel!
    
    var index = 0
    
    @objc func setIndex(index: Int){
        self.index = index
    }
    
    let vc = ACDevicesViewController()
    var timer = Timer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        slider.semanticContentAttribute = .forceLeftToRight
        
        slider.delegate = self
        navigationItem.title = "Control Dashboard".localiz()
        
        self.setTempDisplayFromCommand()
        self.setSliderStatus()
        
        //    [NSTimer scheduledTimerWithTimeInterval:10.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        //        [weakSelf.MyDeviceTable reloadData];
        //    }];
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            if let parentViewController = self.navigationController?.viewControllers[0] as? ACDevicesViewController{
                parentViewController.getStatus(self.index, withComp: { (status) in
                    
                    //print(status)
                    if status.count <= 1{
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    if !Command.shared.isDeviceOn(){
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    self.collectionView.reloadData()
                    self.setTempDisplayFromCommand()
                })
            }
        })
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    func setTempDisplayFromCommand()
    {

        let temp = vc.readTemp(Command.shared.getFinalCommand())
        let tempUnit = Command.shared.getTempUnit()
        let decimalTemp = vc.toDecimal(temp)
        tempLabel.text = String(Int(decimalTemp) + 8)

        if decimalTemp + 8 > 16{
            slider.currentValue = ((Double(decimalTemp) + 8.0) - 16.0) * (100/16)
            tempUnitLabel.text = "℃"
            
        }
        
        if tempUnit == .Fahrenheit{
            tempLabel.text = String( ( (Int(decimalTemp) + 8) * 9/5 ) + 32 )
            tempUnitLabel.text = "℉"
        }
        
    }
    
    func setSliderStatus()
    {
        let mode = command.getMode()
        
        switch mode {
        case "Auto", "Fan":
            slider.isEnabled = false
            slider.filledColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            
            
            
//        case "Heat":
//
//        case "Dry":
//
//        case "Cool":
            
        default:
            slider.isEnabled = true
            slider.filledColor = #colorLiteral(red: 0.6588235294, green: 0.7529411765, blue: 0.1607843137, alpha: 1)
        }
        
    }
    
    
    let command = Command.shared
    
    func passCommand()
    {
        
        DispatchQueue.main.async {
            ProgressHUD.show()
            self.collectionView.isUserInteractionEnabled = false
            self.slider.isUserInteractionEnabled = false

        }
        
        DispatchQueue.global().async {
            
            let fcmd = self.command.getFinalCommand()
            let deviceService = BLDeviceService.shared()
            //let did = deviceService?.manageDevices.allKeys[0]
            if let device = deviceService?.selectDevice{//deviceService?.manageDevices[did ?? ""] as? BLDNADevice{
                let vc = ACDevicesViewController()
                let result = BLLet.shared()?.controller.dnaPassthrough(device.deviceId, passthroughData: vc.hexString2Bytes(fcmd))
                if (result?.succeed())!{
                    DispatchQueue.main.async {
                        
                        self.collectionView.reloadData()
                        self.collectionView.isUserInteractionEnabled = true
                        self.setTempDisplayFromCommand()
                        self.setSliderStatus()
                        self.slider.isUserInteractionEnabled = true
                        ProgressHUD.dismiss()

                    }
                    if let data = result?.data{
                        let resStr = vc.data2hexString(data)
                        print(resStr)
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } // global queue
        

        
        
    } // func
    
    @IBAction func tempPlusMinus(_ sender: UIButton)
    {
        if sender.tag == 1{
            slider.currentValue = slider.currentValue + (100/16)
            command.setTemp(value: ( Int(slider.currentValue / (100/16)) ) + 16 - 8)

            self.passCommand()
        }else{
            slider.currentValue = slider.currentValue - (100/16)
            command.setTemp(value: ( Int(slider.currentValue / (100/16)) ) + 16 - 8)
            
            self.passCommand()
        }
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParamCell", for: indexPath) as! ACParamCollectionViewCell
            
            cell.delegate = self
            cell.currentMode = command.getMode()
            cell.expanded = expandedRows.contains(indexPath.row)
            return cell
            
        }else if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACFanParamCollectionViewCell", for: indexPath) as! ACFanParamCollectionViewCell
            cell.delegate = self
            cell.fanSpeedValue = command.cmdArray[14 - 1]
            cell.expanded = expandedRows.contains(indexPath.row)
            return cell
        }else if indexPath.row == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACParamFixationCollectionViewCell", for: indexPath) as! ACParamFixationCollectionViewCell
            cell.upAndDownSwing = command.getUpAndDownSwing()
            cell.leftRightFixation = command.cmdArray[12 - 1]
            cell.expanded = expandedRows.contains(indexPath.row)
            cell.delegate = self
            
            return cell
        }else if indexPath.row == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACParamTempUnitCollectionViewCell", for: indexPath) as! ACParamTempUnitCollectionViewCell
            cell.delegate = self
            cell.tempUnit = command.getTempUnit()
            cell.expanded = expandedRows.contains(indexPath.row)
            return cell
        }else if indexPath.row == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACParamDisplayCollectionViewCell", for: indexPath) as! ACParamDisplayCollectionViewCell
            cell.delegate = self
            cell.titleLabel.text = "Display".localiz()
            cell.displayOn = command.getDisplayStatus()
            return cell
        }else if indexPath.row == 5{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACParamLockCollectionViewCell", for: indexPath) as! ACParamLockCollectionViewCell
            cell.delegate = self
            cell.titleLabel.text = "Lock".localiz()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == 6{
            return CGSize(width: collectionView.frame.size.width, height: 20)
        }
        
        if expandedRows.contains(indexPath.row){
            
           return CGSize(width: collectionView.frame.size.width, height: 200)
        }
        
        
        return CGSize(width: collectionView.frame.size.width, height: 100)
        
    }
    
    var expandedRows = [Int]()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row >= 4{
            return
        }
        
        if expandedRows.contains(indexPath.row){
            expandedRows.remove(at: expandedRows.firstIndex(of: indexPath.row)!)
        }else{
           expandedRows.append(indexPath.row)
        }
        
        collectionView.reloadData()
    }
    
    
    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {

    }
    
    func circularSlider(_ slider: MSCircularSlider, startedTrackingWith value: Double) {
        
    }
    
    func circularSlider(_ slider: MSCircularSlider, endedTrackingWith value: Double)
    {
//        print(slider.currentValue)
//        print((Int(slider.currentValue / (100/16))) + 16 )
        
        command.setTemp(value: ( Int(slider.currentValue / (100/16)) ) + 16 - 8)
        //self.tempLabel.text = String( (Int(slider.currentValue / (100/16))) + 16 )
        
        self.passCommand()
    }
    
    func circularSlider(_ slider: MSCircularSlider, directionChangedTo value: MSCircularSliderDirection) {
        
    }
    
    func circularSlider(_ slider: MSCircularSlider, revolutionsChangedTo value: Int)
    {
        
    }

    
    
    
    
}

@objc extension UIViewController {
    
    @objc func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 80))
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
