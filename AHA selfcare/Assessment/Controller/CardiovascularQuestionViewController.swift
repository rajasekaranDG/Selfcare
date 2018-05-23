//
//  CardiovascularQuestionViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 25/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CardiovascularQuestionViewController: UIViewController {

    var delegate : AnyObject?
    var arrayOfItems : NSMutableArray = []
    var AddeddataArray = [JSON] ()
    var Count : CGFloat = 0
    
    @IBOutlet weak var scrollMain : UIScrollView!
    
    @IBAction func backClick(_ sender: Any) {
        
        if self.delegate is CardiovascularViewController {
            let CardiovascularVC : CardiovascularViewController = (self.delegate as! CardiovascularViewController)
            CardiovascularVC.backClick("")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.arrayOfItems = HelpAppManager.shared().cardiovascularQuestions()
        //@"How many cigarettes do you smoke in a day?"
        self.setPagesinScroll()
    }
    func addQuestion() {
        
        let index : Int = Int(HelpAppManager.shared().checkArrayValue(self.arrayOfItems , key: "Title", checkValue: "How many cigarettes do you smoke in a day?"))
        if index < self.arrayOfItems.count {
        }
        else {
            self.arrayOfItems.insert(HelpAppManager.shared().addQuestions(), at: 2)
            let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
            let PageHeight : CGFloat = (iPhone6Pluse) ? 736 : (iPhone6) ? 667 : 568
            let subViews = self.scrollMain.subviews
            var Count : CGFloat = 0
            for subview in subViews{
                if(Count == 1){
                    let viewEditNumber: ViewEditNumber = (Bundle .main.loadNibNamed("ViewEditNumber", owner: self, options: nil)![0] as! ViewEditNumber)
                    viewEditNumber.delegate = self
                    viewEditNumber.tag = 2
                    viewEditNumber.currentPage = 2
                    viewEditNumber.totalPage = self.arrayOfItems.count-1
                    viewEditNumber.titleString = "How many cigarettes do you smoke in a day?"
                    viewEditNumber.alertString = "N"
                    viewEditNumber.alertMessageString = ""
                    viewEditNumber.frame = CGRect(x: 750, y: 0, width: PageWidth, height: PageHeight - 124)
                    self.scrollMain.addSubview(viewEditNumber)
                    viewEditNumber.setDetail()
                }
                if(Count > 1){
                    if(subview is ViewEditNumber){
                        let viewEditNumber: ViewEditNumber = subview as! ViewEditNumber
                        viewEditNumber.tag = Int(Count)+1
                        viewEditNumber.currentPage = Int(Count)+1
                    }
                    else if(subview is ViewDecimal){
                        let viewDecimal: ViewDecimal = subview as! ViewDecimal
                        viewDecimal.tag = Int(Count)+1
                        viewDecimal.currentPage = Int(Count)+1
                    }
                    else if(subview is ViewEditText){
                        let viewEditText: ViewEditText = subview as! ViewEditText
                        viewEditText.tag = Int(Count)+1
                        viewEditText.currentPage = Int(Count)+1
                    }
                    else if(subview is ViewAge){
                        let viewage: ViewAge = subview as! ViewAge
                        viewage.tag = Int(Count)+1
                        viewage.currentPage = Int(Count)+1
                    }
                    else if(subview is ViewSelectAnswers){
                        let viewSelectAnswers: ViewSelectAnswers = subview as! ViewSelectAnswers
                        viewSelectAnswers.tag = Int(Count)+1
                        viewSelectAnswers.currentPage = Int(Count)+1
                    }
                    subview.frame = CGRect(x: subview.x()+PageWidth, y: 0, width: PageWidth, height: PageHeight - 124)
                }
                Count = Count + 1;
            }
            self.scrollMain.contentSize = CGSize(width: (Count * PageWidth), height: PageHeight - 124)
        }
    }
    func removeQuestion() {
        
        let index : Int = Int(HelpAppManager.shared().checkArrayValue(self.arrayOfItems , key: "Title", checkValue: "How many cigarettes do you smoke in a day?"))
        if index < self.arrayOfItems.count {
            self.arrayOfItems.removeObject(at: index)
            let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
            let PageHeight : CGFloat = (iPhone6Pluse) ? 736 : (iPhone6) ? 667 : 568
            var Count : CGFloat = 0
            let subViews = self.scrollMain.subviews
            for subview in subViews{
                if(subview.tag == 2){
                    subview.removeFromSuperview()
                }
                if(subview.tag > 2){
                    if(subview is ViewEditNumber){
                        let viewEditNumber: ViewEditNumber = subview as! ViewEditNumber
                        viewEditNumber.tag = Int(Count)-1
                        viewEditNumber.currentPage = Int(Count)-1
                    }
                    else if(subview is ViewDecimal){
                        let viewDecimal: ViewDecimal = subview as! ViewDecimal
                        viewDecimal.tag = Int(Count)-1
                        viewDecimal.currentPage = Int(Count)-1
                    }
                    else if(subview is ViewEditText){
                        let viewEditText: ViewEditText = subview as! ViewEditText
                        viewEditText.tag = Int(Count)-1
                        viewEditText.currentPage = Int(Count)-1
                    }
                    else if(subview is ViewAge){
                        let viewage: ViewAge = subview as! ViewAge
                        viewage.tag = Int(Count)-1
                        viewage.currentPage = Int(Count)-1
                    }
                    else if(subview is ViewSelectAnswers){
                        let viewSelectAnswers: ViewSelectAnswers = subview as! ViewSelectAnswers
                        viewSelectAnswers.tag = Int(Count)-1
                        viewSelectAnswers.currentPage = Int(Count)-1
                    }
                    subview.frame = CGRect(x: subview.x() - PageWidth, y: 0, width: PageWidth, height: PageHeight - 124)
                }
                Count = Count + 1;
            }
            self.scrollMain.contentSize = CGSize(width: (Count * PageWidth), height: PageHeight - 124)
        }
    }
    func updateAnswer(Tag : Int, answer : String) {
        let detailDictionary : NSMutableDictionary = self.arrayOfItems[Tag] as! NSMutableDictionary
        detailDictionary.setObject(answer, forKey: "Answer" as NSCopying)
    }
    func setPagesinScroll() {
        
        let subViews = self.scrollMain.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        let PageHeight : CGFloat = (iPhone6Pluse) ? 736 : (iPhone6) ? 667 : 568

        var xValue : CGFloat = 0
        for Index in 0..<self.arrayOfItems.count {
            let detailDic : NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            let typeString : String = detailDic["Type"] as! String
            
            if typeString == "Number"{
                let viewEditNumber: ViewEditNumber = (Bundle .main.loadNibNamed("ViewEditNumber", owner: self, options: nil)![0] as! ViewEditNumber)
                viewEditNumber.delegate = self
                viewEditNumber.tag = Index
                viewEditNumber.currentPage = Index
                viewEditNumber.totalPage = self.arrayOfItems.count-1
                viewEditNumber.titleString = detailDic["Title"] as! NSString
                viewEditNumber.alertString = detailDic["Alert"] as! NSString
                viewEditNumber.alertMessageString = detailDic["InfoMessage"] as! NSString
                viewEditNumber.frame = CGRect(x: xValue, y: 0, width: PageWidth, height: PageHeight - 124)
                self.scrollMain.addSubview(viewEditNumber)
                viewEditNumber.setDetail()
            }
            else if typeString == "Decimal"{
                let viewDecimal: ViewDecimal = (Bundle .main.loadNibNamed("ViewDecimal", owner: self, options: nil)![0] as! ViewDecimal)
                viewDecimal.delegate = self
                viewDecimal.tag = Index
                viewDecimal.currentPage = Index
                viewDecimal.totalPage = self.arrayOfItems.count-1
                viewDecimal.titleString = detailDic["Title"] as! NSString
                viewDecimal.alertString = detailDic["Alert"] as! NSString
                viewDecimal.alertMessageString = detailDic["InfoMessage"] as! NSString
                viewDecimal.frame = CGRect(x: xValue, y: 0, width: PageWidth, height: PageHeight - 124)
                self.scrollMain.addSubview(viewDecimal)
                viewDecimal.setDetail()
            }
            else if typeString == "TextEdit"{
                let viewEditText: ViewEditText = (Bundle .main.loadNibNamed("ViewEditText", owner: self, options: nil)![0] as! ViewEditText)
                viewEditText.delegate = self
                viewEditText.tag = Index
                viewEditText.currentPage = Index
                viewEditText.totalPage = self.arrayOfItems.count-1
                viewEditText.titleString = detailDic["Title"] as! NSString
                viewEditText.alertString = detailDic["Alert"] as! NSString
                viewEditText.alertMessageString = detailDic["InfoMessage"] as! NSString
                viewEditText.frame = CGRect(x: xValue, y: 0, width: PageWidth, height: PageHeight - 124)
                self.scrollMain.addSubview(viewEditText)
                viewEditText.setDetail()
            }
            else if typeString == "Age"{
                let viewage: ViewAge = (Bundle .main.loadNibNamed("ViewAge", owner: self, options: nil)![0] as! ViewAge)
                viewage.delegate = self
                viewage.tag = Index
                viewage.currentPage = Index
                viewage.totalPage = self.arrayOfItems.count-1
                viewage.titleString = detailDic["Title"] as! NSString
                viewage.alertString = detailDic["Alert"] as! NSString
                viewage.alertMessageString = detailDic["InfoMessage"] as! NSString
                viewage.frame = CGRect(x: xValue, y: 0, width: PageWidth, height: PageHeight - 124)
                self.scrollMain.addSubview(viewage)
                viewage.setDetail()
            }
            else if (typeString == "Dialog_single"){
                let viewSelectAnswers: ViewSelectAnswers = (Bundle .main.loadNibNamed("ViewSelectAnswers", owner: self, options: nil)![0] as! ViewSelectAnswers)
                viewSelectAnswers.delegate = self
                viewSelectAnswers.tag = Index
                viewSelectAnswers.isCardiovascular = true
                viewSelectAnswers.currentPage = Index
                viewSelectAnswers.totalPage = self.arrayOfItems.count-1
                viewSelectAnswers.arrayOfItems = AppManager.sharedInstance.selectArrayType(type: detailDic["arrayType"] as! NSString)
                viewSelectAnswers.typeString = detailDic["arrayType"] as! NSString
                viewSelectAnswers.titleString = detailDic["Title"] as! NSString
                viewSelectAnswers.alertString = detailDic["Alert"] as! NSString
                viewSelectAnswers.alertMessageString = detailDic["InfoMessage"] as! NSString
                viewSelectAnswers.frame = CGRect(x: xValue, y: 0, width: PageWidth, height: PageHeight - 124)
                self.scrollMain.addSubview(viewSelectAnswers)
                viewSelectAnswers.setDetail()
            }
            
            xValue = xValue + PageWidth
        }
        self.scrollMain.contentSize = CGSize(width: xValue, height: PageHeight - 124)
    }
    func scrollToNextPage(page: Int) {
        if(page == self.arrayOfItems.count){
            AppDelegate.appDelegate().window?.endEditing(true)

            let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
            for Index in 0..<self.arrayOfItems.count {
                let dictionaryDetails: NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
                let answeringQuestion : NSString = dictionaryDetails["addParams"] as! NSString
                if(answeringQuestion.isEqual(to: "answeringQuestion")){
                    Parsedictionary.setObject(dictionaryDetails["Answer"] as! String, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
                else if((answeringQuestion.isEqual(to: "totalCholastrol")) || (answeringQuestion.isEqual(to: "hdlCholastrol"))){
                    let floatValue : Float = Float(dictionaryDetails["Answer"] as! String)!
                    Parsedictionary.setObject(floatValue, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
                else {
                    let intValue : Int = Int(dictionaryDetails["Answer"] as! String)!
                    Parsedictionary.setObject(intValue, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
            }
            var multableparams : NSMutableDictionary = NSMutableDictionary()
            Parsedictionary.setObject(AppManager.sharedInstance.subAssessmentDisease(Dic: Parsedictionary), forKey: "data" as NSCopying)
            multableparams = AppManager.sharedInstance.createAssessmentDisease(Dic: Parsedictionary)
            print(self.arrayOfItems)
            print(multableparams)

            self.addParams(Parsedictionary: multableparams)

        }
        else {
            var frame: CGRect = self.scrollMain.frame
            frame.origin.x = frame.size.width * CGFloat(page);
            frame.origin.y = 0;
            self.scrollMain.scrollRectToVisible(frame, animated: true)
        }
    }
    func addParams(Parsedictionary : NSMutableDictionary) {
        let address = String(format: "%@assessment/CardioVascular/create",kAPIDOMAIN) as String
        let aUrl = URL(string:address)!
        var urlRequest = URLRequest(url: aUrl)
        
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue(AppManager.sharedInstance.authendication(), forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let arraytest : NSMutableArray = []
        arraytest.add(Parsedictionary)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
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
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                //                do {
                //                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers)
                //                    print(jsonObject)
                //
                //                } catch let error {
                //                    print(error)
                //                }
                
                let jData = JSON(data: response.data!)
                self.AddeddataArray = jData.arrayValue
                print(self.AddeddataArray)
                if(self.AddeddataArray.count != 0){
                    
                    let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                    viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
                    AppDelegate.appDelegate().window?.addSubview(viewAlert)
                    viewAlert.delegate = self
                    viewAlert.IndexTag = "101"
                    viewAlert.AlertType = "Text"
                    viewAlert.isSingle = true
                    viewAlert.AlertMessage = "Congrats. You have completed the Cardio Vascular Assessment. Shall we see the results now?"
                    viewAlert.UpdateDetailView()
                    viewAlert.alpha = 0
                    
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        viewAlert.alpha = 1
                    }, completion: {(finished: Bool) -> Void in
                    })
                    
                }
        }
    }
    func scrollToPreviousPage(page: Int) {
        var frame: CGRect = self.scrollMain.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrollMain.scrollRectToVisible(frame, animated: true)
    }
    func resultClick() {
        if self.delegate is CardiovascularViewController {
            let CardiovascularVC : CardiovascularViewController = (self.delegate as! CardiovascularViewController)
            CardiovascularVC.resultClick("")
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
