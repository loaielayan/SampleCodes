//
//  ACParamFixationCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/23/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ACParamFixationCollectionViewCell: UICollectionViewCell
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

    @IBOutlet weak var rightLeftTextButton: UIButton!
    @IBOutlet weak var upDownTextButton: UIButton!
    
    var delegate: PassCommands?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    @IBOutlet weak var fixationRightLeft: UIButton!{
        didSet{
            self.fixationRightLeft.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var fixationDown: UIButton!{
        didSet{
            self.fixationDown.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    var upAndDownSwing: Command.UpAndDownSwing = .AutoUpAndDown{
        didSet{
            self.fixationDown.setImage(UIImage(named: "fixation down"), for: .normal)
            if self.upAndDownSwing == .AutoUpAndDown{
               self.fixationDown.setImage(UIImage(named: "upAndDownFixationSelected"), for: .normal)
            }
        }
    }
    var leftRightFixation: Int?{
        didSet{
            self.fixationRightLeft.setImage(UIImage(named: "fixation right"), for: .normal)
            if self.leftRightFixation == 0{
                self.fixationRightLeft.setImage(UIImage(named: "rightAndLeftFixationSelected"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "Fixation".localiz()
        
        rightLeftTextButton.setTitle("Left/Right", for: .normal)
        upDownTextButton.setTitle("Up/Down", for: .normal)
        
        if LanguageManager.shared.currentLanguage == .ar{
            arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    
    @IBAction func changeFixation(_ sender: UIButton)
    {
        let command = Command.shared
        if sender.tag == 101
        {
            command.leftAndRightSwing = .LeftAndRightSwing
            if self.leftRightFixation == 0{
                command.leftAndRightSwing = .RightWindFixed
            }
            
        }else if sender.tag == 102
        {
            command.upAndDownSwing = .AutoUpAndDown
            if self.upAndDownSwing == .AutoUpAndDown{
                command.upAndDownSwing = .PositionOne
            }
            
        }
        
        delegate?.passCommand()
    }
    
    
}
