//
//  ViewAddDataPage.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 14/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewAddDataPage: UIView {

    var delegate : AnyObject?
    var arrayList : NSMutableArray = []
    var currentPage : Int = 0;
    var totalPage : Int = 0;
    var moduleType : String = ""
    var AddeddataArray = [JSON] ()
    var monitoringParameterArray = [JSON] ()

    func updateView() {
        var yValue : CGFloat = 20
        if ((self.tag + 1) <= self.arrayList.count-1) {
            yValue = self.setViewUpdate(value: yValue, typeList: self.arrayList, Tag: self.tag)
            
            yValue = self.setViewUpdate(value: yValue, typeList: self.arrayList, Tag: self.tag + 1)
            self.setButtons(value: yValue)
        }
        else if (self.tag <= self.arrayList.count-1) {
            yValue = self.setViewUpdate(value: yValue, typeList: self.arrayList , Tag: self.tag)
            self.setButtons(value: yValue)
        }
    }
    func setViewUpdate(value : CGFloat, typeList : NSMutableArray, Tag : Int)-> CGFloat {
        var value : CGFloat = value
        
        let detailDic : NSMutableDictionary = typeList[Tag] as! NSMutableDictionary
        let typeString : String = detailDic["Type"] as! String
        let addParams : String = detailDic["addParams"] as! String

        if typeString == "TextEdit"{
            let viewTextEdit: ViewTextEdit = (Bundle .main.loadNibNamed("ViewTextEdit", owner: self, options: nil)![0] as! ViewTextEdit)
            viewTextEdit.delegate = self
            viewTextEdit.tag = Tag
            viewTextEdit.titleString = detailDic["Title"] as! NSString
            viewTextEdit.alertString = detailDic["Alert"] as! NSString
            viewTextEdit.alertMessageString = detailDic["InfoMessage"] as! NSString
            viewTextEdit.frame = CGRect(x: 0, y: value, width: self.width(), height: 100)
            viewTextEdit.TxtMessage.placeholder = detailDic["Hint"] as? String
            self.addSubview(viewTextEdit)
            viewTextEdit.updateView()
            value = value + 100
        }
        else if typeString == "Number"{
            let viewnumber: ViewNumber = (Bundle .main.loadNibNamed("ViewNumber", owner: self, options: nil)![0] as! ViewNumber)
            viewnumber.delegate = self
            viewnumber.tag = Tag
            viewnumber.typeString = addParams as NSString
            viewnumber.titleString = detailDic["Title"] as! NSString
            viewnumber.alertString = detailDic["Alert"] as! NSString
            viewnumber.alertMessageString = detailDic["InfoMessage"] as! NSString
            viewnumber.frame = CGRect(x: 0, y: value, width: self.width(), height: 100)
            viewnumber.TxtMessage.placeholder = detailDic["Hint"] as? String
            self.addSubview(viewnumber)
            viewnumber.UpdateView()
            value = value + 100
        }
        else if typeString == "Date"{
            let viewDateOfBirth: ViewDOB = (Bundle .main.loadNibNamed("ViewDOB", owner: self, options: nil)![0] as! ViewDOB)
            viewDateOfBirth.frame = CGRect(x: 0, y: value, width: self.width(), height: 100)
            viewDateOfBirth.delegate = self
            viewDateOfBirth.tag = Tag
            viewDateOfBirth.TitleString = detailDic["Title"] as! NSString
            viewDateOfBirth.alertString = detailDic["Alert"] as! NSString
            viewDateOfBirth.alertMessageString = detailDic["InfoMessage"] as! NSString
            viewDateOfBirth.lblDOB.text = detailDic["Hint"] as? String
            viewDateOfBirth.lblDOB.textColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.000)
            self.addSubview(viewDateOfBirth)
            viewDateOfBirth.setView()
            value = value + 100
        }
        else if typeString == "TextArea"{
            let viewEditArea: ViewTextEditArea = (Bundle .main.loadNibNamed("ViewTextEditArea", owner: self, options: nil)![0] as! ViewTextEditArea)
            viewEditArea.delegate = self
            viewEditArea.tag = Tag
            viewEditArea.frame = CGRect(x: 0, y: value, width: self.width(), height: 135)
            viewEditArea.titleString = detailDic["Title"] as! NSString
            viewEditArea.alertString = detailDic["Alert"] as! NSString
            viewEditArea.alertMessageString = detailDic["InfoMessage"] as! NSString
            viewEditArea.lblPlaceHolderText.text = detailDic["Hint"] as? String
            self.addSubview(viewEditArea)
            viewEditArea.UpdateViewDetail()
            value = value + 135
        }
        else if typeString == "Dialog_single"{
            let Viewdialogsingle: ViewDialogSingle = (Bundle .main.loadNibNamed("ViewDialogSingle", owner: self, options: nil)![0] as! ViewDialogSingle)
            Viewdialogsingle.delegate = self
            Viewdialogsingle.tag = Tag
            Viewdialogsingle.frame = CGRect(x: 0, y: value, width: self.width(), height: 100)
            Viewdialogsingle.titleString = detailDic["Title"] as! NSString
            Viewdialogsingle.alertString = detailDic["Alert"] as! NSString
            Viewdialogsingle.alertMessageString = detailDic["InfoMessage"] as! NSString
            Viewdialogsingle.answerString = detailDic["Answer"] as! NSString
            
            let Title : NSString = detailDic["Title"] as! NSString
            if(Title.isEqual(to: "Context*")) {
                Viewdialogsingle.arrayOfItems = self.addContextarray()
            }
            else if(Title.isEqual(to: "Medication Time")) {
                Viewdialogsingle.arrayOfItems = self.addMedicationTime()
            }
            else if(Title.isEqual(to: "Blood Glucose Unit")) {
                Viewdialogsingle.arrayOfItems = self.addBloodGlucoseUnit()
            }
            self.addSubview(Viewdialogsingle)
            Viewdialogsingle.UpdateDialogSignle()
            value = value + 100
        }
        else if typeString == "Yes_No"{
            let ViewYesNo: ViewYesOrNO = (Bundle .main.loadNibNamed("ViewYesOrNO", owner: self, options: nil)![0] as! ViewYesOrNO)
            ViewYesNo.delegate = self
            ViewYesNo.tag = Tag
            ViewYesNo.frame = CGRect(x: 0, y: value, width: self.width(), height: 100)
            ViewYesNo.titleString = detailDic["Title"] as! NSString
            ViewYesNo.alertString = detailDic["Alert"] as! NSString
            ViewYesNo.alertMessageString = detailDic["InfoMessage"] as! NSString
            self.addSubview(ViewYesNo)
            ViewYesNo.setView()

            value = value + 100
        }
        
        return value
    }
    func setButtons(value : CGFloat) {
        let viewButton: ViewButton = (Bundle .main.loadNibNamed("ViewButton", owner: self, options: nil)![0] as! ViewButton)
        viewButton.frame = CGRect(x: 0, y: value, width: self.width(), height: 60)
        self.addSubview(viewButton)
        viewButton.buttonNext.addTarget(self, action: #selector(ViewAddDataPage.nextPage(sender:)), for: .touchUpInside)
        viewButton.buttonPrevious.addTarget(self, action: #selector(ViewAddDataPage.previousPage(sender:)), for: .touchUpInside)

        if(self.currentPage == 0){
            viewButton.buttonPrevious.isHidden = true
        }
        else {
            viewButton.buttonPrevious.isHidden = false
        }
        if(self.currentPage == (self.totalPage-1)) {
            viewButton.buttonNext.setTitle("CONFIRM" as String,for: .normal)
        }
        else {
            viewButton.buttonNext.setTitle("NEXT" as String,for: .normal)
        }
    }
    func nextPage(sender: UIButton){
        
        AppDelegate.appDelegate().window?.endEditing(true)

        if ((self.tag + 1) <= self.arrayList.count-1) {
            let DetailDic : NSMutableDictionary = self.arrayList[self.tag] as! NSMutableDictionary
            if(DetailDic["RequiredFlag"] as! String == "1"){
                if(DetailDic["Answer"] as! String == ""){
                    self.showAlert(message: "Please enter \(DetailDic["Title"]!)")//required fields
                    return
                }
            }
            let DetailDics : NSMutableDictionary = self.arrayList[self.tag+1] as! NSMutableDictionary
            if(DetailDics["RequiredFlag"] as! String == "1"){
                if(DetailDics["Answer"] as! String == ""){
                    self.showAlert(message: "Please enter \(DetailDics["Title"]!)")
                    return
                }
            }
            
        }
        else if (self.tag <= self.arrayList.count-1) {
            let DetailDic : NSMutableDictionary = self.arrayList[self.tag] as! NSMutableDictionary
            if(DetailDic["RequiredFlag"] as! String == "1"){
                if(DetailDic["Answer"] as! String == ""){
                    self.showAlert(message: "Please enter required fields")
                    return
                }
            }
        }
        if(self.currentPage == (self.totalPage-1)) {
            print(self.arrayList)
            let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
            for Index in 0..<self.arrayList.count {
                let dictionaryDetails: NSMutableDictionary = self.arrayList[Index] as! NSMutableDictionary
                let typeString : NSString = dictionaryDetails["Type"] as! NSString
                let Hint : NSString = dictionaryDetails["Hint"] as! NSString
                if(typeString.isEqual(to: "Number")){
                    if(Hint.isEqual(to: "BMI")){
                        let AnswerFloat = Float(dictionaryDetails["Answer"] as! String)
                        let AnswerNumber = NSNumber(value: Float(AnswerFloat!))
                        Parsedictionary.setObject(AnswerNumber, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                    }
                    else {
                        let AnswerInt = Int(dictionaryDetails["Answer"] as! String)
                        if let valueAnswer = AnswerInt {
                        let AnswerNumber = NSNumber(value:valueAnswer)
                        Parsedictionary.setObject(AnswerNumber, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                    }
                    }
                }
                else {
                    Parsedictionary.setObject(dictionaryDetails["Answer"] as Any, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
            }
            print(self.monitoringParameterArray)
            var multableparams : NSMutableDictionary = NSMutableDictionary()
            if(self.moduleType == "Blood Pressure"){
                Parsedictionary.setObject(AppManager.sharedInstance.subBloodPressure(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray), forKey: "data" as NSCopying)
                multableparams = AppManager.sharedInstance.createBloodPressure(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray)
            }
            else if(self.moduleType == "Blood Glucose"){
                Parsedictionary.setObject(AppManager.sharedInstance.subBloodGlucose(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray), forKey: "data" as NSCopying)
                multableparams = AppManager.sharedInstance.createBloodGlucose(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray)
            }
            else if(self.moduleType == "Weight"){
                Parsedictionary.setObject(AppManager.sharedInstance.subWeight(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray), forKey: "data" as NSCopying)
                multableparams = AppManager.sharedInstance.createWeight(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray)
            }
            else if(self.moduleType == "Sleep"){
                Parsedictionary.setObject(AppManager.sharedInstance.subSleep(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray), forKey: "data" as NSCopying)
                multableparams = AppManager.sharedInstance.createSleep(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray)
            }
            else if(self.moduleType == "Activity"){
                Parsedictionary.setObject(AppManager.sharedInstance.subActivity(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray), forKey: "data" as NSCopying)
                multableparams = AppManager.sharedInstance.createActivity(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray)
            }
            else if(self.moduleType == "Sports"){
                Parsedictionary.setObject(AppManager.sharedInstance.subSports(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray), forKey: "data" as NSCopying)
                multableparams = AppManager.sharedInstance.createSports(Dic: Parsedictionary, monitoringParameter: self.monitoringParameterArray)
            }
            print(multableparams)
            self.addParams(Parsedictionary: multableparams)
            
        }
        else {
            if(self.delegate is AddDataViewController) {
                let AddDataVC : AddDataViewController = (self.delegate as! AddDataViewController)
                AddDataVC.scrollToNextPage(page: self.currentPage+1)
            }
        }
    }
    func previousPage(sender: UIButton){
        AppDelegate.appDelegate().window?.endEditing(true)
        if(self.delegate is AddDataViewController) {
            let AddDataVC : AddDataViewController = (self.delegate as! AddDataViewController)
            AddDataVC.scrollToNextPage(page: self.currentPage-1)
        }
    }
    func addParams(Parsedictionary : NSMutableDictionary) {
        let address = String(format: "%@monitoring/%@/create",kAPIDOMAIN,self.setUrl()) as String
        let aUrl = URL(string:address)!
        var urlRequest = URLRequest(url: aUrl)
        
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue(AppManager.sharedInstance.authendication(), forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let arraytest : NSMutableArray = []
        arraytest.add(Parsedictionary)
        
        MBProgressHUD.showAdded(to: self, animated: true)
        
        let aDataParameter = try! JSONSerialization.data(withJSONObject: arraytest, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: aDataParameter, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        
        urlRequest.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        Alamofire.request(urlRequest)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                self.AddeddataArray.removeAll()
                MBProgressHUD.hideAllHUDs(for: self, animated: true)
                
//                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) 
//                    print(jsonObject)
//
//                } catch let error {
//                    print(error)
//                }

                let jData = JSON(data: response.data!)
                self.AddeddataArray = jData.arrayValue
                if(self.AddeddataArray.count != 0){
                    
                    let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                    viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
                    AppDelegate.appDelegate().window?.addSubview(viewAlert)
                    viewAlert.delegate = self
                    viewAlert.IndexTag = "101"
                    viewAlert.AlertType = "Text"
                    viewAlert.isSingle = true
                    viewAlert.AlertMessage = NSString(format:"Congrats. You have completed the %@ Monitoring. Shall we see the results now?", self.moduleType)
                    viewAlert.UpdateDetailView()
                    viewAlert.alpha = 0
                    
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        viewAlert.alpha = 1
                    }, completion: {(finished: Bool) -> Void in
                    })
                    
                }
        }
    }
    func dataAddedSuccessfully(){
        if self.delegate is AddDataViewController {
            let AddDataVC : AddDataViewController = (self.delegate as! AddDataViewController)
            AddDataVC.dataAdded()
        }
    }
    func setUrl() -> String {
        let urlString = self.moduleType.replacingOccurrences(of: " ", with: "")
        return urlString
    }
    func updateAnswer(Tag : Int, answer : String) {
        let detailDictionary : NSMutableDictionary = self.arrayList[Tag] as! NSMutableDictionary
        detailDictionary.setObject(answer, forKey: "Answer" as NSCopying)
    }
    func updateAnswerInt(Tag : Int, answer : Int) {
        let detailDictionary : NSMutableDictionary = self.arrayList[Tag] as! NSMutableDictionary
        detailDictionary.setObject(answer, forKey: "Answer" as NSCopying)
    }
    func addContextarray()-> NSMutableArray {
        let arrayList : NSMutableArray = []
        arrayList.add("Fasting")
        arrayList.add("After Breakfast")
        arrayList.add("Before Lunch")
        arrayList.add("After Lunch")
        arrayList.add("Before Dinner")
        arrayList.add("After Dinner")
        arrayList.add("After Exercise")
        return arrayList
    }
    func addMedicationTime()-> NSMutableArray {
        let arrayList : NSMutableArray = []
        arrayList.add("1 Hour ago")
        arrayList.add("2 Hour ago")
        arrayList.add("3 Hour ago")
        arrayList.add("4 Hour ago")
        arrayList.add("5 Hour ago")
        arrayList.add("6 Hour ago")
        arrayList.add("7 Hour ago")
        return arrayList
    }
    func addBloodGlucoseUnit()-> NSMutableArray {
        let arrayList : NSMutableArray = []
        arrayList.add("mmol/L")
        arrayList.add("mg/dL")
        return arrayList
    }
    func showAlert(message: String) {
        
        if(self.delegate is AddDataViewController) {
            let AddDataVC : AddDataViewController = (self.delegate as! AddDataViewController)
            let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            AddDataVC.present(alertController, animated: true, completion: nil)
        }
    }

}
