//
//  RoundedView.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/28/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit

class RoundedView: UIView
{
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.7529411765, blue: 0.1607843137, alpha: 1)
        self.layer.cornerRadius = 30.0
        
        
    }


}
