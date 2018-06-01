//
//  ViewSelectAnswers.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 25/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewSelectAnswers: UIView {

    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var scrollAnswer : UIScrollView!
    @IBOutlet weak var viewMain : UIView!
    @IBOutlet weak var buttonPrevious : UIButton!
    @IBOutlet weak var buttonNext : UIButton!

    var delegate : AnyObject?
    var arrayOfItems : NSMutableArray = []
    var currentPage : Int = 0;
    var totalPage : Int = 0;
    var typeString : NSString = ""
    var isDiabetes : Bool = false
    var nextButtonflag : NSString = ""
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""
    var isCardiovascular : Bool = false
    var isRemove : Bool = false

    func closeClick() {
        if self.delegate is DiabetesQuestionViewController {
            let DiabetesQVC : DiabetesQuestionViewController = (self.delegate as! DiabetesQuestionViewController)
            DiabetesQVC.closeClick()
        }
    }
    func setDetail() {
        if(self.alertString.isEqual(to: "Y")){
            if(self.titleString.isEqual(to: "LVH")) {
                let style: [AnyHashable: Any]? = ["body":UIFont(name: kFontSanFranciscoSemibold, size: CGFloat(17.0))!,
                                                  "Alert": [[NSFontAttributeName: UIFont(name: kFontSanFrancisco, size: CGFloat(15.0)), NSForegroundColorAttributeName: UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.000)]],
                                                  "info": WPAttributedStyleAction.styledAction(action: {() -> Void in
                                                    let viewInfoMessage : ViewInfoMessage = (Bundle .main.loadNibNamed("ViewInfoMessage", owner: self, options: nil)![0] as! ViewInfoMessage)
                                                    viewInfoMessage.frame = (AppDelegate.appDelegate().window?.bounds)!
                                                    viewInfoMessage.delegate = self
                                                    viewInfoMessage.messageString = self.alertMessageString
                                                    AppDelegate.appDelegate().window?.addSubview(viewInfoMessage)
                                                    viewInfoMessage.updateView()
                                                  }), "link": UIColor(red: 42.0/255.0, green: 185.0/255.0, blue: 181.0/255.0, alpha: 1.000)]
                let action: NSString = "<info>?  </info>"
                let alert: NSString = "<Alert>Left ventricular hypertrophy</Alert>"
                let message: NSString = String(format: "%@ \n %@ \n %@",self.titleString,alert,action) as NSString
                self.lblTitle.attributedText = message.attributedString(withStyleBook: style)
            }
            else {
                let style: [AnyHashable: Any]? = ["body": UIFont(name: kFontSanFranciscoSemibold, size: 22)!,
                                                  "info": WPAttributedStyleAction.styledAction(action: {() -> Void in
                                                    print("Help action")
                                                    let viewInfoMessage : ViewInfoMessage = (Bundle .main.loadNibNamed("ViewInfoMessage", owner: self, options: nil)![0] as! ViewInfoMessage)
                                                    viewInfoMessage.frame = (AppDelegate.appDelegate().window?.bounds)!
                                                    viewInfoMessage.delegate = self
                                                    viewInfoMessage.messageString = self.alertMessageString
                                                    AppDelegate.appDelegate().window?.addSubview(viewInfoMessage)
                                                    viewInfoMessage.updateView()
                                                  }),
                                                  "link": UIColor(red: 27.0/255.0, green: 27.0/255.0, blue: 27.0/255.0, alpha: 1.000)]
                
                let action: NSString = "<info>info</info>"
                let message: NSString = "\(self.titleString)?  \(action)" as NSString
                self.lblTitle.attributedText = message.attributedString(withStyleBook: style)
            }
        }
        else {
            self.lblTitle.text = self.titleString as String
        }
        if(self.nextButtonflag.isEqual(to: "N")){
            self.buttonNext.isHidden = true
        }
        else {
            self.buttonNext.isHidden = false
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
        self.setPagesinScroll()
    }
    func setPagesinScroll() {

        let subViews = self.scrollAnswer.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        var yValue : CGFloat = 0

//        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320

        for Index in 0..<self.arrayOfItems.count {
            let detailDic : NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary

            let viewAnswer: ViewAnswers = (Bundle .main.loadNibNamed("ViewAnswers", owner: self, options: nil)![0] as! ViewAnswers)
            viewAnswer.frame = CGRect(x: 0, y: yValue, width: self.scrollAnswer.width(), height: 50)
            let constraintAnswer: CGSize = CGSize(width: 0, height: 2000.0)
            let SizeOfAnswer: CGSize = AppManager.sharedInstance.dynamicHeightCalculation(current_constraint:
                constraintAnswer,descriptions: detailDic["Title"] as! String, fontfamily: UIFont(name: kFontSanFranciscoSemibold, size: 18)!)
            viewAnswer.buttonAnswer.setWidth(SizeOfAnswer.width+20)
            viewAnswer.buttonAnswer.setX(self.scrollAnswer.width() - viewAnswer.buttonAnswer.width())
            viewAnswer.buttonAnswer.tag = Index
            viewAnswer.buttonAnswer.setTitle(detailDic["Title"] as? String,for: .normal)
            viewAnswer.buttonAnswer.addTarget(self, action: #selector(ViewSelectAnswers.selectAnswer(_:)), for: .touchUpInside)
            viewAnswer.buttonAnswer.layer.cornerRadius = 6.0

            let selctedFlag : NSString = detailDic["Selected"] as! NSString
            if(selctedFlag.isEqual(to: "Y")) {
                viewAnswer.buttonAnswer.layer.borderColor = UIColor(red: 30.0/255.0, green: 184.0/255.0, blue: 214.0/255.0, alpha: 1.000).cgColor
                viewAnswer.buttonAnswer.layer.borderWidth = 3.0
            }
            else {
                viewAnswer.buttonAnswer.layer.borderColor = UIColor(red: 30.0/255.0, green: 184.0/255.0, blue: 214.0/255.0, alpha: 1.000).cgColor
                viewAnswer.buttonAnswer.layer.borderWidth = 1.0
            }
            yValue = yValue + 55
            self.scrollAnswer.addSubview(viewAnswer)
        }
        self.scrollAnswer.contentSize = CGSize(width: self.scrollAnswer.width(), height: yValue)
    }
    func selectAnswer(_ sender : UIButton) {
        for Index in 0..<self.arrayOfItems.count {
            let detailDic : NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            detailDic.setObject("N", forKey: "Selected" as NSCopying)
        }
        let detailDictionary : NSMutableDictionary = self.arrayOfItems[sender.tag] as! NSMutableDictionary
        detailDictionary.setObject("Y", forKey: "Selected" as NSCopying)
        let nextflag : NSString = detailDictionary["Answer"] as! NSString
        
        if(self.isDiabetes){
            if(self.tag == 0){
                if(nextflag.isEqual(to: "Yes")){
                    self.buttonNext.isHidden = true
                    let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                    viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
                    AppDelegate.appDelegate().window?.addSubview(viewAlert)
                    viewAlert.delegate = self
                    viewAlert.IndexTag = "101"
                    viewAlert.AlertType = "Text"
                    viewAlert.isSingle = true
                    viewAlert.lblTextMessage.font = UIFont(name: kFontSanFrancisco, size: CGFloat(14.0))
                    viewAlert.AlertMessage = "This assessment is suitable only for people who are not already diagnosed with Type 2 Diabetes. \n Don't worry! You can use AHA to track your Blood Glucose, Weight, BMI and identify health risks.Start Monitoring Now !"
                    viewAlert.UpdateDetailView()
                    viewAlert.alpha = 0
                    
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        viewAlert.alpha = 1
                    }, completion: {(finished: Bool) -> Void in
                    })
                }
                else {
                    self.buttonNext.isHidden = false
                }
            }
        }
        else if(self.isCardiovascular){
            if(self.titleString.isEqual(to: "Smoking Status ?")){
                if(nextflag.isEqual(to: "0")){
                    if self.delegate is CardiovascularQuestionViewController {
                        let CardiovascularVC : CardiovascularQuestionViewController = (self.delegate as! CardiovascularQuestionViewController)
                        CardiovascularVC.removeQuestion()
                        self.isRemove = true
                    }
                }
                else if(nextflag.isEqual(to: "1")){
                    if self.delegate is CardiovascularQuestionViewController {
                        let CardiovascularVC : CardiovascularQuestionViewController = (self.delegate as! CardiovascularQuestionViewController)
                        CardiovascularVC.addQuestion()
                        self.isRemove = false
                    }
                }
            }
        }
        self.setPagesinScroll()
    }
    @IBAction func PreviousClick(_ sender : UIButton) {
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
    @IBAction func nextClick(_ sender : UIButton) {
        AppDelegate.appDelegate().window?.endEditing(true)
        var selectedString : NSString = ""
        for Index in 0..<self.arrayOfItems.count {
            let detailDic : NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            let selctedFlag : NSString = detailDic["Selected"] as! NSString
            if(selctedFlag.isEqual(to: "Y")) {
                selectedString = detailDic["Answer"] as! NSString
            }
        }
        if(self.delegate is ObesityQuestionViewController) {
            let ObesityQuestionVC : ObesityQuestionViewController = (self.delegate as! ObesityQuestionViewController)
            ObesityQuestionVC.updateAnswer(Tag: self.tag, answer: selectedString as String)
            ObesityQuestionVC.scrollToNextPage(page: self.currentPage+1)
        }
        else if(self.delegate is CardiovascularQuestionViewController) {
            let CardiovascularQuestionVC : CardiovascularQuestionViewController = (self.delegate as! CardiovascularQuestionViewController)
            CardiovascularQuestionVC.updateAnswer(Tag: self.tag, answer: selectedString as String)
            CardiovascularQuestionVC.scrollToNextPage(page: self.currentPage+1)
        }
        else if(self.delegate is DiabetesQuestionViewController) {
            let DiabetesQuestionVC : DiabetesQuestionViewController = (self.delegate as! DiabetesQuestionViewController)
            DiabetesQuestionVC.updateAnswer(Tag: self.tag, answer: selectedString as String)
            DiabetesQuestionVC.scrollToNextPage(page: self.currentPage+1)
        }

    }
}
