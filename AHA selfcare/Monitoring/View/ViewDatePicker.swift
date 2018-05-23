//
//  ViewDatePicker.swift
//  Harbour
//
//  Created by SivaChandran on 06/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewDatePicker: UIView {

    var delegate : AnyObject?
    var TitleString : NSString = ""
    var typeString : NSString = ""
    var isEndDate : Bool = false

    @IBOutlet weak var datePicker : UIDatePicker!
    @IBOutlet weak var lblTitle : UILabel!

    @IBAction func ClosePicker(_ sender: Any) {
       
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.setY(self.height())
        }, completion: {(finished: Bool) -> Void in
            
            self.removeFromSuperview()
        })
    }
    func UpdateView() {
        if(self.typeString.isEqual(to: "DOB")){
            datePicker.datePickerMode = .date
        }
        if(self.isEndDate){
            self.datePicker.minimumDate = Date()
        }
        else {
            self.datePicker.maximumDate = Date()
        }
        self.lblTitle.text = self.TitleString as String
    }
    @IBAction func SelectDOBClick(_ sender: Any) {
        if(self.delegate is ViewDOB) {
            let DOBView : ViewDOB = (self.delegate as! ViewDOB)
            DOBView.updateDetail(selectDate: AppManager.sharedInstance.conertDateToString(Date: self.datePicker.date as NSDate, formate: "yyyy-MM-dd HH:mm:ss"))
        }
        else if(self.delegate is SignupViewController){
            let SignupVC : SignupViewController = (self.delegate as! SignupViewController)
            SignupVC.updateDetail(selectDate: AppManager.sharedInstance.conertDateToString(Date: self.datePicker.date as NSDate, formate: "yyyy-MM-dd"))
        }
        else if(self.delegate is EditProfileViewController){
            let EditProfileVC : EditProfileViewController = (self.delegate as! EditProfileViewController)
            EditProfileVC.updateDetail(selectDate: AppManager.sharedInstance.conertDateToString(Date: self.datePicker.date as NSDate, formate: "yyyy-MM-dd"))
        }
        self.CancelPicker("")
    }
    @IBAction func CancelPicker(_ sender: Any) {
      
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.setY(self.height())
        }, completion: {(finished: Bool) -> Void in
            
            self.removeFromSuperview()
        })
    }

    func PickerDetail() {
        self.datePicker.maximumDate = NSDate() as Date
    }
}
