//
//  ACParamDisplayCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/30/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ACParamDisplayCollectionViewCell: UICollectionViewCell
{


    
    var delegate: PassCommands?
    var displayOn: Bool = false{
        didSet{
           self.switch.setOn(self.displayOn, animated: true)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if LanguageManager.shared.currentLanguage == .ar{
            self.switch.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        //self.switch.setOn(self.displayOn, animated: true)
        
        
        
    }
    
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch)
    {
        let command = Command.shared
        
        
        if sender.isOn{
            command.setDisplay(display: .DisplayOn)
        }else{
            command.setDisplay(display: .DisplayOff)
        }
        
        
        
        delegate?.passCommand()
    }
    
    
}
