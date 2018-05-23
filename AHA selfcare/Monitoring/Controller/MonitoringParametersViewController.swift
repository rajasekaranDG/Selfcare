//
//  MonitoringParametersViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 22/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MonitoringParametersViewController: UIViewController {

    var delegate : AnyObject?
    var moduleType : String = ""
    var arrayOfItems : NSMutableArray = []
    var bloodPressureArray : NSMutableArray = []
    var bloodGlucoseArray : NSMutableArray = []
    var weightArray : NSMutableArray = []
    var sleepArray : NSMutableArray = []
    var activityArray : NSMutableArray = []
    var sportsArray : NSMutableArray = []
    var monitoringParameterArray = [JSON] ()
    var idString : String = ""
    var saveDataArray = [JSON] ()
    var isUpdated : Bool!
    var stringCreate : String = ""

    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var scrollViewMain : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewMain : UIView!
    @IBOutlet weak var buttonSave : UIButton!
    @IBOutlet weak var buttonClear : UIButton!
    @IBOutlet weak var buttonCreate : UIButton!

    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //
        if(self.moduleType == "Blood Pressure"){
            self.arrayOfItems = HelpAppManager.shared().insertBloodPressureMonitoringParameters()
        }
        else if(self.moduleType == "Blood Glucose"){
            self.arrayOfItems = HelpAppManager.shared().insertBloodGlucoseMonitoringParameters()
        }
        else if(self.moduleType == "Weight"){
            self.arrayOfItems = HelpAppManager.shared().insertWeightMonitoringParameters()
        }
        else if(self.moduleType == "Sleep"){
            self.arrayOfItems = HelpAppManager.shared().insertSleepMonitoringParameters()
        }
        else if(self.moduleType == "Activity"){
            self.arrayOfItems = HelpAppManager.shared().insertActivityMonitoringParameters()
        }
        else if(self.moduleType == "Sports"){
            self.arrayOfItems = HelpAppManager.shared().insertSportsMonitoringParameters()
        }
        self.scrollViewMain.contentSizeToFit()
        self.fetchMonitoringParameters()
        
    }
    func fetchMonitoringParameters() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let address = String(format: "%@monparam/%@/%@",kAPIDOMAIN,self.setUrl(),AppManager.sharedInstance.userName()) as String
        
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                let jData = JSON(data: response.data!)
                self.monitoringParameterArray = jData.arrayValue
                print(self.monitoringParameterArray)
                if(self.monitoringParameterArray.count != 0){
                    self.buttonCreate.isHidden = true
                    self.buttonSave.isHidden = false
                    self.buttonClear.isHidden = false
                    self.insertAnswers()
                    self.idString = self.monitoringParameterArray[0]["_id"].stringValue
                    self.isUpdated = true
                    self.stringCreate = "update"
                }
                else {
                    self.stringCreate = "create"
                    self.isUpdated = false
                    self.buttonCreate.isHidden = false
                    self.buttonSave.isHidden = true
                    self.buttonClear.isHidden = true
                    self.setPagesinScroll()
                }
        }
    }
    func insertAnswers() {
        for Index in 0..<self.arrayOfItems.count {
            let dictionaryDetails : NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            let valueKey : String = dictionaryDetails["addParams"] as! String
            let keyValue : String = self.monitoringParameterArray[0][valueKey].stringValue
            dictionaryDetails.setObject(keyValue, forKey: "Answer" as NSCopying)
        }
        print(self.arrayOfItems)
        self.setPagesinScroll()
    }
    func setUrl() -> String {
        let urlString = self.moduleType.replacingOccurrences(of: " ", with: "")
        return urlString
    }
    func setPagesinScroll() {
        
        let subViews = self.viewMain.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        var yValue : CGFloat = 0
        let arrayItems : NSMutableArray = self.arrayOfItems
        
        for Index in 0..<arrayItems.count {
            yValue = self.setViewUpdate(value: yValue, typeList: arrayOfItems, Tag: Index)
        }
        self.viewMain.setHeight(yValue + 20)
        self.scrollViewMain.contentSizeToFit()
    }
    func setViewUpdate(value : CGFloat, typeList : NSMutableArray, Tag : Int)-> CGFloat {
        var value : CGFloat = value
        
        let detailDic : NSMutableDictionary = typeList[Tag] as! NSMutableDictionary
        let typeString : String = detailDic["Type"] as! String
        
        if typeString == "TextEdit"{
            let viewTextEdit: ViewTextEdit = (Bundle .main.loadNibNamed("ViewTextEdit", owner: self, options: nil)![0] as! ViewTextEdit)
            viewTextEdit.delegate = self
            viewTextEdit.tag = Tag
            viewTextEdit.titleString = detailDic["Title"] as! NSString
            viewTextEdit.frame = CGRect(x: 0, y: value, width: self.view.width(), height: 100)
            viewTextEdit.TxtMessage.placeholder = detailDic["Hint"] as? String
            viewTextEdit.TxtMessage.text = detailDic["Answer"] as? String
            self.viewMain.addSubview(viewTextEdit)
            value = value + 100
        }
        else if typeString == "Number"{
            let viewnumber: ViewNumber = (Bundle .main.loadNibNamed("ViewNumber", owner: self, options: nil)![0] as! ViewNumber)
            viewnumber.delegate = self
            viewnumber.tag = Tag
            viewnumber.titleString = detailDic["Title"] as! NSString
            viewnumber.frame = CGRect(x: 0, y: value, width: self.view.width(), height: 100)
            viewnumber.TxtMessage.placeholder = detailDic["Hint"] as? String
            viewnumber.TxtMessage.text = detailDic["Answer"] as? String
            self.viewMain.addSubview(viewnumber)
            viewnumber.UpdateView()
            value = value + 100
        }
        return value
    }
    func updateAnswer(Tag : Int, answer : String) {
        let detailDictionary : NSMutableDictionary = self.arrayOfItems[Tag] as! NSMutableDictionary
        detailDictionary.setObject(answer, forKey: "Answer" as NSCopying)
    }
    @IBAction func createMonitoringData(_ sender : Any) {
        self.saveMonitoringData("")
    }
    @IBAction func clearMonitoringData(_ sender : Any) {
        
        for Index in 0..<self.arrayOfItems.count {
            let dictionaryDetails : NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            dictionaryDetails.setObject("", forKey: "Answer" as NSCopying)
        }
        self.setPagesinScroll()
    }
    @IBAction func saveMonitoringData(_ sender : Any) {
        var isEmpty : Bool = true
        
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        for Index in 0..<self.arrayOfItems.count {
            let dictionaryDetails: NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            let typeString : String = dictionaryDetails["Type"] as! String
            let AnswerString : String = dictionaryDetails["Answer"] as! String
            if(AnswerString != ""){
                if typeString == "Number"{
                    let AnswerInt = Int(dictionaryDetails["Answer"] as! String)
                    let targetHighPressNumber = NSNumber(value:AnswerInt!)
                    Parsedictionary.setObject(targetHighPressNumber, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
                else {
                    Parsedictionary.setObject(dictionaryDetails["Answer"] as! String, forKey: dictionaryDetails["addParams"] as! String as NSCopying)
                }
            }
            else {
                isEmpty = false
                Parsedictionary.setObject("", forKey: dictionaryDetails["addParams"] as! String as NSCopying)
            }
        }
        if(isEmpty){
            var multableparams : NSMutableDictionary = NSMutableDictionary()
            if(self.moduleType == "Blood Pressure"){
                if(self.stringCreate == "create"){
                    Parsedictionary.setObject(AppManager.sharedInstance.subBloodPressureMonitoringParameter(Dic: Parsedictionary), forKey: "data" as NSCopying)
                }
                multableparams = AppManager.sharedInstance.createBloodPressureMonitoringParameter(Dic: Parsedictionary)
            }
            else if(self.moduleType == "Blood Glucose"){
                if(self.stringCreate == "create"){
                    Parsedictionary.setObject(AppManager.sharedInstance.subBloodGlucoseMonitoringParameter(Dic: Parsedictionary), forKey: "data" as NSCopying)
                }
                multableparams = AppManager.sharedInstance.createBloodGlucoseMonitoringParameter(Dic: Parsedictionary)
            }
            else if(self.moduleType == "Weight"){
                if(self.stringCreate == "create"){
                    Parsedictionary.setObject(AppManager.sharedInstance.subWeightMonitoringParameter(Dic: Parsedictionary), forKey: "data" as NSCopying)
                }
                multableparams = AppManager.sharedInstance.createWeightMonitoringParameter(Dic: Parsedictionary)
            }
            else if(self.moduleType == "Sleep"){
                //            if(self.stringCreate == "create"){
                Parsedictionary.setObject(AppManager.sharedInstance.subSleepMonitoringParameter(Dic: Parsedictionary), forKey: "data" as NSCopying)
                //            }
                multableparams = AppManager.sharedInstance.createSleepMonitoringParameter(Dic: Parsedictionary)
            }
            else if(self.moduleType == "Activity"){
                if(self.stringCreate == "create"){
                    Parsedictionary.setObject(AppManager.sharedInstance.subActivityMonitoringParameter(Dic: Parsedictionary), forKey: "data" as NSCopying)
                }
                multableparams = AppManager.sharedInstance.createActivityMonitoringParameter(Dic: Parsedictionary)
            }
            else if(self.moduleType == "Sports"){
                if(self.stringCreate == "create"){
                    Parsedictionary.setObject(AppManager.sharedInstance.subSportsMonitoringParameter(Dic: Parsedictionary), forKey: "data" as NSCopying)
                }
                multableparams = AppManager.sharedInstance.createSportsMonitoringParameter(Dic: Parsedictionary)
            }
            if(self.stringCreate == "update"){
                multableparams.setObject(self.idString, forKey: "_id" as NSCopying)
            }
            
            self.addParams(Parsedictionary: multableparams)
        }
        else {
            self.showAlert(message: "Please enter the all fields")
        }

    }
    func addParams(Parsedictionary : NSMutableDictionary) {
        let address = String(format: "%@monparam/%@/%@",kAPIDOMAIN,self.setUrl(),self.stringCreate) as String
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
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if(self.stringCreate == "update"){
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                        print(jsonObject)
                        if jsonObject["data"] != nil {
                            let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                            viewAlert.frame = self.view.frame
                            self.view.addSubview(viewAlert)
                            viewAlert.delegate = self
                            viewAlert.IndexTag = "101"
                            viewAlert.AlertType = "Text"
                            viewAlert.isSingle = true
                            if(self.isUpdated){
                                viewAlert.AlertMessage = "Successfully Updated"
                            }
                            else {
                                viewAlert.AlertMessage = "Successfully Created"
                            }
                            viewAlert.UpdateDetailView()
                            viewAlert.alpha = 0
                            
                            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                                viewAlert.alpha = 1
                            }, completion: {(finished: Bool) -> Void in
                            })
                        }
                    } catch let error {
                        print(error)
                    }
                }
                else {
                    self.saveDataArray.removeAll()
                    let jData = JSON(data: response.data!)
                    self.saveDataArray = jData.arrayValue
                    
                    if(self.saveDataArray.count != 0){
                        let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                        viewAlert.frame = self.view.frame
                        self.view.addSubview(viewAlert)
                        viewAlert.delegate = self
                        viewAlert.IndexTag = "101"
                        viewAlert.AlertType = "Text"
                        viewAlert.isSingle = true
                        if(self.isUpdated){
                            viewAlert.AlertMessage = "Successfully Updated"
                        }
                        else {
                            viewAlert.AlertMessage = "Successfully Created"
                        }
                        viewAlert.UpdateDetailView()
                        viewAlert.alpha = 0
                        
                        UIView.animate(withDuration: 0.5, animations: {() -> Void in
                            viewAlert.alpha = 1
                        }, completion: {(finished: Bool) -> Void in
                        })
                        
                    }
                }
        }
    }
    func updateSuccessfully(){
        self.backClick("")
    }
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
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
