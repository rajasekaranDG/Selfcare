//
//  DiabetesViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 26/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire

class DiabetesViewController: UIViewController {
    
    var delegate : AnyObject?
    var startDate : String = ""
    var endDate : String = ""
    var arrayOfItems : NSMutableArray = []
    
    @IBOutlet weak var viewMessage : UIView!
    @IBOutlet weak var labelMessage : UILabel!
    @IBOutlet weak var ViewInner : UIView!
    @IBOutlet weak var labelEmpty : UILabel!
    @IBOutlet weak var buttonStart : UIButton!

    var DiabetesQuestionVC : DiabetesQuestionViewController!
    var lineChartView : YZLineChartView!
    var isStart : Bool = false
    
    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var lableScore : UILabel!
    @IBOutlet weak var lableScoreMessage : UILabel!
    
    @IBOutlet weak var ViewBottom : UIView!
    @IBOutlet weak var lableLine : UILabel!
    
    @IBOutlet weak var viewResult : UIView!
    @IBOutlet weak var viewQuestion : UIView!
    @IBOutlet weak var imageResult : UIImageView!
    @IBOutlet weak var imageQuestions : UIImageView!
    @IBOutlet weak var lableResult : UILabel!
    @IBOutlet weak var lableQuestion : UILabel!
    @IBOutlet weak var buttonResult : UIButton!
    @IBOutlet weak var buttonQuestion : UIButton!
    
    @IBOutlet weak var buttonDaily : UIButton!
    @IBOutlet weak var buttonWeekly : UIButton!
    @IBOutlet weak var buttonMonthly : UIButton!
    
