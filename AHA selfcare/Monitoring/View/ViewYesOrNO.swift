//
//  ViewYesOrNO.swift
//  Harbour
//
//  Created by SivaChandran on 22/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewYesOrNO: UIView {

    var delegate : AnyObject?
    
    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var BtnYes : UIButton!
    @IBOutlet weak var BtnNo : UIButton!
    @IBOutlet weak var ViewEmpty : UIView!
    @IBOutlet weak var ViewBox : UIView!

    var MessageString : NSString = ""
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""

    func setView() {
        if(self.alertString.isEqual(to: "Y")){
            let style: [AnyHashable: Any]? = ["body": UIFont(name: kFontSanFranciscoSemibold, size: 22)!, "info": WPAttributedStyleAction.styledAction(action: {() -> Void in
                print("Help action")
            }), "link": UIColor(red: 42.0/255.0, green: 185.0/255.0, blue: 181.0/255.0, alpha: 1.000)]
            
            let action: NSString = "<info>?</info>"
            let message: NSString = "\(self.titleString)  \(action)" as NSString
            self.lblTitle.attributedText = message.attributedString(withStyleBook: style)
        }
        else {
            self.lblTitle.text = self.titleString as String
        }
    }
    func UpdateView(Height:CGFloat) -> CGFloat  {
        
        let ViewHeight : CGFloat = Height
        
        self.BtnNo.layer.cornerRadius = 6.0
        self.BtnNo.layer.borderWidth = 1;
        self.BtnNo.layer.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.000).cgColor

        self.BtnYes.layer.cornerRadius = 6.0
        self.BtnYes.layer.borderWidth = 1;
        self.BtnYes.layer.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.000).cgColor

        self.ChangeButtonColor()
        return ViewHeight
    }
    @IBAction func SelectYes(_ sender: UIButton) {
        self.UpdateYES()
        self.ChangeButtonColor()
    }
    @IBAction func SelectNo(_ sender: UIButton) {
        self.UpdateNO()
        self.ChangeButtonColor()
    }
    func ChangeButtonColor() {
        if(self.MessageString.isEqual(to: "Yes")){
            self.BtnYes.layer.borderWidth = 1;
            self.BtnYes.layer.borderColor = UIColor.clear.cgColor
            self.BtnNo.layer.borderWidth = 1;
            self.BtnNo.layer.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.000).cgColor
            
            self.BtnNo.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.000)
            self.BtnYes.backgroundColor = UIColor(red: 58.0/255.0, green: 187.0/255.0, blue: 255.0/255.0, alpha: 1.000)
            self.BtnYes.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.BtnNo.setTitleColor(UIColor(red: 88.0/255.0, green: 88.0/255.0, blue: 88.0/255.0, alpha: 1.000), for: UIControlState.normal)
        }
        else if (self.MessageString.isEqual(to: "No")) {
            self.BtnYes.layer.borderWidth = 1;
            self.BtnYes.layer.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.000).cgColor
            self.BtnNo.layer.borderWidth = 1;
            self.BtnNo.layer.borderColor = UIColor.clear.cgColor
            
            self.BtnYes.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.000)
            self.BtnNo.backgroundColor = UIColor(red: 58.0/255.0, green: 187.0/255.0, blue: 255.0/255.0, alpha: 1.000)
            self.BtnNo.titleLabel?.textColor =  UIColor.white
            self.BtnNo.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.BtnYes.setTitleColor(UIColor(red: 88.0/255.0, green: 88.0/255.0, blue: 88.0/255.0, alpha: 1.000), for: UIControlState.normal)
        }
    }
    func UpdateYES() {
        self.MessageString = "Yes"
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.MessageString as String)
        }
    }
    func UpdateNO() {
        self.MessageString = "No"
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.MessageString as String)
        }
    }
}
