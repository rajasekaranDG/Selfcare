//
//  StartMonitoringViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 30/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import Firebase;

class StartMonitoringViewController: UIViewController {

    var delegate : AnyObject?

    @IBOutlet weak var viewAssessment : UIView!
    @IBOutlet weak var viewShop : UIView!
    @IBOutlet weak var viewMonitoring : UIView!
    @IBOutlet weak var viewRecords : UIView!
    @IBOutlet weak var viewRisk : UIView!
    
    @IBOutlet weak var imageAssessment : UIImageView!
    @IBOutlet weak var imageShop : UIImageView!
    @IBOutlet weak var imageMonitoring : UIImageView!
    @IBOutlet weak var imageRecords : UIImageView!
    @IBOutlet weak var imageRisk : UIImageView!
    
    @IBOutlet weak var lableAssessment : UILabel!
    @IBOutlet weak var lableShop : UILabel!
    @IBOutlet weak var lableMonitoring : UILabel!
    @IBOutlet weak var lableRecords : UILabel!
    @IBOutlet weak var lableRisk : UILabel!
    
    @IBOutlet weak var ViewBottom : UIView!
    @IBOutlet weak var lableLine : UILabel!
    
    var assessmentVC : AssessmentViewController!
    var assessmentStartVC : StartAssessmentViewController!
    var riskVC : RiskViewController!
    var recordsVC : RecordsViewController!
    var shopsVC : ShopViewController!

    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var viewEmpty : UIView!
    @IBOutlet weak var buttonStart : UIButton!
    @IBOutlet weak var labelMessage : UILabel!
    
    @IBOutlet weak var viewSystolic : UIView!
    @IBOutlet weak var viewDiastolic : UIView!
    @IBOutlet weak var viewHeartRate : UIView!
    @IBOutlet weak var viewWeight : UIView!
    @IBOutlet weak var viewHoursSlept : UIView!
    @IBOutlet weak var viewGlucose : UIView!
    @IBOutlet weak var viewSport : UIView!
    @IBOutlet weak var viewActivity : UIView!

    @IBOutlet weak var labelSystolicScore : UILabel!
    @IBOutlet weak var labelDiastolicScore : UILabel!
    @IBOutlet weak var labelHeartRateScore : UILabel!
    @IBOutlet weak var labelWeightScore : UILabel!
    @IBOutlet weak var labelSleptScore : UILabel!
    @IBOutlet weak var labelGlucoseScore : UILabel!
    @IBOutlet weak var labelSportScore : UILabel!
    @IBOutlet weak var labelActivityScore : UILabel!

