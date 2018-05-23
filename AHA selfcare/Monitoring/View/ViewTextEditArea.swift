//
//  ViewTextEditArea.swift
//  Harbour
//
//  Created by SivaChandran on 05/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewTextEditArea: UIView,UITextViewDelegate {

    var delegate : AnyObject?
    
    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var ViewBox : UIView!
    @IBOutlet weak var TxtMessage : UITextView!
    @IBOutlet weak var lblPlaceHolderText : UILabel!
    
    var Id : NSString = ""
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""

    func UpdateViewDetail() {
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

        self.TxtMessage.delegate = self
        if self.TxtMessage.text.characters.count > 0 {
            self.lblPlaceHolderText.isHidden = true
        }
        else {
            self.lblPlaceHolderText.isHidden = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: textView.text!)
        }
        if textView.text.characters.count > 0 {
            self.lblPlaceHolderText.isHidden = true
        }
        else {
            self.lblPlaceHolderText.isHidden = false
        }
    }
}
