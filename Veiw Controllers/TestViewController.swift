//
//  TestViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/19/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var stackView: CustomStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view2.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        stackView.views = [view1, view2]

    }
    


}