    //Monitoring Summary
    var monitoringArray = [[String: String]]()
    @IBOutlet weak var tableMonitoring : UITableView!
    @IBOutlet weak var viewMonitoringSummary : UIView!
    @IBOutlet weak var viewStartMonitoring : UIView!

    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    @IBAction func logoutclick (_ sender : Any) {
        
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "userage")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "obesityStartFlag")
        UserDefaults.standard.removeObject(forKey: "diabetesQuestionFlag")
        UserDefaults.standard.removeObject(forKey: "MonitoringStartFlag")
        UserDefaults.standard.removeObject(forKey: "referralCode")
        UserDefaults.standard.removeObject(forKey: "appVersion")
        UserDefaults.standard.removeObject(forKey: "assessmentStartFlag")
        UserDefaults.standard.removeObject(forKey: "gender")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastname")
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
        UserDefaults.standard.removeObject(forKey: "govtId")
        UserDefaults.standard.removeObject(forKey: "country")
        UserDefaults.standard.removeObject(forKey: "state")
        UserDefaults.standard.removeObject(forKey: "city")
        UserDefaults.standard.removeObject(forKey: "postalCode")
        UserDefaults.standard.removeObject(forKey: "mobile")
        let SignInVC : SignInViewController = SignInViewController(nibName : "SignInViewController" , bundle : nil)
        self.navigationController?.pushViewController(SignInVC, animated: false)
    }
    @IBAction func AssessmentClick(_ sender: Any) {
        // [START custom_event_objc]
        Analytics.logEvent("Assessment", parameters: [
            "type": "iOS",
            "tab": "Assessment",
            ])
        // [END custom_event_objc]

        self.imageAssessment.isHighlighted = true
        self.imageShop.isHighlighted = false
        self.imageMonitoring.isHighlighted = false
        self.imageRecords.isHighlighted = false
        self.lableAssessment.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewAssessment.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.riskVC != nil{
            self.riskVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.shopsVC != nil{
            self.shopsVC.view .removeFromSuperview();
        }
        if self.recordsVC != nil{
            self.recordsVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        if(AppManager.sharedInstance.assessmentStartFlag() == ""){
            self.assessmentStartVC = StartAssessmentViewController(nibName : "StartAssessmentViewController" , bundle : nil)
            self.assessmentStartVC.delegate = self
            self.assessmentStartVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
            self.view.addSubview(self.assessmentStartVC.view)
            self.view.bringSubview(toFront: self.ViewBottom)
        }
        else {
            self.assessmentVC = AssessmentViewController(nibName : "AssessmentViewController" , bundle : nil)
            self.assessmentVC.delegate = self
            self.assessmentVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
            self.view.addSubview(self.assessmentVC.view)
            self.view.bringSubview(toFront: self.ViewBottom)
        }
    }
    @IBAction func ShopClick(_ sender: Any) {
        
        // [START custom_event_objc]
        Analytics.logEvent("Clinic", parameters: [
            "type": "iOS",
            "tab": "Clinic",
            ])
        // [END custom_event_objc]

        self.imageAssessment.isHighlighted = false
        self.imageShop.isHighlighted = true
        self.imageMonitoring.isHighlighted = false
        self.imageRecords.isHighlighted = false
        self.lableAssessment.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewShop.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.riskVC != nil{
            self.riskVC.view .removeFromSuperview();
        }
        if self.shopsVC != nil{
            self.shopsVC.view .removeFromSuperview();
        }
        if self.recordsVC != nil{
            self.recordsVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.shopsVC = ShopViewController(nibName : "ShopViewController" , bundle : nil)
        self.shopsVC.delegate = self
        self.shopsVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.shopsVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
        
    }
    @IBAction func MonitoringClick(_ sender: Any) {
        
        // [START custom_event_objc]
        Analytics.logEvent("Monitoring", parameters: [
            "type": "iOS",
            "tab": "Monitoring",
            ])
        // [END custom_event_objc]

        self.imageAssessment.isHighlighted = false
        self.imageShop.isHighlighted = false
        self.imageMonitoring.isHighlighted = true
        self.imageRecords.isHighlighted = false
        self.lableAssessment.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewMonitoring.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.riskVC != nil{
            self.riskVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.shopsVC != nil{
            self.shopsVC.view .removeFromSuperview();
        }
        if self.recordsVC != nil{
            self.recordsVC.view .removeFromSuperview();
        }
        self.updateMonitoringView()
    }
    @IBAction func RecordsClick(_ sender: Any) {
        // [START custom_event_objc]
        Analytics.logEvent("Records", parameters: [
            "type": "iOS",
            "tab": "Records",
            ])
        // [END custom_event_objc]

        self.imageAssessment.isHighlighted = false
        self.imageShop.isHighlighted = false
        self.imageMonitoring.isHighlighted = false
        self.imageRecords.isHighlighted = false
        self.lableAssessment.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewRecords.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.riskVC != nil{
            self.riskVC.view .removeFromSuperview();
        }
        if self.shopsVC != nil{
            self.shopsVC.view .removeFromSuperview();
        }
        if self.recordsVC != nil{
            self.recordsVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.recordsVC = RecordsViewController(nibName : "RecordsViewController" , bundle : nil)
        self.recordsVC.delegate = self
        self.recordsVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.recordsVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
    }
    @IBAction func RiskClick(_ sender: Any) {
        
        // [START custom_event_objc]
        Analytics.logEvent("Risk", parameters: [
            "type": "iOS",
            "tab": "Risk",
            ])
        // [END custom_event_objc]

        self.imageAssessment.isHighlighted = false
        self.imageShop.isHighlighted = false
        self.imageMonitoring.isHighlighted = false
        self.imageRecords.isHighlighted = false
        self.lableAssessment.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
       
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewRisk.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.riskVC != nil{
            self.riskVC.view .removeFromSuperview();
        }
        if self.shopsVC != nil{
            self.shopsVC.view .removeFromSuperview();
        }
        if self.recordsVC != nil{
            self.recordsVC.view .removeFromSuperview();
        }
        
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.riskVC = RiskViewController(nibName : "RiskViewController" , bundle : nil)
        self.riskVC.delegate = self
        self.riskVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.riskVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.MonitoringClick("")
       // self.tableMonitoring.addSubview(self.refreshControl)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func updateMonitoringView() {
        if(AppManager.sharedInstance.MonitoringStartFlag() == ""){
            self.viewStartMonitoring.isHidden = false
            self.viewMonitoringSummary.isHidden = true
            
            let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
            
            self.scrollMain.setWidth(PageWidth)
            self.scrollMain.contentSize = CGSize(width: PageWidth, height: 350)
            
            AppManager.sharedInstance.viewShadow(MainView: self.viewSystolic)
            AppManager.sharedInstance.viewShadow(MainView: self.viewDiastolic)
            AppManager.sharedInstance.viewShadow(MainView: self.viewHeartRate)
            AppManager.sharedInstance.viewShadow(MainView: self.viewWeight)
            AppManager.sharedInstance.viewShadow(MainView: self.viewHoursSlept)
            AppManager.sharedInstance.viewShadow(MainView: self.viewGlucose)
            AppManager.sharedInstance.viewShadow(MainView: self.viewSport)
            AppManager.sharedInstance.viewShadow(MainView: self.viewActivity)
            
            self.buttonStart.layer.cornerRadius = 6.0
            self.buttonStart.layer.borderWidth = 1
            self.buttonStart.layer.borderColor = UIColor(red: 42.0/255, green: 184.0/255, blue: 181.0/255, alpha: 1.0).cgColor
            self.labelMessage.text = "Healthy behaviour leads to healthy life. Self Monitoring is probably the most important mechanism in changing any behaviour. It helps in identifying health risks before its too late! \n\nAdd Vital information from your wearable or medical devices."
            
            self.fetchSummaryDetail()
        }
        else {
            self.fetchUserDetail()
            self.viewStartMonitoring.isHidden = true
            self.viewMonitoringSummary.isHidden = false
            
            self.tableMonitoring.register(UINib(nibName: "CellMonitoring", bundle: nil), forCellReuseIdentifier: "CellMonitoringID")
            self.monitoringArray = [["Image": "blood-pressure.png", "Title": "Blood Pressure"], ["Image": "blood-glucose.png", "Title": "Blood Glucose"], ["Image": "weight.png", "Title": "Weight"], ["Image": "sleep.png", "Title": "Sleep"], ["Image": "activity.png", "Title": "Activity"], ["Image": "sports.png", "Title": "Sports"]]
            self.tableMonitoring.reloadData()
        }
    }
    func fetchSummaryDetail () {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let address = String(format: "%@user/%@/summary",kAPIDOMAIN,AppManager.sharedInstance.userName()) as String
        
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                print(jsonObject)
                if(self.refreshControl.isRefreshing == true ) {
                    self.refreshControl.endRefreshing()
                }
                if jsonObject["data"] != nil {
                    let userDictionary : NSDictionary = jsonObject["data"] as! NSDictionary
                    if(userDictionary.allKeys.count != 0){
                        let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: userDictionary as [NSObject : AnyObject] as NSDictionary)
                        let isSuccess : Bool = self.checkValue(detailDic: dictionaryDetails)
                        if(isSuccess){
                            self.viewEmpty.isHidden = true
                            self.scrollMain.isHidden = false
                            self.updateValue(detailDic: dictionaryDetails)
                        }
                        else {
                           // self.viewEmpty.isHidden = false
                            //self.scrollMain.isHidden = true
                            self.viewEmpty.isHidden = true
                            self.scrollMain.isHidden = false
                            self.updateValue(detailDic: dictionaryDetails)
                        }
                    }
                    else {
//                        self.viewEmpty.isHidden = false
//                        self.scrollMain.isHidden = true
                        let dictionaryDetails: NSMutableDictionary = NSMutableDictionary()
                        self.viewEmpty.isHidden = true
                        self.scrollMain.isHidden = false
                        self.updateValue(detailDic: dictionaryDetails)
                    }
                }
                else {
//                    self.viewEmpty.isHidden = false
//                    self.scrollMain.isHidden = true
                    let dictionaryDetails: NSMutableDictionary = NSMutableDictionary()
                    self.viewEmpty.isHidden = true
                    self.scrollMain.isHidden = false
                    self.updateValue(detailDic: dictionaryDetails)
                }
            } catch let error {
                print(error)
            }
        }
    }
    func updateValue(detailDic : NSMutableDictionary) {
        
        self.labelSystolicScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "systolic") == "") ?  "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "systolic")
        
        self.labelDiastolicScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "diastolic") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "diastolic")
        
        self.labelHeartRateScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "heartRate") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "heartRate")
        
        self.labelWeightScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "weight") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "weight")
        
        self.labelSleptScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "hoursSlept") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "hoursSlept")
        
        self.labelGlucoseScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "bloodGlucose") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "bloodGlucose")
        
        self.labelSportScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "sportsCalories") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "sportsCalories")
        
        self.labelActivityScore.text = (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "activityCalories") == "") ? "0" : AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "activityCalories")
        
    }
    func checkValue(detailDic : NSMutableDictionary) ->Bool {
        if ((AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "systolic") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "diastolic") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "heartRate") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "weight") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "hoursSlept") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "bloodGlucose") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "sportsCalories") == "") && (AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "activityCalories") == "")) {
            return false
        }
        return true
    }
    @IBAction func startMonitoring(_ sender : Any) {
        let UserDefaultsDetails = UserDefaults.standard
        UserDefaultsDetails.setValue("Y" , forKey: "MonitoringStartFlag")
        UserDefaultsDetails.synchronize()
        
        self.viewStartMonitoring.isHidden = true
        self.viewMonitoringSummary.isHidden = false
        self.tableMonitoring.register(UINib(nibName: "CellMonitoring", bundle: nil), forCellReuseIdentifier: "CellMonitoringID")
        self.monitoringArray = [["Image": "blood-pressure.png", "Title": "Blood Pressure"], ["Image": "blood-glucose.png", "Title": "Blood Glucose"], ["Image": "weight.png", "Title": "Weight"], ["Image": "sleep.png", "Title": "Sleep"], ["Image": "activity.png", "Title": "Activity"], ["Image": "sports.png", "Title": "Sports"]]
        self.tableMonitoring.reloadData()
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.monitoringArray.count != 0 {
            let Count : CGFloat = CGFloat(self.monitoringArray.count)
            let f: CGFloat = Count/2
            let roundedVal = Int(ceil(Double(f)))
            return roundedVal
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135;
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Count : CGFloat = CGFloat(self.monitoringArray.count)
        let f: CGFloat = Count/2
        let roundedVal = Int(ceil(Double(f)))
        if indexPath.row < roundedVal {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellMonitoringID", for: indexPath as IndexPath) as! CellMonitoring
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            
            for i in 0...1 {
                let MainView: UIView = (cell.ViewInner[i]);
                MainView.isHidden = true;
            }
            var integerCount: Int = 1
            var indexcount: Int = 0
            for integerArrayIndex in Int(indexPath.row) * kItemsPerCell ..< min(self.monitoringArray.count, (indexPath.row * kItemsPerCell) + kItemsPerCell) {
                let MainView: UIView = (cell.ViewInner[indexcount])
                let lblTitle: UILabel = (cell.lblName[indexcount])
                let ImageIcon: UIImageView = (cell.IconImage[indexcount])
                let btnSelect: UIButton = (cell.BtnSelect[indexcount])
                
                MainView.isHidden = false
                MainView.layer.cornerRadius = 4.0
                MainView.layer.borderWidth = 1;
                MainView.layer.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.000).cgColor
                
                lblTitle.text = self.monitoringArray[integerArrayIndex]["Title"]
                ImageIcon.image = UIImage(named: self.monitoringArray[integerArrayIndex]["Image"]!)
                
                btnSelect.tag = integerArrayIndex
                btnSelect.addTarget(self, action: #selector(MonitoringViewController.monitoringSelectClick(_:)), for: .touchUpInside)
                
                integerCount += 1
                indexcount += 1
            }
            return cell
        }
        return loadingCell()
    }
    func loadingCell() -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = cell.center
        activityIndicator.tintColor = UIColor(red: 0.089, green: 0.391, blue: 0.750, alpha: 1.000)
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        cell.tag = 564
        return cell
    }
    func monitoringSelectClick (_ sender: UIButton) {
        let MonitoringDetailVC : MonitoringDetailViewController = MonitoringDetailViewController(nibName : "MonitoringDetailViewController" , bundle : nil)
        MonitoringDetailVC.delegate = self
        MonitoringDetailVC.titleString = self.monitoringArray[sender.tag]["Title"]! as NSString
        self.navigationController?.pushViewController(MonitoringDetailVC, animated: true)
    }
    func fetchUserDetail () {
        
        let address = String(format: "%@user/%@",kAPIDOMAIN,AppManager.sharedInstance.userName()) as String
        
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                    if jsonObject["data"] != nil {
                        let userArray : NSArray = jsonObject["data"] as! NSArray
                        print(userArray)
                        if(userArray.count != 0){
                            let detailDic : NSDictionary = userArray[0] as! NSDictionary
                            let stringDOB : String = AppManager.sharedInstance.conertDateToString(Date: AppManager.sharedInstance.dateFromMilliseconds(ms: detailDic["dataOfBirth"] as! NSNumber), formate: "yyyy-MM-dd")
                            
                            let UserDefaultsDetails = UserDefaults.standard
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.convertAge(birthDay: AppManager.sharedInstance.dateFromMilliseconds(ms: detailDic["dataOfBirth"] as! NSNumber)) , forKey: "userage")
                            UserDefaultsDetails.setValue(stringDOB as String , forKey: "dataOfBirth")
                            UserDefaultsDetails.setValue(detailDic["email"] as? String , forKey: "email")
                            UserDefaultsDetails.setValue(detailDic["gender"] as? String , forKey: "gender")
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic as! NSMutableDictionary, key: "height") as String , forKey: "height")
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic as! NSMutableDictionary, key: "weight") as String , forKey: "weight")
                            UserDefaultsDetails.setValue(detailDic["govtId"] as? String , forKey: "govtId")
                            UserDefaultsDetails.setValue(detailDic["firstName"] as? String , forKey: "firstName")
                            UserDefaultsDetails.setValue(detailDic["lastname"] as? String , forKey: "lastname")
                            UserDefaultsDetails.setValue(detailDic["country"] as? String , forKey: "country")
                            UserDefaultsDetails.setValue(detailDic["city"] as? String , forKey: "city")
                            UserDefaultsDetails.setValue(detailDic["state"] as? String , forKey: "state")
                            UserDefaultsDetails.setValue(detailDic["postalCode"] as? String , forKey: "postalCode")
                            UserDefaultsDetails.setValue(detailDic["mobile"] as? String , forKey: "mobile")
                            UserDefaultsDetails.setValue(detailDic["appVersion"] as? String , forKey: "appVersion")
                            UserDefaultsDetails.setValue(detailDic["referralCode"] as? String , forKey: "referralCode")
                            UserDefaultsDetails.setValue(detailDic["versionNo"] as? String , forKey: "versionNo")
                            UserDefaultsDetails.synchronize()
                            if(AppDelegate.appDelegate().LeftVC != nil){
                                AppDelegate.appDelegate().LeftVC.UpdateDetail()
                            }
                        }
                    }
                } catch let error {
                    print(error)
                }
        }
    }
    
    // MARK:- Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(HistoryViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self .fetchSummaryDetail()
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
extension StartMonitoringViewController : SlideMenuControllerDelegate {
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
