//
//  AddDeviceInstructionsViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/6/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import BLLetCore
import LanguageManager_iOS

class AddDeviceInstructionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBAction func revealMenu(_ sender: UIBarButtonItem)
    {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! SideMenuNavigationController
        if LanguageManager.shared.currentLanguage == .ar{
            menu.leftSide = false
        }else{
            menu.leftSide = true
        }
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.backgroundColor = UIColor.clear
        self.present(menu, animated: true, completion: nil)
        
    }
    

    
    
    @IBOutlet weak var textTableView: UITableView!
    
    @objc @IBAction func backArrow(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backToDeviceListPage(){
        let deviceList = storyboard?.instantiateViewController(withIdentifier: "HomeNavigation")
        self.present(deviceList!, animated: true, completion: nil)
    }
    
    @IBOutlet weak var arrowImage: UIImageView!{
        didSet{
            if LanguageManager.shared.currentLanguage == .ar{
                self.arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
    
    @IBOutlet weak var arrowImage2: UIImageView!{
        didSet{
            if LanguageManager.shared.currentLanguage == .ar{
                self.arrowImage2.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            if LanguageManager.shared.currentLanguage == .en{
               self.backButton.setTitle("Back", for: .normal)
            }else{
               self.backButton.setTitle("السابق", for: .normal)
            }
            
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            if LanguageManager.shared.currentLanguage == .en{
              self.nextButton.setTitle("Next", for: .normal)
            }else{
                self.nextButton.setTitle("التالي", for: .normal)
            }
            
        }
    }
    
    
    
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            //contentView.layer.cornerRadius = 30
        }
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (self.navigationController?.viewControllers.count)! <= 1{
//            self.backButton.isHidden = true
//            self.arrowImage2.isHidden = true
            backButton.addTarget(self, action: #selector(backToDeviceListPage), for: .touchUpInside)
        
        }else{
            backButton.addTarget(self, action: #selector(backArrow(_:)), for: .touchUpInside)
        }
        
        
        textTableView.delegate = self
        textTableView.dataSource = self
        
        
        
        
        if LanguageManager.shared.currentLanguage == .ar
        {
            navigationItem.title = "إضافة جهاز"
        }else{
          navigationItem.title = "Add Device"
        }

    }
    

    

    
//    func setUpHeaderView()
//    {
//        let headerView = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        let size = view.frame.size
//        headerView.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
//        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
//        headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        let headerViewSize = headerView.frame.size
//        let backArrrowImageView = UIImageView(frame: CGRect(x: 20, y: headerViewSize.height / 2, width: 35, height: 35))
//        backArrrowImageView.image = UIImage(named: "back")
//        let button = UIButton(frame: CGRect(x: 20, y: headerViewSize.height / 2, width: 35, height: 35))
//        button.addTarget(self, action: #selector(back), for: .touchUpInside)
//        let logoImageView = UIImageView(frame: CGRect(x: headerViewSize.width / 2 - 60, y: headerViewSize.height / 2 - 20 , width: 120, height: 70))
//        logoImageView.image = UIImage(named: "Asset 1mdpi")
//        headerView.addSubview(logoImageView)
//        headerView.addSubview(backArrrowImageView)
//        headerView.addSubview(button)
//        view.addSubview(headerView)
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionTextCell", for: indexPath) as! InstructionsTextTableViewCell
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 1250
        }
        return 1200
    }

}
