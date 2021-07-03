//
//  ACCollectionViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/18/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ACCollectionViewCell: UICollectionViewCell
{
    
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
    
    
    
}
