//
//  ObesityQuestionViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 24/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ObesityQuestionViewController: UIViewController {

    var delegate : AnyObject?
    var arrayOfItems : NSMutableArray = []
    var AddeddataArray = [JSON] ()

    @IBOutlet weak var scrollMain : UIScrollView!

    @IBAction func backClick(_ sender: Any) {
        if self.delegate is ObesityViewController {
            let ObesityVC : ObesityViewController = (self.delegate as! ObesityViewController)
            ObesityVC.goAssessmentHome()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.arrayOfItems = HelpAppManager.shared().obesityQuestions()
        self.setPagesinScroll()
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
//                viewSelectAnswers.backgroundColor = UIColor.red
                viewSelectAnswers.currentPage = Index
                viewSelectAnswers.totalPage = self.arrayOfItems.count-1
                viewSelectAnswers.arrayOfItems = AppManager.sharedInstance.selectArrayType(type: detailDic["arrayType"] as! NSString)
                viewSelectAnswers.titleString = detailDic["Title"] as! NSString
                viewSelectAnswers.alertString = detailDic["Alert"] as! NSString
                viewSelectAnswers.alertMessageString = detailDic["InfoMessage"] as! NSString
                viewSelectAnswers.frame = CGRect(x: xValue, y: 0, width: PageWidth, height: PageHeight - 124)
                self.scrollMain.addSubview(viewSelectAnswers)
                viewSelectAnswers.setDetail()
            }
//            else if typeString == "Number"{
//                let viewnumber: ViewNumber = (Bundle .main.loadNibNamed("ViewNumber", owner: self, options: nil)![0] as! ViewNumber)
//                viewnumber.delegate = self
//                viewnumber.tag = Index
//                viewnumber.lblTitle.text = detailDic["Title"] as? String
//                viewnumber.frame = CGRect(x: 0, y: value, width: self.view.width(), height: 100)
//                viewnumber.TxtMessage.placeholder = detailDic["Hint"] as? String
//                self.scrollMain.addSubview(viewnumber)
//            }

            xValue = xValue + PageWidth
        }
        self.scrollMain.contentSize = CGSize(width: xValue, height: PageHeight - 124)
    }
    func scrollToPreviousPage(page: Int) {
        var frame: CGRect = self.scrollMain.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrollMain.scrollRectToVisible(frame, animated: true)
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
                else {
                    let intValue : Int = Int(dictionaryDetails["Answer"] as! String)!
                    Parsedictionary.setObject(intValue, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
            }
            var multableparams : NSMutableDictionary = NSMutableDictionary()
            Parsedictionary.setObject(AppManager.sharedInstance.subAssessmentObesity(Dic: Parsedictionary), forKey: "data" as NSCopying)
            multableparams = AppManager.sharedInstance.createAssessmentObesity(Dic: Parsedictionary)
            multableparams.removeObject(forKey: "age")
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
        let address = String(format: "%@assessment/Bmi/create",kAPIDOMAIN) as String
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
                    viewAlert.AlertMessage = "Congrats. You have completed the Obesity Assessment. Shall we see the results now?"
                    viewAlert.UpdateDetailView()
                    viewAlert.alpha = 0
                    
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        viewAlert.alpha = 1
                    }, completion: {(finished: Bool) -> Void in
                    })
                    
                }
        }
    }
    func resultClick() {
        if self.delegate is ObesityViewController {
            let ObesityVC : ObesityViewController = (self.delegate as! ObesityViewController)
            ObesityVC.resultClick("")
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
