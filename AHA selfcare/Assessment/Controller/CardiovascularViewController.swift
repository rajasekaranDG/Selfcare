//
//  CardiovascularViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 25/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire

class CardiovascularViewController: UIViewController {

    var delegate : AnyObject?
    var startDate : String = ""
    var endDate : String = ""
    var arrayOfItems : NSMutableArray = []
    
    var CardiovascularQuestionVC : CardiovascularQuestionViewController!
    
    var lineChartView : YZLineChartView!

    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var ViewBottom : UIView!
    @IBOutlet weak var infoView : UIView!
    @IBOutlet weak var lableLine : UILabel!
    @IBOutlet weak var ViewInner : UIView!
    @IBOutlet weak var lableEmpty : UILabel!

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

    @IBOutlet weak var viewScore : UIView!
    @IBOutlet weak var viewCVDValue : UIView!
    @IBOutlet weak var viewCVDDeath : UIView!
    @IBOutlet weak var viewCHDValue : UIView!
    @IBOutlet weak var viewCHDDeath : UIView!
    @IBOutlet weak var viewMIValue : UIView!
    @IBOutlet weak var viewStroke : UIView!

    @IBOutlet weak var indicatorCVDValue : GDLoadingIndicator!
    @IBOutlet weak var indicatorCVDDeath : GDLoadingIndicator!
    @IBOutlet weak var indicatorCHDValue : GDLoadingIndicator!
    @IBOutlet weak var indicatorCHDDeath : GDLoadingIndicator!
    @IBOutlet weak var indicatorMIValue : GDLoadingIndicator!
    @IBOutlet weak var indicatorStroke : GDLoadingIndicator!

    @IBOutlet weak var lableCVDValue : UILabel!
    @IBOutlet weak var lableCVDDeath : UILabel!
    @IBOutlet weak var lableCHDValue : UILabel!
    @IBOutlet weak var lableCHDDeath : UILabel!
    @IBOutlet weak var lableMIValue : UILabel!
    @IBOutlet weak var lableStroke : UILabel!

    @IBOutlet weak var lableDot1 : UILabel!
    @IBOutlet weak var lableDot2 : UILabel!
    @IBOutlet weak var lableDot3 : UILabel!

