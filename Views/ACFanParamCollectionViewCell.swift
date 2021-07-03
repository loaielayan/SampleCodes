//
//  ACFanParamCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/23/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ACFanParamCollectionViewCell: UICollectionViewCell
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
    
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var fanSpeedValue: Int?{
        didSet{
            lowButton.setImage(UIImage(named: "fan low"), for: .normal)
            midButton.setImage(UIImage(named: "fan mid"), for: .normal)
            highButton.setImage(UIImage(named: "fan high"), for: .normal)
            
            switch self.fanSpeedValue {
            case 96:
                lowButton.setImage(UIImage(named: "fanSpeedLow"), for: .normal)
            case 64:
                midButton.setImage(UIImage(named: "fanSpeedMid"), for: .normal)
            case 32:
                highButton.setImage(UIImage(named: "fanSpeedHigh"), for: .normal)
            default:
                break
            }
            
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        lowButton.setTitle("Low".localiz(), for: .normal)
        midButton.setTitle("Mid".localiz(), for: .normal)
        highButton.setTitle("High".localiz(), for: .normal)
        titleLabel.text = "Fan Speed".localiz()
        
        if LanguageManager.shared.currentLanguage == .ar
        {
            arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
    }
    
    @IBAction func changeFanSpeed(_ sender: UIButton)
    {
        let command = Command.shared
        
        if sender.tag == 101{
           command.setWindSpeed(speed: .Low)
        }else if sender.tag == 102{
            command.setWindSpeed(speed: .Mid)
        }else if sender.tag == 103{
           command.setWindSpeed(speed: .High)
        }
        
        delegate?.passCommand()
    }
    
    
}
