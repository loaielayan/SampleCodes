//
//  SupportViewController.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/19/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import MessageUI
import LanguageManager_iOS

class SupportViewController: UIViewController, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var issueDescriptionTextField: UITextField!
    @IBOutlet weak var issueDetailsTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var issueDescriptionLabel: UILabel!
    @IBOutlet weak var issueDetailsLabel: UILabel!
    
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    
    
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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var contentView: UIView!{
        didSet{
            self.contentView.layer.borderWidth = 0.5
            self.contentView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.contentView.layer.cornerRadius = 10
        }
    }

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameLabel.text = "Name".localiz() + "*"
        phoneLabel.text = "Phone".localiz() + "*"
        issueDescriptionLabel.text = "Issue Description".localiz() + "*"
        issueDetailsLabel.text = "Issue Details".localiz() + "*"
        nextButton.setTitle("Submit".localiz(), for: .normal)
        cancelButton.setTitle("Cancel".localiz(), for: .normal)
        
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        issueDescriptionTextField.delegate = self
        issueDetailsTextField.delegate = self
        
        if LanguageManager.shared.currentLanguage == .en{
            navigationItem.title = "Support"
        }else{
            navigationItem.title = "الدعم"
        }
        
        nameTextField.becomeFirstResponder()
        
    }
    

    @IBAction func dismissVC(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any)
    {
        if nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || issueDescriptionTextField.text!.isEmpty || issueDetailsTextField.text!.isEmpty{
            return
        }

        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let alert = UIAlertController(title: "", message: "There is no default email address defined on this mobile device. Please manually email your request to: info@sadaalmaarfa.com".localiz(), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK".localiz(), style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["info@sadaalmaarfa.com"])
        composeVC.setSubject("Support Request")
        composeVC.setMessageBody("Name: \(nameTextField.text!)\n Phone: \(phoneTextField.text!)\n Issue Description: \(issueDescriptionTextField.text!)\n Issue Details: \(issueDetailsTextField.text!)", isHTML: false);
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if touch.view == contentView{
            return false
        }else{
            return true
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.cornerRadius = 5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportFormTableViewCell") as! SupportFormTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
        
    }
    


    
    
}
