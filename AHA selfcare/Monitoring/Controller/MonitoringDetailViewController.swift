//
//  MonitoringDetailViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 10/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UICircularProgressRing

class MonitoringDetailViewController: UIViewController {

    var delegate : AnyObject?
    var titleString : NSString = ""
    var historyVC : HistoryViewController!
    var AddDataVC : AddDataViewController!
    var startDate : String = ""
    var endDate : String = ""
    var historyArray = [JSON] ()
    var arraySystolic : NSMutableArray = []
    var arrayDiastolic : NSMutableArray = []
    var arrayHeartRate : NSMutableArray = []
    var DetailDictionaries : NSMutableDictionary = NSMutableDictionary()
    var stringType : String = ""

    var lineChartView : YZLineChartView!
    
    @IBOutlet weak var Maxring: UILabel!
    @IBOutlet weak var Minring: UILabel!
    @IBOutlet weak var Averagering: UILabel!
    @IBOutlet weak var Meanring: UILabel!

    @IBOutlet weak var scrollViewMain : UIScrollView!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var viewInner : UIView!
    @IBOutlet weak var labelEmpty : UILabel!

    @IBOutlet weak var viewSummary : UIView!
    @IBOutlet weak var viewHistory : UIView!
    @IBOutlet weak var viewAddData : UIView!
    
    @IBOutlet weak var imageSummary : UIImageView!
    @IBOutlet weak var imageHistory : UIImageView!
    @IBOutlet weak var imageAddData : UIImageView!
    
    @IBOutlet weak var lableSummary : UILabel!
    @IBOutlet weak var lableHistory : UILabel!
    @IBOutlet weak var lableAddData : UILabel!
    
    @IBOutlet weak var buttonSummary : UIButton!
    @IBOutlet weak var buttonHistory : UIButton!
    @IBOutlet weak var buttonAddData : UIButton!
    
    @IBOutlet weak var ViewBottom : UIView!
    @IBOutlet weak var lableLine : UILabel!
    
    @IBOutlet weak var buttonDaily : UIButton!
    @IBOutlet weak var buttonWeekly : UIButton!
    @IBOutlet weak var buttonMonthly : UIButton!
    
    @IBOutlet weak var lableSystolic : UILabel!
    @IBOutlet weak var lableDiastolic : UILabel!
    @IBOutlet weak var lableHeartRate : UILabel!

    @IBOutlet weak var buttonSystolic : UIButton!
    @IBOutlet weak var buttonDiastolic : UIButton!
    @IBOutlet weak var buttonHeartRate : UIButton!

    @IBOutlet weak var viewSystolic : UIView!
    @IBOutlet weak var viewDiastolic : UIView!
    @IBOutlet weak var viewHeartRate : UIView!

    @IBOutlet weak var lableSystolic1 : UILabel!
    @IBOutlet weak var lableDiastolic1 : UILabel!
    @IBOutlet weak var lableHeartRate1 : UILabel!

    @IBOutlet weak var viewMaxBox : UIView!
    @IBOutlet weak var viewMinBox : UIView!
    @IBOutlet weak var viewAverageBox : UIView!
    @IBOutlet weak var viewDeviationBox : UIView!

    @IBOutlet weak var viewSystolicSelect : UIView!
    @IBOutlet weak var viewDiastolicSelect : UIView!
    @IBOutlet weak var viewHeartRateSelect : UIView!
    
    @IBOutlet weak var viewMainBox : UIView!
    @IBOutlet weak var lableLine2 : UILabel!

    @IBOutlet weak var viewBox : UIView!
    @IBOutlet weak var labelDisplyDate : UILabel!
    
    @IBOutlet weak var lableDot1 : UILabel!
    @IBOutlet weak var lableDot2 : UILabel!
    @IBOutlet weak var lableDot3 : UILabel!

