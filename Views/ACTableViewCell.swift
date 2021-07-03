//
//  ACTableViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/28/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import ProgressHUD
import BLLetCore

@objc class ACTableViewCell: UITableViewCell
{
    var delegate: ACDevicesViewController?
    var index: Int?

    
    @objc func set(index: Int, delegate: ACDevicesViewController){
        self.index = index
        self.delegate = delegate
    }

    @IBOutlet weak var backgroundImage: UIImageView!{
        didSet{
            if LanguageManager.shared.currentLanguage == .ar{
                self.backgroundImage.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
    @IBOutlet weak var switchImage: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempUnitLabel: UILabel!
    @IBOutlet weak var tempDegreeContentView: UIView!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        tempDegreeContentView.semanticContentAttribute = .forceLeftToRight
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func turnOnAction(_ sender: UIButton)
    {
      delegate?.turn(onTheAC: index!)
    }
    


}
