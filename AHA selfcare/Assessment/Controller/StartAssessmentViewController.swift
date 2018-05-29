//
//  StartAssessmentViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 30/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire

class StartAssessmentViewController: UIViewController {

    var delegate : AnyObject?
    
    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var viewEmpty : UIView!
    @IBOutlet weak var buttonStart : UIButton!
    
    @IBOutlet weak var viewDiabetes : UIView!
    @IBOutlet weak var viewBMI : UIView!
    @IBOutlet weak var viewStroke : UIView!
    @IBOutlet weak var viewDR : UIView!
    @IBOutlet weak var viewCVD : UIView!
    @IBOutlet weak var viewCVDDeath : UIView!
    @IBOutlet weak var viewHA : UIView!
    @IBOutlet weak var viewCHD : UIView!
    
    @IBOutlet weak var labelDiabetes : UILabel!
    @IBOutlet weak var labelBMI : UILabel!
    @IBOutlet weak var labelStroke : UILabel!
    @IBOutlet weak var labelDR : UILabel!
    @IBOutlet weak var labelCVD : UILabel!
    @IBOutlet weak var labelCVDDeath : UILabel!
    @IBOutlet weak var labelHA : UILabel!
    @IBOutlet weak var labelCHD : UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func MenuClick(_ sender : Any) {
        if self.delegate is StartMonitoringViewController {
            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoringVC.menuClick("")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((AppManager.sharedInstance.appVersion() == "PREMIUM") || (AppManager.sharedInstance.appVersion() == "SUBSCRIBED")){
            
        }
//        else {
//            let viewInvite: ViewInvite = (Bundle .main.loadNibNamed("ViewInvite", owner: self, options: nil)![0] as! ViewInvite)
//            viewInvite.frame = CGRect(x: 0, y: 64, width: self.view.width(), height: self.view.height())
//            viewInvite.delegate = self
//            self.view.addSubview(viewInvite)
//            viewInvite.lblCode.text = AppManager.sharedInstance.referralCode()
//        }
        
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        
        self.scrollMain.setWidth(PageWidth)
        self.scrollMain.contentSize = CGSize(width: PageWidth, height: 350)
        
        AppManager.sharedInstance.viewShadow(MainView: self.viewDiabetes)
        AppManager.sharedInstance.viewShadow(MainView: self.viewBMI)
        AppManager.sharedInstance.viewShadow(MainView: self.viewStroke)
        AppManager.sharedInstance.viewShadow(MainView: self.viewDR)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCVD)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCVDDeath)
        AppManager.sharedInstance.viewShadow(MainView: self.viewHA)
        AppManager.sharedInstance.viewShadow(MainView: self.viewCHD)
        
        self.buttonStart.layer.cornerRadius = 6.0
        self.buttonStart.layer.borderWidth = 1
        self.buttonStart.layer.borderColor = UIColor(red: 42.0/255, green: 184.0/255, blue: 181.0/255, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
        self.fetchSummaryDetail()
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
                    
                    if jsonObject["data"] != nil {
                        let userDictionary : NSDictionary = jsonObject["data"] as! NSDictionary
                        if(userDictionary.allKeys.count != 0){
                            self.viewEmpty.isHidden = true
                            self.scrollMain.isHidden = false
                            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: userDictionary as [NSObject : AnyObject] as NSDictionary)
                            self.updateValue(detailDic: dictionaryDetails)
                            self.checkDetail(detailDic: dictionaryDetails)
                        }
                    }
                    else {
                       // self.viewEmpty.isHidden = false
                       // self.scrollMain.isHidden = true
                        
                        self.viewEmpty.isHidden = true
                        self.scrollMain.isHidden = false
                        let dictionaryDetails: NSMutableDictionary = NSMutableDictionary()
                        self.updateValue(detailDic: dictionaryDetails)
                        self.checkDetail(detailDic: dictionaryDetails)
                    }
                } catch let error {
                    print(error)
                }
        }
    }
    func checkDetail(detailDic : NSMutableDictionary) {
        
        let diabetesScore : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "diabetesScore") as NSString
        let bmi : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "bmi") as NSString
        let stroke : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "stroke") as NSString
        let dr : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "dr") as NSString
        let cvd : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "cvd") as NSString
        let cvddr : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "cvddr") as NSString
        let ha : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "ha") as NSString
        let chd : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic, key: "chd") as NSString

        if((diabetesScore.isEqual(to: "")) && (bmi.isEqual(to: "")) && (stroke.isEqual(to: "")) && (dr.isEqual(to: "")) && (cvd.isEqual(to: "")) && (diabetesScore.isEqual(to: "")) && (cvddr.isEqual(to: "")) && (ha.isEqual(to: "")) && (chd.isEqual(to: ""))) {
//            self.viewEmpty.isHidden = false
//            self.scrollMain.isHidden = true
            
            self.viewEmpty.isHidden = true
            self.scrollMain.isHidden = false
        }
        else {
            self.viewEmpty.isHidden = true
            self.scrollMain.isHidden = false
        }
    }
    func updateValue(detailDic : NSMutableDictionary) {
        
        
        self.labelDiabetes.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "diabetesScore")
        self.labelBMI.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "bmi")
        self.labelStroke.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "stroke")
        self.labelDR.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "dr")
        self.labelCVD.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "cvd")
        self.labelCVDDeath.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "cvddr")
        self.labelHA.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "ha")
        self.labelCHD.text = AppManager.sharedInstance.checkNumberStringForAssessment(DetailDictionary: detailDic, key: "chd")
    }
    @IBAction func startMonitoring(_ sender : Any) {
        let UserDefaultsDetails = UserDefaults.standard
        UserDefaultsDetails.setValue("Y" , forKey: "assessmentStartFlag")
        UserDefaultsDetails.synchronize()
        let assessmentVC : AssessmentViewController = AssessmentViewController(nibName : "AssessmentViewController", bundle : nil)
        assessmentVC.delegate = self.delegate
        assessmentVC.view.frame = self.view.bounds
        self.view.addSubview(assessmentVC.view)
        
//        if self.delegate is StartMonitoringViewController {
//            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
//            let assessmentVC : AssessmentViewController = AssessmentViewController(nibName : "AssessmentViewController", bundle : nil)
//            assessmentVC.delegate = self.delegate
//            StartMonitoringVC.navigationController?.pushViewController(assessmentVC, animated: true)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