    var PageWidth : CGFloat = 0.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func SummaryClick(_ sender: Any) {
        self.imageSummary.isHighlighted = true
        self.imageHistory.isHighlighted = false
        self.imageAddData.isHighlighted = false
        
        self.lableSummary.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableHistory.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableAddData.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewSummary.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        if self.historyVC != nil{
            self.historyVC.view .removeFromSuperview();
        }
        if self.AddDataVC != nil{
            self.AddDataVC.view .removeFromSuperview();
        }
        self.monthlyClick("")
    }
    @IBAction func HistoryClick(_ sender: Any) {
        self.imageSummary.isHighlighted = false
        self.imageHistory.isHighlighted = true
        self.imageAddData.isHighlighted = false

        self.lableSummary.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableHistory.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableAddData.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewHistory.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        
        if self.AddDataVC != nil{
            self.AddDataVC.view .removeFromSuperview();
        }
        self.historyVC = HistoryViewController(nibName : "HistoryViewController" , bundle : nil)
        self.historyVC.delegate = self
        self.historyVC.moduleType = self.titleString as String
        self.historyVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.historyVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
    }
    @IBAction func AddDataClick(_ sender: Any) {
        self.imageSummary.isHighlighted = false
        self.imageHistory.isHighlighted = false
        self.imageAddData.isHighlighted = true

        self.lableSummary.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableHistory.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableAddData.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewAddData.minx())
        }, completion: {(finished: Bool) -> Void in
        })
        if self.historyVC != nil{
            self.historyVC.view .removeFromSuperview();
        }
        
        self.AddDataVC = AddDataViewController(nibName : "AddDataViewController" , bundle : nil)
        self.AddDataVC.delegate = self
        self.AddDataVC.moduleType = self.titleString as String
        self.AddDataVC.titleString = self.titleString as NSString
        self.AddDataVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.AddDataVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
        
    }
    // Data Generation
    private func generateRandomData(numberOfItems: Int, max: Double) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(arc4random() % 100 < 10) {
                randomNumber *= 3
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    @IBAction func nextClick(_ sender : Any){
        if(self.stringType == "daily"){
            let CurrentDate : Date = AppManager.sharedInstance.ConertDateStringToDate(Date: self.startDate, Format: "YYYY-MM-dd")
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: CurrentDate)
            self.startDate = AppManager.sharedInstance.conertDateToString(Date: tomorrow! as NSDate, formate: "YYYY-MM-dd")
            print(self.startDate)
            self.labelDisplyDate.text = self.startDate
        }
        else if(self.stringType == "weekly"){
            let CurrentDate : Date = AppManager.sharedInstance.ConertDateStringToDate(Date: self.startDate, Format: "YYYY-MM-dd")
            let next7day = Calendar.current.date(byAdding: .day, value: 6, to: CurrentDate)
            self.startDate = AppManager.sharedInstance.conertDateToString(Date: next7day! as NSDate, formate: "YYYY-MM-dd")
            print(self.startDate)
            self.labelDisplyDate.text = self.startDate
        }
        else if(self.stringType == "monthly"){
            let CurrentDate : Date = AppManager.sharedInstance.ConertDateStringToDate(Date: self.startDate, Format: "YYYY-MM-dd")
            let NextMonth : Date = self.startOfMonth(currentDate: CurrentDate)!
            self.startDate = AppManager.sharedInstance.conertDateToString(Date: NextMonth as NSDate, formate: "YYYY-MM-dd")
            print(self.startDate)
            self.labelDisplyDate.text = self.startDate
        }
        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchSummaryDetail()
        self.fetchDetailDetail()
    }
    @IBAction func previousClick(_ sender : Any){
        if(self.stringType == "daily"){
            let CurrentDate : Date = AppManager.sharedInstance.ConertDateStringToDate(Date: self.startDate, Format: "YYYY-MM-dd")
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: CurrentDate)
            self.startDate = AppManager.sharedInstance.conertDateToString(Date: tomorrow! as NSDate, formate: "YYYY-MM-dd")
            print(self.startDate)
            self.labelDisplyDate.text = self.startDate
        }
        else if(self.stringType == "weekly"){
            let CurrentDate : Date = AppManager.sharedInstance.ConertDateStringToDate(Date: self.startDate, Format: "YYYY-MM-dd")
            let next7day = Calendar.current.date(byAdding: .day, value: -6, to: CurrentDate)
            self.startDate = AppManager.sharedInstance.conertDateToString(Date: next7day! as NSDate, formate: "YYYY-MM-dd")
            print(self.startDate)
            self.labelDisplyDate.text = self.startDate
        }
        else if(self.stringType == "monthly"){
            let CurrentDate : Date = AppManager.sharedInstance.ConertDateStringToDate(Date: self.startDate, Format: "YYYY-MM-dd")
            let NextMonth : Date = self.getPreviousMonth(currentDate: CurrentDate)!
            self.startDate = AppManager.sharedInstance.conertDateToString(Date: NextMonth as NSDate, formate: "YYYY-MM-dd")
            print(self.startDate)
            self.labelDisplyDate.text = self.startDate
        }
        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchSummaryDetail()
        self.fetchDetailDetail()
    }
    func getPreviousMonth(currentDate : Date) -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
    }
    func startOfMonth(currentDate : Date) -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
    }
    @IBAction func dailyClick(_ sender : Any){
        
        self.stringType = "daily"
        self.startDate = AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "YYYY-MM-dd")
        print(self.startDate)
        self.labelDisplyDate.text = self.startDate

        self.lableDot1.isHidden = false
        self.lableDot2.isHidden = true
        self.lableDot3.isHidden = true
        
        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchSummaryDetail()
        self.fetchDetailDetail()
        
        self.lableSystolic1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        
        self.lableLine2.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                self.lableLine2.setX(self.viewSystolicSelect.minx())
            }else {
                self.lableLine2.setX(self.viewDiastolicSelect.minx())
            }
        }, completion: {(finished: Bool) -> Void in
        })

        
    }
    @IBAction func weeklyClick(_ sender : Any){
        self.stringType = "weekly"
        self.startDate = AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "YYYY-MM-dd")
        print(self.startDate)
        self.labelDisplyDate.text = self.startDate

        self.lableDot1.isHidden = true
        self.lableDot2.isHidden = false
        self.lableDot3.isHidden = true

        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchSummaryDetail()
        self.fetchDetailDetail()
        
        self.lableSystolic1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        
        self.lableLine2.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                self.lableLine2.setX(self.viewSystolicSelect.minx())
            }else {
                self.lableLine2.setX(self.viewDiastolicSelect.minx())
            }
        }, completion: {(finished: Bool) -> Void in
        })

    }
    @IBAction func monthlyClick(_ sender : Any){
        self.stringType = "monthly"
        self.startDate = AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "YYYY-MM-dd")
        print(self.startDate)
        self.labelDisplyDate.text = self.startDate
        
        self.lableDot1.isHidden = true
        self.lableDot2.isHidden = true
        self.lableDot3.isHidden = false

        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchSummaryDetail()
        self.fetchDetailDetail()
        
        self.lableSystolic1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        
        self.lableLine2.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                self.lableLine2.setX(self.viewSystolicSelect.minx())
            }else {
                self.lableLine2.setX(self.viewDiastolicSelect.minx())
            }
        }, completion: {(finished: Bool) -> Void in
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.PageWidth = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.scrollViewMain.contentSize = CGSize(width: PageWidth, height: 550)
        self.viewInner.setWidth(self.PageWidth)
        
        self.lableLine.setWidth(self.viewSummary.width())
        self.lableLine.setX(self.viewSummary.minx())

        self.lableLine2.setWidth(self.viewSystolicSelect.width())
        self.lableLine2.setX(self.viewSystolicSelect.minx())

        self.labelTitle.text = "Summary"
        
        self.viewSystolic.isHidden = true
        self.viewDiastolic.isHidden = true
        self.viewHeartRate.isHidden = true

        self.viewSystolicSelect.isHidden = true
        self.viewDiastolicSelect.isHidden = true
        self.viewHeartRateSelect.isHidden = true
        
        self.lableSystolic1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)

        self.buttonSystolic.isUserInteractionEnabled = false
        self.buttonDiastolic.isUserInteractionEnabled = false
        self.buttonHeartRate.isUserInteractionEnabled = false

        if(self.titleString.isEqual(to: "Blood Pressure")) {
            self.buttonSystolic.isUserInteractionEnabled = true
            self.buttonDiastolic.isUserInteractionEnabled = true
            self.buttonHeartRate.isUserInteractionEnabled = true

            self.viewSystolic.isHidden = false
            self.viewDiastolic.isHidden = false
            self.viewHeartRate.isHidden = false
            self.lableSystolic.text = "Systolic"
            self.lableDiastolic.text = "Diastolic"
            self.lableHeartRate.text = "Heart Rate"

            self.lableSystolic1.text = "SYSTOLIC"
            self.lableDiastolic1.text = "DIASTOLIC"
            self.lableHeartRate1.text = "HEART RATE"
            self.viewSystolicSelect.isHidden = false
            self.viewDiastolicSelect.isHidden = false
            self.viewHeartRateSelect.isHidden = false
        }
        else if(self.titleString.isEqual(to: "Blood Glucose")) {
            self.viewSystolic.isHidden = false
            self.lableSystolic.text = "Blood Glucose"
            self.lableDiastolic1.text = "BLOOD GLUCOSE"
            self.viewDiastolicSelect.isHidden = false
        }
        else if(self.titleString.isEqual(to: "Weight")) {
            self.viewSystolic.isHidden = false
            self.viewDiastolic.isHidden = false
            self.lableDiastolic1.text = "WEIGHT"
            
            self.lableSystolic.text = "Weight(Kg)"
            self.lableDiastolic.text = "BMI(Kg/m^2)"
            self.viewDiastolicSelect.isHidden = false

        }
        else if(self.titleString.isEqual(to: "Sleep")) {
            self.viewSystolic.isHidden = false
            self.lableSystolic.text = "Hours Slept"
            self.lableDiastolic1.text = "HOURS SLEPT"
            self.viewDiastolicSelect.isHidden = false
        }
        else if(self.titleString.isEqual(to: "Activity")) {
            self.viewSystolic.isHidden = false
            self.viewDiastolic.isHidden = false
            
            self.lableSystolic.text = "Distance Travelled"
            self.lableDiastolic.text = "Number of Steps"
            self.lableDiastolic1.text = "STEPS"
            self.viewDiastolicSelect.isHidden = false
        }
        else if(self.titleString.isEqual(to: "Sports")) {
            self.viewSystolic.isHidden = false
            self.lableSystolic.text = "Calories"
            self.lableDiastolic1.text = "CALORIES"
            self.viewDiastolicSelect.isHidden = false
        }

        AppManager.sharedInstance.viewShadow(MainView: self.viewMaxBox)
        AppManager.sharedInstance.viewShadow(MainView: self.viewMinBox)
        AppManager.sharedInstance.viewShadow(MainView: self.viewAverageBox)
        AppManager.sharedInstance.viewShadow(MainView: self.viewDeviationBox)

        self.viewMainBox.layer.cornerRadius = 5.0
        AppManager.sharedInstance.viewShadow(MainView: self.viewMainBox)

        self.ViewBottom.layer.shadowColor = UIColor.gray.cgColor
        self.ViewBottom.layer.shadowOpacity = 0.3
        self.ViewBottom.layer.shadowRadius = 1.0
        self.ViewBottom.layer.shadowOffset = CGSize(width: 2.0, height: -1.3)
