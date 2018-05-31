//
//  ProfileViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 11/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var delegate : AnyObject?
    var mainViewController: UIViewController!

    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var labelUserName : UILabel!
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var labelMobile : UILabel!
    @IBOutlet weak var labelEmail : UILabel!
    @IBOutlet weak var labelGender : UILabel!
    @IBOutlet weak var labelDOB : UILabel!
    @IBOutlet weak var labelHeight : UILabel!
    @IBOutlet weak var labelWeight : UILabel!
    @IBOutlet weak var labelId : UILabel!
    @IBOutlet weak var labelCity : UILabel!
    @IBOutlet weak var labelState : UILabel!
    @IBOutlet weak var labelCountry : UILabel!
    @IBOutlet weak var labelPincode : UILabel!
    @IBOutlet weak var viewInfo : UIView!
    @IBOutlet weak var viewPlace : UIView!
    @IBOutlet weak var viewChangePassword : UIView!
    @IBOutlet weak var viewProfile : UIView!

    @IBOutlet weak var myViewChangeCountry: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        let PageHeight : CGFloat = (iPhone6Pluse) ? 750 : (iPhone6) ? 690 : 690
        self.scrollMain.contentSize = CGSize(width: PageWidth, height: PageHeight)

        AppManager.sharedInstance.viewShadow(MainView: self.viewInfo)
        AppManager.sharedInstance.viewShadow(MainView: self.viewPlace)
        AppManager.sharedInstance.viewShadow(MainView: self.viewChangePassword)
        AppManager.sharedInstance.viewShadow(MainView: self.viewProfile)
        AppManager.sharedInstance.viewShadow(MainView: self.myViewChangeCountry)
        
        self.updateInformation()
    }
    func updateInformation() {
        self.labelUserName.text = AppManager.sharedInstance.userName()
        self.labelName.text = String(format: "%@ %@",AppManager.sharedInstance.userFirstName(),AppManager.sharedInstance.userLastName())
        self.labelMobile.text = AppManager.sharedInstance.userMobile()
        self.labelEmail.text = AppManager.sharedInstance.userMail()
        self.labelDOB.text = AppManager.sharedInstance.userAge()
        self.labelId.text = AppManager.sharedInstance.userId()
        self.labelGender.text = AppManager.sharedInstance.userGender()
        if(AppManager.sharedInstance.userHeight() == "0"){
            self.labelHeight.text = String(format: "",AppManager.sharedInstance.userHeight())
        }
        else {
            self.labelHeight.text = String(format: "%@ Cm",AppManager.sharedInstance.userHeight())
        }
        if(AppManager.sharedInstance.userWeight() == "0"){
            self.labelWeight.text = String(format: "",AppManager.sharedInstance.userWeight())
        }
        else {
            self.labelWeight.text = String(format: "%@ Kg",AppManager.sharedInstance.userWeight())
        }
        self.labelId.text = AppManager.sharedInstance.userGovtId()
        self.labelCity.text = AppManager.sharedInstance.userCity()
        self.labelState.text = AppManager.sharedInstance.userState()
        self.labelCountry.text = AppManager.sharedInstance.userCountry()
        self.labelPincode.text = AppManager.sharedInstance.userPostalCode()
    }
    @IBAction func editClick(_ sender : Any) {
        
        let editVC : EditProfileViewController = EditProfileViewController(nibName: "EditProfileViewController", bundle : nil)
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    @IBAction func changePasswordClick(_ sender : Any) {
        let changePasswordVC : ChangePasswordViewController = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle : nil)
        changePasswordVC.delegate = self
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @IBAction func myBtnChangeCountryAction(_ sender: Any) {
        
        let aViewController : SelectHomeCountryViewController = SelectHomeCountryViewController(nibName: "SelectHomeCountryViewController", bundle : nil)
        aViewController.isFromProfile = true
        self.navigationController?.pushViewController(aViewController, animated: true)
        
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
