//
//  ObesityViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 24/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ObesityViewController: UIViewController {

    var delegate : AnyObject?
    var delegateStart : AnyObject?
    var startDate : String = ""
    var endDate : String = ""
    var arrayOfItems : NSMutableArray = []

    var ObesityQuestionVC : ObesityQuestionViewController!
    var lineChartView : YZLineChartView!

    @IBOutlet weak var ViewMain : UIView!
    @IBOutlet weak var ViewBottom : UIView!
    @IBOutlet weak var lableLine : UILabel!
    @IBOutlet weak var ViewInner : UIView!
    @IBOutlet weak var lableEmpty : UILabel!

    @IBOutlet weak var buttonDaily : UIButton!
    @IBOutlet weak var buttonWeekly : UIButton!
    @IBOutlet weak var buttonMonthly : UIButton!

    @IBOutlet weak var viewResult : UIView!
    @IBOutlet weak var viewQuestion : UIView!
    @IBOutlet weak var imageResult : UIImageView!
    @IBOutlet weak var imageQuestions : UIImageView!
    @IBOutlet weak var lableResult : UILabel!
    @IBOutlet weak var lableQuestion : UILabel!
    @IBOutlet weak var buttonResult : UIButton!
    @IBOutlet weak var buttonQuestion : UIButton!
    
    @IBOutlet weak var viewMessage : UIView!
    @IBOutlet weak var labelMessage : UILabel!

    @IBOutlet weak var labelResultTitle : UILabel!
    @IBOutlet weak var viewScore : UIView!
    @IBOutlet weak var viewScoreInner : UIView!
    @IBOutlet weak var labelScore : UILabel!
    @IBOutlet weak var labelScoreMessage : UILabel!

    @IBOutlet weak var lableDot1 : UILabel!
    @IBOutlet weak var lableDot2 : UILabel!
    @IBOutlet weak var lableDot3 : UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    func goAssessmentHome() {
        if self.delegateStart is ObesityStartViewController {
            let ObesityStartVC : ObesityStartViewController = (self.delegateStart as! ObesityStartViewController)
            ObesityStartVC.backClick("")
        }
        self.navigationController!.popViewController(animated: true)
    }

    func hideResult() {
        self.labelResultTitle.isHidden = true
        self.viewScore.isHidden = true
    }
    @IBAction func dailyClick(_ sender : Any){
        self.hideResult()
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
        self.hideResult()
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
        self.hideResult()
        self.startDate = AppManager.sharedInstance.conertDateToString(Date: HelpAppManager.shared().lastMonthStartDate()! as NSDate, formate: "yyyy-MM-dd")
        self.endDate = AppManager.sharedInstance.conertDateToString(Date: HelpAppManager.shared().lastMonthLastDate() as NSDate, formate: "yyyy-MM-dd")
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
    @IBAction func resultClick(_ sender: Any) {
        self.imageResult.isHighlighted = true
        self.imageQuestions.isHighlighted = false
        
        self.lableResult.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableQuestion.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)

        if(self.ObesityQuestionVC != nil) {
            self.ObesityQuestionVC.view .removeFromSuperview();
        }
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewResult.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
//        self.monthlyClick("")
        self .weeklyClick("")
    }
    @IBAction func questionsClick(_ sender: Any) {
        self.imageResult.isHighlighted = false
        self.imageQuestions.isHighlighted = true

        self.lableResult.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableQuestion.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewQuestion.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        if(self.ObesityQuestionVC != nil) {
            self.ObesityQuestionVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.ObesityQuestionVC = ObesityQuestionViewController(nibName : "ObesityQuestionViewController" , bundle : nil)
        self.ObesityQuestionVC.delegate = self
        self.ObesityQuestionVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.ObesityQuestionVC.view)
        self.view.bringSubview(toFront: self.ViewMain)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AppManager.sharedInstance.viewShadow(MainView: self.ViewMain)
        self.lableLine.setWidth(self.viewResult.width())
        self.lableLine.setX(0)
//        self.monthlyClick("")
        self .weeklyClick("")
    }
    func fetchResultDetail () {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let address = String(format: "%@assessment/Bmi/%@?startDate=%@&endDate=%@",kAPIDOMAIN,AppManager.sharedInstance.userName(),self.startDate,self.endDate) as String
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        print(escapedString)
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                do {
                    self.arrayOfItems.removeAllObjects()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                    if jsonObject["data"] != nil {
                        let userArray : NSArray = jsonObject["data"] as! NSArray
                        for DetailDic in userArray {
                            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: DetailDic as! [NSObject : AnyObject] as NSDictionary)
                            self.arrayOfItems.add(dictionaryDetails)
                        }
                        print(self.arrayOfItems)
                        if(self.arrayOfItems.count != 0){
                            self.updateValue()
                            let detailDic : NSMutableDictionary = self.arrayOfItems[self.arrayOfItems.count-1] as! NSMutableDictionary
                            
                            let bodyMassIndex : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "bodyMassIndex") as NSString).doubleValue)

                            let Percentage : String = "%"
                            self.labelScore.text = String(format : "%@%@",(AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "bodyMassIndex") as NSString),Percentage)
                            let score: CGFloat = bodyMassIndex
                            
                            if(score < 18.5) {
                                self.labelScoreMessage.text = "You are Underweight – ideally aim for a BMI of between 18.5 and 25."
                                self.viewScoreInner.backgroundColor = UIColor.green
                            }
                            if((score >= 18.5) && (score <= 24.9)){
                                self.labelScoreMessage.text = "Your are of Normal weight – Very Good. Always aim for a BMI of between 18.5 and 25."
                                self.viewScoreInner.backgroundColor = UIColor.green
                            }
                            else if((score >= 25) && (score <= 29.9)){
                                self.labelScoreMessage.text = "You are Overweight – Aim for a BMI of between 18.5 and 25."
                                self.viewScoreInner.backgroundColor = UIColor.orange
                            }
                            else if (score >= 30){
                                self.labelScoreMessage.text = "You are Obese – Aim for a BMI <25"
                                self.viewScoreInner.backgroundColor = UIColor.red
                            }
                            self.labelResultTitle.isHidden = false
                            self.viewScore.isHidden = false
                            self.lableEmpty.isHidden = true
                        }
                        else {
                            self.lableEmpty.isHidden = false
                        }
                    }
                    else {
                        self.lableEmpty.isHidden = false
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
            arraySystolicNumber.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "bodyMassIndex"))
        }
        if(arraySystolicNumber.count != 0){
            self.lineChartView = YZLineChartView(frame: CGRect(x: 0, y: 47, width: 375, height: 260))
            self.lineChartView.axisColor = UIColor.black.withAlphaComponent(0.3)
            self.lineChartView.marginInset = UIEdgeInsetsMake(20.0, 30.0, 40.0, 30.0)
            self.lineChartView.gridStep = 6
            self.lineChartView.drawsDataPoints = true
            self.lineChartView.backgroundColor = UIColor.clear
            self.ViewInner.addSubview(self.lineChartView)
            self.lineChartView.totalCount = Int32(arraySystolicNumber.count);

            let lineArray : NSMutableArray = []
            let lineChart1 = YZLineChartModel()
            lineChart1.title = "BMI"
            lineChart1.data = arraySystolicNumber as! [Any]
            lineChart1.lineColor = UIColor(red: 231.0/255, green: 122.0/255, blue: 4.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart1)
            self.lineChartView.reDrawLineChart(withDimensionData: array as! [Any], chartData: lineArray as! [Any])
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
