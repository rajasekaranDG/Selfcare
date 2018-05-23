//
//  ForgotPasswordViewController.swift
//  AHA selfcare
//
//  Created by Sivachandran on 26/03/18.
//  Copyright © 2018 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    var delegate : AnyObject?

    @IBOutlet weak var scrollViewMain : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var textUserName : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textEmailId : RPFloatingPlaceholderTextField!
    @IBOutlet weak var myTxtFldPhonenumber: RPFloatingPlaceholderTextField!
    @IBOutlet weak var lblLineUsername : UILabel!
    @IBOutlet weak var lblLineEmail : UILabel!
    @IBOutlet weak var lblErrorUsername : UILabel!
    @IBOutlet weak var lblErrorEmail : UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func BackClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        self.lblLineUsername.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineEmail.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblErrorUsername.isHidden = true
        self.lblErrorEmail.isHidden = true
        
        self.textUserName.delegate = self
        self.textUserName.placeholder = "User name"
        self.textUserName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textUserName.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textEmailId.delegate = self
        self.textEmailId.placeholder = "Email"
        self.textEmailId.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textEmailId.floatingLabelInactiveTextColor = UIColor.gray
        
        self.myTxtFldPhonenumber.delegate = self
        self.myTxtFldPhonenumber.placeholder = "Phone number"
        self.myTxtFldPhonenumber.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.myTxtFldPhonenumber.floatingLabelInactiveTextColor = UIColor.gray
        
        self.scrollViewMain.contentSizeToFit()

    }
    @IBAction func forgotPasswordClick (_ sender: Any){
        
        self.lblLineUsername.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineEmail.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblErrorUsername.isHidden = true
        self.lblErrorEmail.isHidden = true
        
        if((self.isEmptyTextField(self.textUserName.text!)) && (self.isEmptyTextField(self.textEmailId.text!))){
            self.lblLineUsername.backgroundColor = UIColor.red
            self.lblLineEmail.backgroundColor = UIColor.red
            self.lblErrorUsername.isHidden = false
            self.lblErrorEmail.isHidden = false
            return
        }
        else if self.isEmptyTextField(self.textUserName.text!) {
            self.lblLineUsername.backgroundColor = UIColor.red
            self.lblErrorUsername.isHidden = false
            return
        }
        else if self.isEmptyTextField(self.textEmailId.text!) {
            self.lblLineEmail.backgroundColor = UIColor.red
            self.lblErrorEmail.isHidden = false
            return
        }
        else {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let stringMessage : String = String(format : "Username : %@ \n Email : %@ \n Phone number : %@",self.textUserName.text!,self.textEmailId.text!,self.myTxtFldPhonenumber.text!)
        mailComposerVC.setToRecipients(["password.support@ahahealth.io"])
        mailComposerVC.setSubject("Forgot Password")
        mailComposerVC.setMessageBody(stringMessage, isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.BackClick("")
    }
    func isEmptyTextField(_ txt: String) -> Bool {
        return ((txt == "") || (txt.count ) == 0)
    }
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}