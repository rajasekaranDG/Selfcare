//
//  ViewNumber.swift
//  Harbour
//
//  Created by SivaChandran on 23/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewNumber: UIView,UITextFieldDelegate {

    var delegate : AnyObject?
    
    @IBOutlet weak var lblTitle : WPHotspotLabel!
    @IBOutlet weak var ViewBox : UIView!
    @IBOutlet weak var TxtMessage : UITextField!
    var Id : NSString = ""
    var button : UIButton!
    var typeString : NSString = ""
    var titleString : NSString = ""
    var alertString : NSString = ""
    var alertMessageString : NSString = ""

    func UpdateView() {
        self.TxtMessage.isUserInteractionEnabled = true
        
        if(self.alertString.isEqual(to: "Y")){
            let style: [AnyHashable: Any]? = ["body": UIFont(name: kFontSanFranciscoSemibold, size: 22)!, "info": WPAttributedStyleAction.styledAction(action: {() -> Void in
                let viewInfoMessage : ViewInfoMessage = (Bundle .main.loadNibNamed("ViewInfoMessage", owner: self, options: nil)![0] as! ViewInfoMessage)
                viewInfoMessage.frame = (AppDelegate.appDelegate().window?.bounds)!
                viewInfoMessage.delegate = self
                viewInfoMessage.messageString = self.alertMessageString
                AppDelegate.appDelegate().window?.addSubview(viewInfoMessage)
                viewInfoMessage.updateView()
            }), "link": UIColor(red: 42.0/255.0, green: 185.0/255.0, blue: 181.0/255.0, alpha: 1.000)]
            
            let action: NSString = "<info>?</info>"
            let message: NSString = "\(self.titleString)  \(action)" as NSString
            self.lblTitle.attributedText = message.attributedString(withStyleBook: style)
        }
        else {
            self.lblTitle.text = self.titleString as String
        }
        if((self.lblTitle.text == "Height(Cms) ?") || (self.lblTitle.text == "Height(Cms)*")){
            self.TxtMessage.text = AppManager.sharedInstance.userHeight()
            if(self.delegate is ViewAddDataPage) {
                let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
                AddDataView.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
            }
            else if(self.delegate is MonitoringParametersViewController) {
                let MonitoringParametersVC : MonitoringParametersViewController = (self.delegate as! MonitoringParametersViewController)
                MonitoringParametersVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
            }
        }
        else if((self.lblTitle.text == "Weight*") || (self.lblTitle.text == "Weight (KG)")) {
            self.TxtMessage.text = AppManager.sharedInstance.userWeight()
            if(self.delegate is ViewAddDataPage) {
                let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
                AddDataView.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
            }
            else if(self.delegate is MonitoringParametersViewController) {
                let MonitoringParametersVC : MonitoringParametersViewController = (self.delegate as! MonitoringParametersViewController)
                MonitoringParametersVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
            }
        }
        else if(self.lblTitle.text == "BMI"){
            
            self.TxtMessage.isUserInteractionEnabled = false
            let heightstr = AppManager.sharedInstance.userHeight()
            let weightstr = AppManager.sharedInstance.userWeight()

            if((heightstr != "") && (weightstr != "")) {
                let height = CGFloat((heightstr as NSString).floatValue)/100
                
                let weight = CGFloat((weightstr as NSString).floatValue)
                let BMI : CGFloat = (weight/(height*height))
                self.TxtMessage.text = String(format: "%.2f",BMI) as String
                
                if(self.delegate is ViewAddDataPage) {
                    let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
                    AddDataView.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
                }
                else if(self.delegate is MonitoringParametersViewController) {
                    let MonitoringParametersVC : MonitoringParametersViewController = (self.delegate as! MonitoringParametersViewController)
                    MonitoringParametersVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
                }
            }
        }
        self.button = UIButton(type: UIButtonType.custom)
        button.setTitle("", for: UIControlState.normal) //Return
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.frame =  CGRect(x: 0, y: 163, width: 106, height: 0)//53
        button.adjustsImageWhenHighlighted = false
//        button.addTarget(self, action: #selector(ViewNumber.ReturenKeyBoard(_:)), for: .touchUpInside)
        self.TxtMessage.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Prevent crashing undo bug – see note below.
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
       
        
        if range.length + range.location > (textField.text?.count)! {
            return false
        }
        if((typeString.isEqual(to: "systolic")) || (typeString.isEqual(to: "diastolic")) || (typeString.isEqual(to: "heartRate"))) {
            let newLength = textField.text!.count + string.count - range.length
            return (newLength > 3) ? false : true
        }
        else if (typeString.isEqual(to: "bloodGlucoseValue")) {
            let newLength = textField.text!.count + string.count - range.length
            return (newLength > 5) ? false : true
        }
        else if ((typeString.isEqual(to: "wgt")) || (typeString.isEqual(to: "height"))) {
            let newLength = textField.text!.count + string.count - range.length
            return (newLength > 6) ? false : true
        }
        var Message : NSString = ""
        let newLength: Int = (textField.text?.count)! + string.count - range.length
        if (newLength < (self.TxtMessage.text?.count)!) {
            Message = HelpAppManager.shared().subStringMessage(self.TxtMessage.text!) as NSString
        }
        else if(newLength > 0){
            Message = String(format: "%@%@",self.TxtMessage.text!,string) as NSString
        }
        let UserDefaultsDetails = UserDefaults.standard
        if((self.lblTitle.text == "Height(Cms) ?") || (self.lblTitle.text == "Height(Cms)*")){
            UserDefaultsDetails.setValue(Message , forKey: "height")
        }
        else if((self.lblTitle.text == "Weight*") || (self.lblTitle.text == "Weight (KG)")) {
            UserDefaultsDetails.setValue(Message , forKey: "weight")
        }
        UserDefaultsDetails.synchronize()
        
        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: Message as String)
        }
        else if(self.delegate is MonitoringParametersViewController) {
            let MonitoringParametersVC : MonitoringParametersViewController = (self.delegate as! MonitoringParametersViewController)
            MonitoringParametersVC.updateAnswer(Tag: self.tag, answer: Message as String)
        }
