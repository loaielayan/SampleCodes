//
//  NavigationItemViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/6/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit

@objc class NavigationItemViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpHeaderView()

    }
    
    @objc func back()
    {
       navigationController?.popViewController(animated: true)
        
    }
    
    func setUpHeaderView()
    {
        let headerView = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let size = view.frame.size
        headerView.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let headerViewSize = headerView.frame.size
        let backArrrowImageView = UIImageView(frame: CGRect(x: 20, y: headerViewSize.height / 2, width: 35, height: 35))
        backArrrowImageView.image = UIImage(named: "back")
        let button = UIButton(frame: CGRect(x: 20, y: headerViewSize.height / 2, width: 35, height: 35))
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let logoImageView = UIImageView(frame: CGRect(x: headerViewSize.width / 2 - 60, y: headerViewSize.height / 2 - 20 , width: 120, height: 70))
        logoImageView.image = UIImage(named: "Asset 1mdpi")
        headerView.addSubview(logoImageView)
        headerView.addSubview(backArrrowImageView)
        headerView.addSubview(button)
        view.addSubview(headerView)
    }
    
//    func setUpContentView()
//    {
//        let size = view.frame.size
//        let contentView = UIView(frame: CGRect(origin: CGPoint(x: 20, y: 100), size: CGSize(width: size.width - 40, height: size.height - 100 - 10)))
//        contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.6941176471, blue: 0.7215686275, alpha: 1)
//        contentView.layer.cornerRadius = 30
//        view.addSubview(contentView)
//
//    }



}
