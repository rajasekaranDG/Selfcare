//
//  ViewEditText.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 25/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewEditText: UIView,UITextFieldDelegate {

    var delegate : AnyObject?
    var currentPage : Int = 0;
    var totalPage : Int = 0;
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""

    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var ViewBox : UIView!
    @IBOutlet weak var TxtMessage : UITextField!
    @IBOutlet weak var buttonPrevious : UIButton!
    @IBOutlet weak var buttonNext : UIButton!
    var button : UIButton!

    func textFieldShouldReturn(_ theTextField: UITextField) -> Bool {
        theTextField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.button.isHidden = true
        self.button.removeFromSuperview()
        self.TxtMessage.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    func keyboardWillShow(note : NSNotification) -> Void{
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.button.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button)
            keyBoardWindow?.bringSubview(toFront: self.button)
            
        })
    }
    func keyboardWillHide(note : NSNotification) -> Void{
        self.button.isHidden = true
        self.button.removeFromSuperview()
    }
    func textFieldDidBeginEditing(_ theTextField: UITextField) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewEditText.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewEditText.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    @IBAction func ReturenKeyBoard(_ sender: Any) {
        self.button.isHidden = true
        self.button.removeFromSuperview()
        self.TxtMessage.resignFirstResponder()
    }
    func setDetail() {
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
        if(self.currentPage == 0){
            self.buttonPrevious.isHidden = true
        }
        else {
            self.buttonPrevious.isHidden = false
        }
        if(self.currentPage == (self.totalPage)) {
            self.buttonNext.setTitle("CONFIRM" as String,for: .normal)
        }
        else {
            self.buttonNext.setTitle("NEXT" as String,for: .normal)
        }
        self.TxtMessage.delegate = self
        self.button = UIButton(type: UIButtonType.custom)
        button.setTitle("Return", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.frame =  CGRect(x: 0, y: 163, width: 106, height: 53)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(ViewEditText.ReturenKeyBoard(_:)), for: .touchUpInside)
    }
    @IBAction func PreviousClick(_ sender : Any) {
        AppDelegate.appDelegate().window?.endEditing(true)
        if(self.delegate is ObesityQuestionViewController) {
            let ObesityQuestionVC : ObesityQuestionViewController = (self.delegate as! ObesityQuestionViewController)
            ObesityQuestionVC.scrollToNextPage(page: self.currentPage-1)
        }
        else if(self.delegate is CardiovascularQuestionViewController) {
            let CardiovascularQuestionVC : CardiovascularQuestionViewController = (self.delegate as! CardiovascularQuestionViewController)
            CardiovascularQuestionVC.scrollToNextPage(page: self.currentPage-1)
        }
        else if(self.delegate is DiabetesQuestionViewController) {
            let DiabetesQuestionVC : DiabetesQuestionViewController = (self.delegate as! DiabetesQuestionViewController)
            DiabetesQuestionVC.scrollToNextPage(page: self.currentPage-1)
        }

    }
    @IBAction func nextClick(_ sender : Any) {
        AppDelegate.appDelegate().window?.endEditing(true)
        if(self.TxtMessage.text?.characters.count == 0){
            let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
            viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
            AppDelegate.appDelegate().window?.addSubview(viewAlert)
            viewAlert.delegate = self
            viewAlert.IndexTag = "101"
            viewAlert.AlertType = "Text"
            viewAlert.isSingle = true
            viewAlert.AlertMessage = NSString(format:"Please enter %@", self.lblTitle.text!)
            viewAlert.UpdateDetailView()
            viewAlert.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                viewAlert.alpha = 1
            }, completion: {(finished: Bool) -> Void in
            })

        }
        else {
            if(self.delegate is ObesityQuestionViewController) {
                let ObesityQuestionVC : ObesityQuestionViewController = (self.delegate as! ObesityQuestionViewController)
                ObesityQuestionVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
                ObesityQuestionVC.scrollToNextPage(page: self.currentPage+1)
            }
            else if(self.delegate is CardiovascularQuestionViewController) {
                let CardiovascularQuestionVC : CardiovascularQuestionViewController = (self.delegate as! CardiovascularQuestionViewController)
                CardiovascularQuestionVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
                CardiovascularQuestionVC.scrollToNextPage(page: self.currentPage+1)
            }
            else if(self.delegate is DiabetesQuestionViewController) {
                let DiabetesQuestionVC : DiabetesQuestionViewController = (self.delegate as! DiabetesQuestionViewController)
                DiabetesQuestionVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
                DiabetesQuestionVC.scrollToNextPage(page: self.currentPage+1)
            }
        }
    }
}
