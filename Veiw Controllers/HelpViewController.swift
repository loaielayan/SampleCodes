//
//  HelpViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/19/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var contentView: UIView!{
        didSet{
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.contentView.layer.cornerRadius = 1
        }
    }
    
    @IBOutlet weak var helpLabel: UILabel!
    
    @IBOutlet weak var okButton: RoundedButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tapGesture.delegate = self
        
        okButton.setTitle("Ok".localiz(), for: .normal)
        helpLabel.text = "Help".localiz()
        
    }
    
    
    @IBAction func dismissVC(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == contentView{
            return false
        }else{
            return true
        }
    }
    
    



}