    var cvddrArray : NSMutableArray = []
    var haArray : NSMutableArray = []
    var strokeArray : NSMutableArray = []
    var chdArray : NSMutableArray = []
    var drArray : NSMutableArray = []
    var cvdArray : NSMutableArray = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func resultClick(_ sender: Any) {
        
        self.imageResult.isHighlighted = true
        self.imageQuestions.isHighlighted = false
        
        self.lableResult.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        self.lableQuestion.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        
        if(self.CardiovascularQuestionVC != nil) {
            self.CardiovascularQuestionVC.view .removeFromSuperview();
        }
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewResult.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        self.monthlyClick("")
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
        if(self.CardiovascularQuestionVC != nil) {
            self.CardiovascularQuestionVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        self.CardiovascularQuestionVC = CardiovascularQuestionViewController(nibName : "CardiovascularQuestionViewController" , bundle : nil)
        self.CardiovascularQuestionVC.delegate = self
        self.CardiovascularQuestionVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
        self.view.addSubview(self.CardiovascularQuestionVC.view)
        self.view.bringSubview(toFront: self.ViewBottom)
        
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
        self.infoView.isHidden = true
        AppManager.sharedInstance.viewShadow(MainView: self.ViewBottom)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCHDValue)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCHDDeath)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCVDValue)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCVDDeath)
        AppManager.sharedInstance.viewShadow(MainView: self.viewMIValue)
        AppManager.sharedInstance.viewShadow(MainView: self.viewStroke)

        self.lableLine.setWidth(self.viewResult.width())
        self.lableLine.setX(0)
        self.monthlyClick("")
    }
    func fetchResultDetail () {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let address = String(format: "%@assessment/CardioVascular/%@?startDate=%@&endDate=%@",kAPIDOMAIN,AppManager.sharedInstance.userName(),self.startDate,self.endDate) as String
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                do {
                    self.arrayOfItems.removeAllObjects()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                    print(jsonObject)
                    
                    if let arr = jsonObject["data"] as? NSArray {
                        let userArray : NSArray = arr
                        for DetailDic in userArray {
                            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: DetailDic as! [NSObject : AnyObject] as NSDictionary)
                            self.arrayOfItems.add(dictionaryDetails)
                        }
                    }
                    if(self.arrayOfItems.count != 0){
                        self.ViewInner.setHeight(960)
                        self.lableEmpty.isHidden = true
                        self.infoView.isHidden = false
                        self.viewScore.isHidden = false
                        self.updateValue()
                        self.scrollMain.contentSize = CGSize(width: self.view.width(), height: 960)
                        
                        let dictionaryDetails: NSMutableDictionary = self.arrayOfItems[self.arrayOfItems.count-1] as! NSMutableDictionary
                        
                        let CVDValue : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "cvd") as NSString).doubleValue)
                        let totalCVD : Int = Int(ceil(Double(CVDValue)))
                        
                        let DeathValue : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "cvddr") as NSString).doubleValue)
                        let totalDeath : Int = Int(ceil(Double(DeathValue)))
                        
                        let CHDValue : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "chd") as NSString).doubleValue)
                        let totalCHD : Int = Int(ceil(Double(CHDValue)))
                        
                        let CMIValue : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "ha") as NSString).doubleValue)
                        let totalCMI : Int = Int(ceil(Double(CMIValue)))
                        
                        let MIValue : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "dr") as NSString).doubleValue)
                        let totalMI : Int = Int(ceil(Double(MIValue)))
                        
                        let StokeValue : CGFloat = CGFloat((AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "stroke") as NSString).doubleValue)
                        let totalStoke : Int = Int(ceil(Double(StokeValue)))

                        self.indicatorCVDValue.isHidden = true
                        if(CVDValue != 0){
                            self.indicatorCVDValue.isHidden = false
                            self.indicatorCVDValue.setFillerColor(UIColor(red: 237.0/255, green: 87.0/255, blue: 87.0/255, alpha: CGFloat(1.0)))
                            self.indicatorCVDValue.setProgress((CVDValue != 0) ? (CVDValue/100) : 0)
                        }
                        
                        self.indicatorCVDDeath.isHidden = true
                        if(DeathValue != 0){
                            self.indicatorCVDDeath.isHidden = false
                            self.indicatorCVDDeath.setFillerColor(UIColor(red: 146.0/255, green: 144.0/255, blue: 144.0/255, alpha: CGFloat(1)))
                            self.indicatorCVDDeath.setProgress((DeathValue != 0) ? (DeathValue/100) : 0)
                        }
                        
                        self.indicatorCHDValue.isHidden = true
                        if(CHDValue != 0){
                            self.indicatorCHDValue.isHidden = false
                            self.indicatorCHDValue.setFillerColor(UIColor(red: 106.0/255, green: 120.0/255, blue: 201.0/255, alpha: CGFloat(1)))
                            self.indicatorCHDValue.setProgress((CHDValue != 0) ? (CHDValue/100) : 0)
                        }
                        
                        self.indicatorCHDDeath.isHidden = true
                        if(CMIValue != 0){
                            self.indicatorCHDDeath.isHidden = false
                            self.indicatorCHDDeath.setFillerColor(UIColor(red: 39.0/255, green: 39.0/255, blue: 39.0/255, alpha: CGFloat(1)))
                            self.indicatorCHDDeath.setProgress((CMIValue != 0) ? (CMIValue/100) : 0)
                        }
                        
                        self.indicatorMIValue.isHidden = true
                        if(MIValue != 0){
                            self.indicatorMIValue.isHidden = false
                            self.indicatorMIValue.setFillerColor(UIColor(red: 217.0/255, green: 174.0/255, blue: 174.0/255, alpha: CGFloat(1)))
                            self.indicatorMIValue.setProgress((MIValue != 0) ? (MIValue/100) : 0)
                        }
                        
                        self.indicatorStroke.isHidden = true
                        if(StokeValue != 0){
                            self.indicatorStroke.isHidden = false
                            self.indicatorStroke.setFillerColor(UIColor(red: 7.0/255, green: 2.0/255, blue: 208.0/255, alpha: CGFloat(1)))
                            self.indicatorStroke.setProgress((StokeValue != 0) ? (StokeValue/100) : 0)
                        }

                        let Percentage : String = "%"
                        self.lableCVDValue.text = String(format : "%@%@",String(totalCVD),Percentage)
                        self.lableCVDDeath.text = String(format : "%@%@",String(totalDeath),Percentage)
                        self.lableCHDValue.text = String(format : "%@%@",String(totalCHD),Percentage)
                        self.lableCHDDeath.text = String(format : "%@%@",String(totalCMI),Percentage)
                        self.lableMIValue.text = String(format : "%@%@",String(totalMI),Percentage)
                        self.lableStroke.text = String(format : "%@%@",String(totalStoke),Percentage)
                    }
                    else {
                        self.ViewInner.setHeight(550)
                        self.viewScore.isHidden = true
                        self.lableEmpty.isHidden = false
                         self.infoView.isHidden = true
                        self.scrollMain.contentSize = CGSize(width: self.view.width(), height: 550)
                    }
                } catch let error {
                    print(error)
                }
        }
    }
    func updateValue() {
        
        let array : NSMutableArray = []
        let arrayKey : NSMutableArray = []
        
        self.cvddrArray.removeAllObjects()
        self.haArray.removeAllObjects()
        self.strokeArray.removeAllObjects()
        self.chdArray.removeAllObjects()
        self.drArray.removeAllObjects()
        self.cvdArray.removeAllObjects()
        
        for Index in 0..<self.arrayOfItems.count {
            let keyString = String(Index+1)
            arrayKey.add(keyString)
            
            let dictionaryDetails: NSMutableDictionary = self.arrayOfItems[Index] as! NSMutableDictionary
            
            let DateString : NSString = AppManager.sharedInstance.conertDateStringToString(Date: dictionaryDetails["measurementDate"] as! String, Format: "yyyy-MM-dd") as NSString
            array.add(DateString)
            
            cvddrArray.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "cvddr"))
            haArray.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "ha"))
            strokeArray.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "stroke"))
            chdArray.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "chd"))
            drArray.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "dr"))
            cvdArray.add(AppManager.sharedInstance.checkNumberString(DetailDictionary: dictionaryDetails, key: "cvd"))
        }
        self.lineChartView = YZLineChartView(frame: CGRect(x: 0, y: 47, width: 375, height: 260))
        self.lineChartView.axisColor = UIColor.black.withAlphaComponent(0.3)
        self.lineChartView.marginInset = UIEdgeInsetsMake(20.0, 30.0, 40.0, 30.0)
        self.lineChartView.gridStep = 6
        self.lineChartView.drawsDataPoints = true
        self.lineChartView.backgroundColor = UIColor.clear
        self.lineChartView.isBottomHide = true
        self.ViewInner.addSubview(self.lineChartView)
        self.lineChartView.totalCount = Int32(self.cvdArray.count);
        
        let lineArray : NSMutableArray = []
        if(self.cvdArray.count != 0){
            let lineChart1 = YZLineChartModel()
            lineChart1.title = "cvd"
            lineChart1.data = self.cvdArray as! [Any]
            lineChart1.lineColor = UIColor(red: 2.0/255, green: 208.0/255, blue: 42.0/255, alpha: CGFloat(1.0))
            lineArray.add(lineChart1)
        }
        if(self.drArray.count != 0){
            let lineChart2 = YZLineChartModel()
            lineChart2.title = "heart attack risk"
            lineChart2.data = self.drArray as! [Any]
            lineChart2.lineColor = UIColor(red: 228.0/255, green: 221.0/255, blue: 1.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart2)
        }
        if(self.chdArray.count != 0){
            let lineChart3 = YZLineChartModel()
            lineChart3.title = "chd"
            lineChart3.data = self.chdArray as! [Any]
            lineChart3.lineColor = UIColor(red: 7.0/255, green: 2.0/255, blue: 208.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart3)
        }
        if(self.strokeArray.count != 0){
            let lineChart4 = YZLineChartModel()
            lineChart4.title = "stroke risk"
            lineChart4.data = self.strokeArray as! [Any]
            lineChart4.lineColor = UIColor(red: 255.0/255, green: 128.0/255, blue: 0.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart4)
        }
        if(self.haArray.count != 0){
            let lineChart5 = YZLineChartModel()
            lineChart5.title = "CHD Death"
            lineChart5.data = self.haArray as! [Any]
            lineChart5.lineColor = UIColor(red: 39.0/255, green: 39.0/255, blue: 39.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart5)
        }
        if(self.cvddrArray.count != 0){
            let lineChart6 = YZLineChartModel()
            lineChart6.title = "CVD Death"
            lineChart6.data = self.cvddrArray as! [Any]
            lineChart6.lineColor = UIColor(red: 255.0/255, green: 0.0/255, blue: 18.0/255, alpha: CGFloat(1))
            lineArray.add(lineChart6)
        }
        if(lineArray.count != 0){
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