//        return true
        let maxLength = 6
        return txtAfterUpdate.count <= maxLength
    }
    @IBAction func ReturenKeyBoard(_ sender: Any) {
        self.button.isHidden = true
        self.button.removeFromSuperview()
        self.TxtMessage.resignFirstResponder()
    }
    func keyboardWillShow(note : NSNotification) -> Void{
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.button.isHidden = true//false
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewNumber.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewNumber.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    func textFieldShouldReturn(_ theTextField: UITextField) -> Bool {
        theTextField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.button.isHidden = true
        self.button.removeFromSuperview()
        self.TxtMessage.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
        
        let UserDefaultsDetails = UserDefaults.standard
        if((self.lblTitle.text == "Height(Cms) ?") || (self.lblTitle.text == "Height(Cms)*")){
            UserDefaultsDetails.setValue(self.TxtMessage.text! , forKey: "height")
        }
        else if((self.lblTitle.text == "Weight*") || (self.lblTitle.text == "Weight (KG)")) {
            UserDefaultsDetails.setValue(self.TxtMessage.text! , forKey: "weight")
        }
        UserDefaultsDetails.synchronize()

        if(self.delegate is ViewAddDataPage) {
            let AddDataView : ViewAddDataPage = (self.delegate as! ViewAddDataPage)
            AddDataView.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
        }
        else if(self.delegate is MonitoringParametersViewController) {
            let MonitoringParametersVC : MonitoringParametersViewController = (self.delegate as! MonitoringParametersViewController)
            MonitoringParametersVC.updateAnswer(Tag: self.tag, answer: self.TxtMessage.text!)
        }
    }
}