//        self.stringType = "daily"
        self.stringType = "weekly"
//        self.dailyClick("")
        self.weeklyClick("")
    }
    func fetchSummaryDetail () {
        //scphr/public/v1.0/scphr/monitoring/{vital}/{frequency}/{userId}?currDate={current
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let address = String(format: "%@monitoring/%@/%@/%@?currDate=%@",kAPIDOMAIN,self.setUrl(),self.stringType,AppManager.sharedInstance.userName(),self.startDate) as String
        
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                
//                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! Any
//                    print(jsonObject)
//                    
//                } catch let error {
//                    print(error)
//                }
                self.historyArray.removeAll()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                let jData = JSON(data: response.data!)
                self.historyArray = jData.arrayValue
                print(self.historyArray)
                if(self.historyArray.count != 0){
                    self.labelEmpty.isHidden = true
                    self.viewBox.isHidden = false
                    self.viewMainBox.isHidden = false
                    self.updateValue()
                }
                else {
                    self.labelEmpty.isHidden = false
                    self.viewBox.isHidden = true
                    self.viewMainBox.isHidden = true
                }
        }
    }
    func fetchDetailDetail () {
        
        self.Maxring.text = "0"
        self.Minring.text = "0"
        self.Averagering.text = "0"
        self.Meanring.text = "0"

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let address = String(format: "%@monitoring/stats/%@/%@/%@?currDate=%@",kAPIDOMAIN,self.setUrl(),self.stringType,AppManager.sharedInstance.userName(),self.startDate,self.endDate) as String
        
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                do {
                    let dictonary = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers)
                    print(dictonary)
                    let ditailDic :NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: dictonary as! NSDictionary)
                    if ditailDic["data"] != nil {
                        self.DetailDictionaries = AppManager.sharedInstance.checkNullValue(DetailDictionary: ditailDic["data"] as! NSMutableDictionary)
                        if(self.titleString.isEqual(to: "Blood Pressure")) {
                            self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxSystolic")
                            self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minSystolic")
                            self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgSystolic")
                            self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevSystolic")
                        }
                        else if(self.titleString.isEqual(to: "Blood Glucose")) {
                            self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxGlucose")
                            self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minGlucose")
                            self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgGlucose")
                            self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "abvThreshGlucose")
                        }
                        else if(self.titleString.isEqual(to: "Weight")) {
                            self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxWeight")
                            self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minWeight")
                            self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgWeight")
                            self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevWeight")
                        }
                        else if(self.titleString.isEqual(to: "Sleep")) {
                            self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxSleep")
                            self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minSleep")
                            self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgSleep")
                            self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevSleep")
                        }
                        else if(self.titleString.isEqual(to: "Activity")) {
                            self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxActivity")
                            self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minActivity")
                            self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgActivity")
                            self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevActivity")
                        }
                        else if(self.titleString.isEqual(to: "Sports")) {
                            self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxCalories")
                            self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minCalories")
                            self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgCalories")
                            self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevCalories")
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
        }
    }
    func updateValue() {
        let array : NSMutableArray = []
        let arrayKey : NSMutableArray = []

        self.arraySystolic.removeAllObjects()
        self.arrayDiastolic.removeAllObjects()
        self.arrayHeartRate.removeAllObjects()

        let arraySystolicNumber : NSMutableArray = []
        let arrayDiastolicNumber : NSMutableArray = []
        let arrayHeartRateNumber : NSMutableArray = []

        for Index in 0..<self.historyArray.count {
            let keyString = String(Index+1)
            arrayKey.add(keyString)
            let DateString : NSString = AppManager.sharedInstance.conertDateStringToString(Date: self.historyArray[Index][self.setKeyName()].stringValue, Format: "yyyy-MM-dd") as NSString
            array.add(DateString)
            
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                arraySystolic.add(self.historyArray[Index]["systolic"].stringValue)
                arraySystolicNumber.add(self.historyArray[Index]["systolic"].intValue)

                arrayDiastolic.add(self.historyArray[Index]["diastolic"].stringValue)
                arrayDiastolicNumber.add(self.historyArray[Index]["diastolic"].intValue)

                arrayHeartRate.add(self.historyArray[Index]["heartRate"].stringValue)
                arrayHeartRateNumber.add(self.historyArray[Index]["heartRate"].intValue)
            }
            else if(self.titleString.isEqual(to: "Blood Glucose")) {
                arraySystolic.add(self.historyArray[Index]["bloodGlucoseValue"].stringValue)
                arraySystolicNumber.add(self.historyArray[Index]["bloodGlucoseValue"].intValue)
            }
            else if(self.titleString.isEqual(to: "Weight")) {
                arraySystolic.add(self.historyArray[Index]["wgt"].stringValue)
                arraySystolicNumber.add(self.historyArray[Index]["wgt"].intValue)
                
                arrayDiastolic.add(self.historyArray[Index]["bmi"].stringValue)
                arrayDiastolicNumber.add(self.historyArray[Index]["bmi"].intValue)
            }
            else if(self.titleString.isEqual(to: "Sleep")) {
                arraySystolic.add(self.historyArray[Index]["hoursSlept"].stringValue)
                arraySystolicNumber.add(self.historyArray[Index]["hoursSlept"].intValue)
            }
            else if(self.titleString.isEqual(to: "Activity")) {
                arraySystolic.add(self.historyArray[Index]["distanceTraveled"].stringValue)
                arraySystolicNumber.add(self.historyArray[Index]["distanceTraveled"].stringValue)

                arrayDiastolic.add(self.historyArray[Index]["steps"].stringValue)
                arrayDiastolicNumber.add(self.historyArray[Index]["steps"].intValue)
            }
            else if(self.titleString.isEqual(to: "Sports")) {
                arraySystolic.add(self.historyArray[Index]["calories"].stringValue)
                arraySystolicNumber.add(self.historyArray[Index]["calories"].intValue)
            }
        }

        print(self.arraySystolic)
        
        if(self.arraySystolic.count != 0) {
            self.lineChartView = YZLineChartView(frame: CGRect(x:10, y: 87, width: self.PageWidth - 20, height: 210))
            self.lineChartView.axisColor = UIColor.black.withAlphaComponent(0.3)
            self.lineChartView.marginInset = UIEdgeInsetsMake(20.0, 30.0, 40.0, 30.0)
            self.lineChartView.gridStep = 6
            self.lineChartView.drawsDataPoints = true
            self.lineChartView.backgroundColor = UIColor.clear
            self.lineChartView.isBottomHide = true
            self.scrollViewMain.addSubview(self.lineChartView)
            self.lineChartView.totalCount = Int32(self.arraySystolic.count);
            
            let lineArray : NSMutableArray = []
            if(self.arraySystolic.count != 0){
                let lineChart1 = YZLineChartModel()
                lineChart1.title = "title1"
                lineChart1.data = self.arraySystolic as! [Any]
                lineChart1.lineColor = UIColor(red: 231.0/255, green: 122.0/255, blue: 4.0/255, alpha: CGFloat(1))
                lineArray.add(lineChart1)
            }
            if(self.arrayDiastolic.count != 0){
                let lineChart2 = YZLineChartModel()
                lineChart2.title = "title1"
                lineChart2.data = self.arrayDiastolic as! [Any]
                lineChart2.lineColor = UIColor(red: 228.0/255, green: 221.0/255, blue: 1.0/255, alpha: CGFloat(1))
                lineArray.add(lineChart2)
            }
            if(self.arrayHeartRate.count != 0){
                let lineChart3 = YZLineChartModel()
                lineChart3.title = "title1"
                lineChart3.data = self.arrayHeartRate as! [Any]
                lineChart3.lineColor = UIColor(red: 2.0/255, green: 208.0/255, blue: 42.0/255, alpha: CGFloat(1))
                lineArray.add(lineChart3)
            }
            if(lineArray.count != 0){
                self.lineChartView.reDrawLineChart(withDimensionData: array as! [Any], chartData: lineArray as! [Any])
            }
        }
    }
    func emptyKey()-> NSMutableArray {
        let emptyarray : NSMutableArray = []
        emptyarray.add("Jan")
        emptyarray.add("Feb")
        emptyarray.add("Mar")
        emptyarray.add("Api")
        emptyarray.add("May")
        emptyarray.add("Jun")
        emptyarray.add("Jul")
        emptyarray.add("Aug")
        return emptyarray
    }
    @IBAction func ChageAverage1Click(_ sender: Any) {
        
        self.Maxring.text = "0"
        self.Minring.text = "0"
        self.Averagering.text = "0"
        self.Meanring.text = "0"

        let total = self.DetailDictionaries.allKeys.count
        if(total != 0){
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxSystolic")
                self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minSystolic")
                self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgSystolic")
                self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevSystolic")
            }
            else if(self.titleString.isEqual(to: "Blood Glucose")) {
                self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxGlucose")
                self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minGlucose")
                self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgGlucose")
                self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "abvThreshGlucose")
            }
        }
        
        self.lableSystolic1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)

        self.lableLine2.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine2.setX(self.viewSystolicSelect.minx())
        }, completion: {(finished: Bool) -> Void in
        })
    }
    @IBAction func ChageAverage2Click(_ sender: Any) {
        
        self.Maxring.text = "0"
        self.Minring.text = "0"
        self.Averagering.text = "0"
        self.Meanring.text = "0"
        let total = self.DetailDictionaries.allKeys.count
        if(total != 0){
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxDiastolic")
                self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minDiastolic")
                self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgDiastolic")
                self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevDiastolic")
            }
        }
       
        self.lableSystolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)

        self.lableLine2.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine2.setX(self.viewDiastolicSelect.minx())
        }, completion: {(finished: Bool) -> Void in
        })
    }
    @IBAction func ChageAverage3Click(_ sender: Any) {
        
        self.Maxring.text = "0"
        self.Minring.text = "0"
        self.Averagering.text = "0"
        self.Meanring.text = "0"
        let total = self.DetailDictionaries.allKeys.count
        if(total != 0){
            if(self.titleString.isEqual(to: "Blood Pressure")) {
                self.Maxring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "maxHeartRate")
                self.Minring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "minHeartRate")
                self.Averagering.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "avgHeartRate")
                self.Meanring.text = AppManager.sharedInstance.checkNumberString(DetailDictionary: self.DetailDictionaries, key: "meanDevHeartRate")
            }

        }
        self.lableSystolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableDiastolic1.textColor = UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0)
        self.lableHeartRate1.textColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.lableLine2.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine2.setX(self.viewHeartRateSelect.minx())
        }, completion: {(finished: Bool) -> Void in
        })
    }
    func setKeyName() -> String {
        var KeyString : String = ""
        if(self.titleString == "Sports"){
            KeyString = "sportStartTime"
        }
        else {
            KeyString = "measurementDate"
        }
        return KeyString
    }
    func updateBottonViewData(detailDic : NSMutableDictionary) {
        
        
        
    }
    func setUrl() -> String {
        let urlString = self.titleString.replacingOccurrences(of: " ", with: "")
        return urlString
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
