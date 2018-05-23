//
//  ViewDialogSingle.swift
//  Harbour
//
//  Created by SivaChandran on 21/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewDialogSingle: UIView {

    var delegate : AnyObject?
    
    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var ViewBox : UIView!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var BtnSelect : UIButton!
    @IBOutlet weak var ViewEmpty : UIView!

    var arrayOfItems : NSMutableArray = []
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""
    var answerString : NSString = ""

    func UpdateDialogSignle() {
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
        if(self.answerString.isEqual(to: "")){
            self.lblMessage.textColor = UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.000)
            self.lblMessage.text = "Select"
        }
        else {
            self.lblMessage.text = self.answerString as String
            self.lblMessage.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        }
        
    }
    @IBAction func SelectDialogSingle(_ sender: Any) {
        AppDelegate.appDelegate().window?.endEditing(true)
        let viewPopup: ViewPopupList = (Bundle .main.loadNibNamed("ViewPopupList", owner: self, options: nil)![0] as! ViewPopupList)
        viewPopup.frame = CGRect(x: 0, y: 0, width: (self.window?.width())!, height: (self.window?.height())!)
        self.window? .addSubview(viewPopup)
        viewPopup.delegate = self
        viewPopup.lblTitle.text = self.lblTitle.text!
        viewPopup.arrayOfItems = self.arrayOfItems
        viewPopup.UpdateDetailView()
        viewPopup.alpha = 0.0
        
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            viewPopup.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
        })
    }
    func updateAnswer(Tag : Int, answer : String) {
        self.lblMessage.text = answer
        self.lblMessage.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        if(self.delegate is ViewAddDataPage) {
            if(self.lblMessage.text! == "mmol/L"){
                let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
                AddDataView.updateAnswer(Tag: self.tag, answer: "mmol/L")
            }
            else if(self.lblMessage.text! == "mg/dL"){
                let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
                AddDataView.updateAnswer(Tag: self.tag, answer: "mg/dL")
            }
            else {
                let answerString : NSString = self.lblMessage.text! as NSString
                let newString = answerString.replacingOccurrences(of: " ago", with: "")
                let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
                AddDataView.updateAnswer(Tag: self.tag, answer: newString)
            }
        }
    }
}
