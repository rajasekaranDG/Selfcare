//
//  ViewAge.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 27/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewAge: UIView{

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
    
    func textFieldShouldReturn(_ theTextField: UITextField) -> Bool {
        theTextField.resignFirstResponder()
        return false
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
        self.TxtMessage.text = AppManager.sharedInstance.userAge() 
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
