//
//  ACParamCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/19/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import ProgressHUD

protocol PassCommands {
    func passCommand()
}

class ACParamCollectionViewCell: UICollectionViewCell
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
    
    
    @IBOutlet weak var paramImage: UIImageView!
    @IBOutlet weak var paramLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var coolButton: UIButton!
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var heatButton: UIButton!
    @IBOutlet weak var fanButton: UIButton!
    @IBOutlet weak var dryButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var coolImage: UIImageView!
    @IBOutlet weak var autoImage: UIImageView!
    @IBOutlet weak var heatImage: UIImageView!
    @IBOutlet weak var fanImage: UIImageView!
    @IBOutlet weak var dryImage: UIImageView!
    
    
    var currentMode: String?{
        didSet{
            coolImage.image = UIImage(named: "Asset 30xhdpi")
            autoImage.image = UIImage(named: "Asset 31xhdpi")
            heatImage.image = UIImage(named: "Asset 32xhdpi")
            fanImage.image = UIImage(named: "Asset 33xhdpi")
            dryImage.image = UIImage(named: "Asset 34xhdpi")
            switch self.currentMode {
            case "Auto":
                autoImage.image = UIImage(named: "modeSelectedAuto")
            case "Fan":
                fanImage.image = UIImage(named: "modeSelectedFan")
            case "Heat":
                heatImage.image = UIImage(named: "modeSelectedHeat")
            case "Dry":
                dryImage.image = UIImage(named: "modeSelectedDry")
            case "Cool":
                coolImage.image = UIImage(named: "modeSelectedCool")
            default:
                break
            }
        }
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        coolButton.setTitle("Cool".localiz(), for: .normal)
        autoButton.setTitle("Auto".localiz(), for: .normal)
        heatButton.setTitle("Heat".localiz(), for: .normal)
        fanButton.setTitle("Fan".localiz(), for: .normal)
        dryButton.setTitle("Dry".localiz(), for: .normal)
        titleLabel.text = "Mode".localiz()
        
        if LanguageManager.shared.currentLanguage == .ar{
            arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        
    }
    
    
    @IBAction func setCommand(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
        let command = Command.shared
        switch sender.tag {
        case 1:
            command.setMode(mode: .Cool)
        case 2:
            command.setMode(mode: .Auto)
        case 3:
            command.setMode(mode: .Heat)
        case 4:
            command.setMode(mode: .Fan)
        case 5:
            command.setMode(mode: .Dry)
        default:
            break
        }
        
        delegate?.passCommand()
        
        
    }
    
    
    
}
