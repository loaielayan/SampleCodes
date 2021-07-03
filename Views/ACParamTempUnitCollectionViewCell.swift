//
//  ACParamTempUnitCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/23/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ACParamTempUnitCollectionViewCell: UICollectionViewCell
{
    var expanded = false{
        didSet{
            if self.expanded{
                self.arrowImage.image = UIImage(named: "arrowDown50x50")
            }else{
                self.arrowImage.image = UIImage(named: "arrowRight50x50")
                
            }
        }
    }

    
    var delegate: PassCommands?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var fButton: UIButton!
    
    
    var tempUnit: Command.TempUnit = .Celsius{
        didSet{
            cButton.setImage(UIImage(named: "celesus"), for: .normal)
            fButton.setImage(UIImage(named: "fahrenhit"), for: .normal)
            
            if self.tempUnit == .Celsius{
                cButton.setImage(UIImage(named: "celsusSelected"), for: .normal)
            }else if self.tempUnit == .Fahrenheit{
                fButton.setImage(UIImage(named: "fahrenhetSelected"), for: .normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "Temp Unit".localiz()
        
        if LanguageManager.shared.currentLanguage == .ar{
            arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @IBAction func changeTempUnit(_ sender: UIButton)
    {
        let command = Command.shared
        if sender.tag == 101{
           command.tempUnit = .Celsius
        }else if sender.tag == 102{
            command.tempUnit = .Fahrenheit
        }
        
        delegate?.passCommand()
    }
    
    
}
