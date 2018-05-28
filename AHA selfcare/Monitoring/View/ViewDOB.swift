//
//  ViewDOB.swift
//  Harbour
//
//  Created by SivaChandran on 05/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewDOB: UIView {

    var delegate : AnyObject?

    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var ViewBox : UIView!
    @IBOutlet weak var lblDOB : UILabel!
    @IBOutlet weak var BtnSelectDOB : UIButton!
    var MessageString : NSString = ""
    var TitleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""

    func setView() {
        if(self.alertString.isEqual(to: "Y")){
            let style: [AnyHashable: Any]? = ["body": UIFont(name: kFontSanFranciscoSemibold, size: 22)!, "info": WPAttributedStyleAction.styledAction(action: {() -> Void in
                print("Help action")
            }), "link": UIColor(red: 42.0/255.0, green: 185.0/255.0, blue: 181.0/255.0, alpha: 1.000)]
            
            let action: NSString = "<info>?</info>"
            let message: NSString = "\(self.TitleString)  \(action)" as NSString
            self.lblTitle.attributedText = message.attributedString(withStyleBook: style)
        }
        else {
            self.lblTitle.text = self.TitleString as String
        }
        self.lblDOB.text = AppManager.sharedInstance.conertDateToString(Date: Date() as NSDate, formate: "yyyy-MM-dd hh:mm") //:ss
        self.lblDOB.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.lblDOB.text!)
        }
    }
    @IBAction func SelectDateOfBirth(_ sender: Any) {
        
        AppDelegate.appDelegate().window?.endEditing(true)
        let viewDatePicker: ViewDatePicker = (Bundle .main.loadNibNamed("ViewDatePicker", owner: self, options: nil)![0] as! ViewDatePicker)
        viewDatePicker.delegate = self
        if(self.TitleString.isEqual(to: "Sport End Time*")){
            viewDatePicker.isEndDate = true
        }
        viewDatePicker.TitleString = self.lblTitle.text! as NSString
        viewDatePicker.frame = CGRect(x: 0, y: (self.window?.height())!, width: (self.window?.width())!, height: (self.window?.height())!)
        self.window? .addSubview(viewDatePicker)
        viewDatePicker.UpdateView()
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            viewDatePicker.setY(0)
        }, completion: {(finished: Bool) -> Void in
            
        })
    }
    func updateDetail(selectDate : String) {
        self.lblDOB.text = selectDate
        self.lblDOB.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.lblDOB.text!)
        }
    }
}
