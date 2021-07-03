//
//  RoundedButton.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/28/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton
{


    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor(red: 168/255, green: 192/255, blue: 41/255, alpha: 1)

    }
    
}

extension UIButton {
    
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: self.frame.size.width - borderWidth,y: 0, width:borderWidth, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
