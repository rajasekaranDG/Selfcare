//
//  ViewAlertMessage.swift
//  PartnerApp
//
//  Created by SivaChandran on 09/09/16.
//  Copyright © 2016 Sivachandiran. All rights reserved.
//

import UIKit

class ViewAlertMessage: UIView {

    var delegate : AnyObject?

    @IBOutlet weak var viewText : UIView!
    @IBOutlet weak var viewSingle : UIView!
    @IBOutlet weak var BtnCanel : UIButton!
    @IBOutlet weak var BtnOk : UIButton!
    @IBOutlet weak var lblTextMessage : UILabel!

    @IBOutlet weak var viewImage : UIView!
    @IBOutlet weak var BtnCanel2 : UIButton!
    @IBOutlet weak var BtnOk2 : UIButton!
    @IBOutlet weak var lblTextMessage2 : UILabel!
    @IBOutlet weak var ImageIcon : UIImageView!

    var AlertType : NSString = ""
    var AlertMessage : NSString = ""
    var AlertImage : NSString = ""
    var IndexTag : NSString = ""
    var isSingle : Bool!

    func UpdateDetailView () {
        
        if(AlertType.isEqual("Image")){
            self.lblTextMessage2.text = AlertMessage as String
            self.ImageIcon.image = UIImage(named: AlertImage as String)
        }
        else {
            if(self.isSingle == true){
                self.viewSingle.isHidden = false
            }
            else {
                self.viewSingle.isHidden = true
            }
            self.lblTextMessage.text = AlertMessage as String
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.viewText.setY((self.height()-120)/2)
                }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    @IBAction func OkClick(_ sender: Any) {
        if self.delegate is ViewAddDataPage {
            let viewAddDataPage : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            viewAddDataPage.dataAddedSuccessfully()
        }
        else if self.delegate is MonitoringParametersViewController {
            let MonitoringParametersVC : MonitoringParametersViewController = (self.delegate as! MonitoringParametersViewController)
            MonitoringParametersVC.updateSuccessfully()
        }
        else if self.delegate is ObesityQuestionViewController {
            let ObesityQuestionVC : ObesityQuestionViewController = (self.delegate as! ObesityQuestionViewController)
            ObesityQuestionVC.resultClick()
        }
        else if self.delegate is CardiovascularQuestionViewController {
            let CardiovascularQuestionVC : CardiovascularQuestionViewController = (self.delegate as! CardiovascularQuestionViewController)
            CardiovascularQuestionVC.resultClick()
        }
        else if self.delegate is DiabetesQuestionViewController {
            let DiabetesQuestionVC : DiabetesQuestionViewController = (self.delegate as! DiabetesQuestionViewController)
            DiabetesQuestionVC.resultClick()
        }
        if self.delegate is ViewSelectAnswers {
            let viewSelectAnswers : ViewSelectAnswers = (self.delegate as! ViewSelectAnswers)
            viewSelectAnswers.closeClick()
        }
        if self.delegate is EditProfileViewController {
            let editVC : EditProfileViewController = (self.delegate as! EditProfileViewController)
            editVC.closeView()
        }
        if self.delegate is ChangePasswordViewController {
            let ChangePasswordVC : ChangePasswordViewController = (self.delegate as! ChangePasswordViewController)
            ChangePasswordVC.closeView()
        }
        if self.delegate is SignupViewController {
            let SignupVC : SignupViewController = (self.delegate as! SignupViewController)
            SignupVC.gobackLoginPage()
        }
        self.AlertCancelClick(sender: "" as AnyObject)
    }
    @IBAction func AlertCancelClick (_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.viewText.setY(1000)
            }, completion: {(finished: Bool) -> Void in
                self.removeFromSuperview()
        })
    }
}
