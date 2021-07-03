//
//  ACListViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 8/28/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit


@objc class ACListViewController: UIViewController, UINavigationControllerDelegate
{

    @IBAction func backArrow(_ sender: UIButton)
    {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
//    @objc func setPStyle(for vc: SideMenuNavigationController)
//    {
//        vc.presentationStyle = .menuSlideIn
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.identifier == "ShowSideMenu"
//        {
//            let dvc = segue.destination as! SideMenuNavigationController
//            dvc.delegate = self
//            dvc.presentationStyle = .menuSlideIn
//
//
//        }
//    }

}

extension ACListViewController: UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AC-CELL") as! ACTableViewCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 215
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ACDetail", sender: self)
    }

}

//extension ACListViewController: SideMenuNavigationControllerDelegate {
//    
//
//    
//    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
//        
//        view.alpha = 0.5
//
//    }
//    
//    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
//
//    }
//    
//    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
//        
//        view.alpha = 1
//    }
//    
//    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
//        
//        
//    }
//}
