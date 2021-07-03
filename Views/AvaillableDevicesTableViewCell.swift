//
//  AvaillableDevicesTableViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 10/8/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit

protocol AddDevice {
    func addSelectedDevice(device: BLDNADevice)
}

class AvaillableDevicesTableViewCell: UITableViewCell
{
    var delegate : AddDevice?
    
    var device: BLDNADevice?
    
    var rowSelected = false
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var macAddressLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
//    var selectionFromTableView = false{
//        didSet{
//            if self.selectionFromTableView{
//                rowSelected = true
//                self.addDevice(UIButton())
//            }else{
//                rowSelected = false
//                self.addDevice(UIButton())
//            }
//        }
//    }
    
    
    @IBAction func addDevice(_ sender: UIButton)
    {
        if rowSelected{
            addButton.isSelected = false
            self.rowSelected = false
            delegate?.addSelectedDevice(device: self.device!) // will remove device
            return
        }

        self.rowSelected = true

         delegate?.addSelectedDevice(device: self.device!)
        
        if sender.tag != 101{
            addButton.isSelected = rowSelected
        }
 
    }
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