    @IBOutlet weak var lableDot1 : UILabel!
    @IBOutlet weak var lableDot2 : UILabel!
    @IBOutlet weak var lableDot3 : UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    func goMonitoringHome() {
        if self.delegate is AssessmentViewController {
            let AssessmentVC : AssessmentViewController = (self.delegate as! AssessmentViewController)
            AssessmentVC.goMonitoringHome()
        }
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func resultClick(_ sender: Any) {
        self.imageResult.isHighlighted = true
        self.imageQuestions.isHighlighted = false
        
        self.lableResult.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableQuestion.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        if(self.DiabetesQuestionVC != nil) {
            self.DiabetesQuestionVC.view .removeFromSuperview();
        }
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewResult.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        self.monthlyClick("")
    }
    @IBAction func closeMessage(_ sender : Any) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.viewMessage.setY(1500)
        }, completion: {(finished: Bool) -> Void in
            self.viewMessage.isHidden = true
        })
    }
    @IBAction func startAssessment(_ sender : Any) {
        
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.viewMessage.setY(1500)
        }, completion: {(finished: Bool) -> Void in
            self.viewMessage.isHidden = true
        })
        
        self.imageResult.isHighlighted = false
        self.imageQuestions.isHighlighted = true
        
        self.lableResult.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableQuestion.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewQuestion.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        
        if(self.DiabetesQuestionVC != nil) {
            self.DiabetesQuestionVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.DiabetesQuestionVC = DiabetesQuestionViewController(nibName : "DiabetesQuestionViewController" , bundle : nil)
        self.DiabetesQuestionVC.delegate = self
        self.DiabetesQuestionVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.DiabetesQuestionVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
    }
    @IBAction func questionsClick(_ sender: Any) {
        if(AppManager.sharedInstance.diabetesQuestionFlag() == ""){
            let UserDefaultsDetails = UserDefaults.standard
            UserDefaultsDetails.setValue("Y" , forKey: "diabetesQuestionFlag")
            UserDefaultsDetails.synchronize()

            if(!self.isStart){
                self.isStart = true
                self.viewMessage.isHidden = false
                UIView.animate(withDuration: 0.4, animations: {() -> Void in
                    self.viewMessage.setY(0)
                }, completion: {(finished: Bool) -> Void in
                })
            }
            else {
                self.startAssessment("")
            }
        }
        else {
            self.startAssessment("")
        }
    }
    @IBAction func dailyClick(_ sender : Any){
        let arrayDates : NSMutableArray = HelpAppManager.shared().getLast7Days()
        self.endDate = arrayDates[0] as! String
        self.startDate = arrayDates.lastObject as! String
        self.startDate = String(format: "%@ 00:00:00",self.startDate) as String
        self.endDate = String(format: "%@ 23:59:59",self.endDate) as String
        print(self.startDate,self.endDate)
        
        self.lableDot1.isHidden = false
        self.lableDot2.isHidden = true
        self.lableDot3.isHidden = true

        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchResultDetail()
        
    }
    @IBAction func weeklyClick(_ sender : Any){
        let arrayDates : NSMutableArray = HelpAppManager.shared().getTwoWeeksDays()
        self.endDate = arrayDates[0] as! String
        self.startDate = arrayDates.lastObject as! String
        self.startDate = String(format: "%@ 00:00:00",self.startDate) as String
        self.endDate = String(format: "%@ 23:59:59",self.endDate) as String
        print(self.startDate,self.endDate)
        
        self.lableDot1.isHidden = true
        self.lableDot2.isHidden = false
        self.lableDot3.isHidden = true

        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchResultDetail()
    }
    @IBAction func monthlyClick(_ sender : Any){
        self.startDate = AppManager.sharedInstance.conertDateToString(Date: HelpAppManager.shared().lastMonthStartDate()! as NSDate, formate: "yyyy-MM-dd")
        self.endDate = AppManager.sharedInstance.conertDateToString(Date: HelpAppManager.shared().lastMonthLastDate()! as NSDate, formate: "yyyy-MM-dd")
        self.startDate = String(format: "%@ 00:00:00",self.startDate) as String
        self.endDate = String(format: "%@ 23:59:59",self.endDate) as String
        print(self.startDate,self.endDate)
        
        self.lableDot1.isHidden = true
        self.lableDot2.isHidden = true
        self.lableDot3.isHidden = false

        if(self.lineChartView != nil){
            self.lineChartView.removeFromSuperview()
        }
        self.fetchResultDetail()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.viewMessage.isHidden = false
        self.labelMessage.text = "Please use this calculator to work out your risk of developing Type 2 Diabetes over the next ten years by answering some simple questions. It is suitable for people who do not already have a diagnosis of Type 2 Diabetes."
        
        AppManager.sharedInstance.viewShadow(MainView: self.ViewBottom)
        self.lableLine.setWidth(self.viewResult.width())
        self.lableLine.setX(0)
        self.dailyClick("")
        
        self.buttonStart.layer.cornerRadius = 6.0
        self.buttonStart.layer.borderWidth = 1
        self.buttonStart.layer.borderColor = UIColor(red: 42.0/255, green: 184.0/255, blue: 181.0/255, alpha: 1.0).cgColor

        self.scrollMain.contentSize = CGSize(width: self.view.width(), height: 400)
        
    }
    func fetchResultDetail () {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let address = String(format: "%@assessment/DiabetesData/%@?startDate=%@&endDate=%@",kAPIDOMAIN,AppManager.sharedInstance.userName(),self.startDate,self.endDate) as String
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                do {
                    self.arrayOfItems.removeAllObjects()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                    print(jsonObject)
                    if jsonObject["data"] != nil {
                        let userArray : NSArray = jsonObject["data"] as! NSArray
                        for DetailDic in userArray {
                            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: DetailDic as! [NSObject : AnyObject] as NSDictionary)
                            self.arrayOfItems.add(dictionaryDetails)
                        }
                        if(self.arrayOfItems.count != 0){
                            self.updateValue()
                            self.labelEmpty.isHidden = true
                            self.scrollMain.isHidden = false
                        }
                        else {
                            self.scrollMain.isHidden = true
                            self.labelEmpty.isHidden = false
                        }
                    }
                    else {
                        self.scrollMain.isHidden = true
                        self.labelEmpty.isHidden = false
                    }

                } catch let error {
                    print(error)
                }
        }
    }
    func updateValue() {
        
        let array : NSMutableArray = []
        let arrayKey : NSMutableArray = []
        
        let arraySystolicNumber : NSMutableArray = []
        
        for Index in 0..<self.arrayOfItems.count {
            let keyString = String(Index+1)
            arrayKey.add(keyString)
            
            let dictionaryDetails: NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            let DateString : NSString = AppManager.sharedInstance.conertDateStringToString(Date: dictionaryDetails["measurementDate"] as! String, Format: "yyyy-MM-dd") as NSString
            array.add(DateString)
            arraySystolicNumber.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "score"))
        }
        let scoreValue : CGFloat = CGFloat((arraySystolicNumber[arraySystolicNumber.count-1] as! NSString).doubleValue)
        let totalScore : Int = Int(ceil(Double(scoreValue)))
        let Percentage : String = "%"
        self.lableScore.text = NSString(format: "Your Score is: %@%@",String(totalScore),Percentage) as String
        self.lableScoreMessage.text = NSString(format: "Your risk of having Type 2 Diabetes within the next 10 years is:") as String
        
        if(arraySystolicNumber.count != 0){
            self.lineChartView = YZLineChartView(frame: CGRect(x: 0, y: 47, width: 375, height: 230))
            self.lineChartView.axisColor = UIColor.black.withAlphaComponent(0.3)
            self.lineChartView.marginInset = UIEdgeInsetsMake(20.0, 30.0, 40.0, 30.0)
            self.lineChartView.gridStep = 6
            self.lineChartView.drawsDataPoints = true
            self.lineChartView.backgroundColor = UIColor.clear
            self.ViewInner.addSubview(self.lineChartView)
            self.lineChartView.totalCount = Int32(arraySystolicNumber.count);
            
            let lineArray : NSMutableArray = []
            let lineChart1 = YZLineChartModel()
            lineChart1.title = "Score"
            lineChart1.data = arraySystolicNumber as! [Any]
            lineChart1.lineColor = UIColor(red: 127.0/255, green: 180.0/255, blue: 241.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart1)
            self.lineChartView.reDrawLineChart(withDimensionData: array as! [Any], chartData: lineArray as! [Any])
        }
        
    }
    @IBAction func infoClick(_ sender : Any) {
        let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
        viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
        AppDelegate.appDelegate().window?.addSubview(viewAlert)
        viewAlert.delegate = self
        viewAlert.IndexTag = "101"
        viewAlert.AlertType = "Text"
        viewAlert.isSingle = true
        viewAlert.AlertMessage = "Only valid if you do not already have a diagnosis of diabetes."
        viewAlert.UpdateDetailView()
        viewAlert.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            viewAlert.alpha = 1
        }, completion: {(finished: Bool) -> Void in
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
