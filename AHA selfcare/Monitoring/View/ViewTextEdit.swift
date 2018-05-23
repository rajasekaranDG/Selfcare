//
//  ViewTextEdit.swift
//  Harbour
//
//  Created by SivaChandran on 05/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewTextEdit: UIView,UITextFieldDelegate {

    var delegate : AnyObject?
    
    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var ViewBox : UIView!
    @IBOutlet weak var TxtMessage : UITextField!
    var Id : NSString = ""
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""

    func updateView() {
        if(self.alertString.isEqual(to: "Y")){
            let style: [AnyHashable: Any]? = ["body": UIFont(name: kFontSanFranciscoSemibold, size: 22)!, "info": WPAttributedStyleAction.styledAction(action: {() -> Void in
                print("Help action")
            }), "link": UIColor.orange]
            
            let action: NSString = "<info>?</info>"
            let message: NSString = "\(self.titleString)  \(action)" as NSString
            self.lblTitle.attributedText = message.attributedString(withStyleBook: style)
        }
        else {
            self.lblTitle.text = self.titleString as String
        }
        self.TxtMessage.delegate = self
    }
    func textFieldShouldReturn(_ theTextField: UITextField) -> Bool {
        theTextField.resignFirstResponder()
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Prevent crashing undo bug – see note below.
        if range.length + range.location > (textField.text?.characters.count)! {
            return false
        }
        var Message : NSString = ""
        let newLength: Int = (textField.text?.characters.count)! + string.characters.count - range.length
        if (newLength == 1) && (newLength < (self.TxtMessage.text?.characters.count)!) {
            Message = HelpAppManager.shared().subStringMessage(self.TxtMessage.text!) as NSString
        }
        else if(newLength > 0){
            Message = String(format: "%@%@",self.TxtMessage.text!,string) as NSString
        }
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: Message as String)
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
        }
    }
}
