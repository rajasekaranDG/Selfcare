//
//  RiskViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 05/08/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RiskViewController: UIViewController {

    @IBOutlet weak var tabelRiskManagement : UITableView!
    @IBOutlet weak var viewEmpty : UIView!

    var delegate : AnyObject?
    var arrayOfItems :NSMutableArray = []
    var arrayOfRiskItems :NSMutableArray = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func menuClick(_ sender : Any) {
        if self.delegate is StartMonitoringViewController {
            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoringVC.menuClick("")
        }
    }
    @IBAction func gotoMonitoring(_ sender : Any) {
        if self.delegate is StartMonitoringViewController {
            let StartMonitoring : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoring.MonitoringClick("")
        }
    }
    @IBAction func gotoAssessment(_ sender : Any) {
        if self.delegate is StartMonitoringViewController {
            let StartMonitoring : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoring.AssessmentClick("")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if(AppManager.sharedInstance.appVersion() == "SUBSCRIBED"){
            self.tabelRiskManagement.register(UINib(nibName: "CellRiskManagement", bundle: nil), forCellReuseIdentifier: "CellRiskManagementID")
            self.fetchRishManagemnet()
//        }
//        else {
//            let viewInvite: ViewInvite = (Bundle .main.loadNibNamed("ViewInvite", owner: self, options: nil)![0] as! ViewInvite)
//            viewInvite.frame = CGRect(x: 0, y: 64, width: self.view.width(), height: self.view.height())
//            viewInvite.delegate = self
//            self.view.addSubview(viewInvite)
//            viewInvite.lblCode.text = AppManager.sharedInstance.referralCode()
//        }
    }
    func fetchRishManagemnet () {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let address = String(format: "%@alert/%@",kAPIDOMAIN,AppManager.sharedInstance.userName()) as String
        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                do {
                    self.arrayOfRiskItems.removeAllObjects()
                    
                    var arrayLsit : NSMutableArray = []
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                    if jsonObject["data"] != nil {
                        let userArray : NSArray = jsonObject["data"] as! NSArray
                        for DetailDic in userArray {
                            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: DetailDic as! [NSObject : AnyObject] as NSDictionary)
                            arrayLsit.add(dictionaryDetails)
                        }
                        if(arrayLsit.count != 0){
                            arrayLsit = arrayLsit.reversed() as! NSMutableArray
                        }
                        for DetailDic in arrayLsit {
                            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: DetailDic as! [NSObject : AnyObject] as NSDictionary)
                            dictionaryDetails.setObject(AppManager.sharedInstance.conertDateStringToString(Date: dictionaryDetails["datetime"] as! String, Format: "dd-MMM-yyyy"), forKey: "date" as NSCopying)
                            self.arrayOfRiskItems.add(dictionaryDetails)
                        }
                        print(self.arrayOfRiskItems)
                        if(self.arrayOfRiskItems.count != 0){
                            self.viewEmpty.isHidden = true
                            self.tabelRiskManagement.isHidden = false
                            self.checkDate()
                        }
                        else {
                            self.viewEmpty.isHidden = false
                            self.tabelRiskManagement.isHidden = true
                        }
                    }
                    else {
                        self.viewEmpty.isHidden = false
                        self.tabelRiskManagement.isHidden = true
                    }
                } catch let error {
                    print(error)
                    self.viewEmpty.isHidden = false
                    self.tabelRiskManagement.isHidden = true
                }
        }
    }
    func checkDate () {
        
        let listArray : NSMutableArray = []
        for Index in 0..<self.arrayOfRiskItems.count {
            let detailDic : NSMutableDictionary = NSMutableDictionary()
            let array : NSMutableArray = []
            let DetailDic : NSMutableDictionary = self.arrayOfRiskItems[Index] as! NSMutableDictionary
            detailDic.setObject(DetailDic["date"] as! String, forKey: "date" as NSCopying)
            detailDic.setObject(DetailDic["datetime"] as! String, forKey: "datetime" as NSCopying)
            detailDic.setObject(array, forKey: "List" as NSCopying)
            listArray.add(detailDic)
        }
        print(listArray)
        let set = NSSet(array: listArray as! [Any])
        self.arrayOfItems = AppManager.sharedInstance.convertToNSMutableArray(array: set.allObjects as NSArray)//set.allObjects as! NSMutableArray
        
        for Index in 0..<self.arrayOfRiskItems.count {
            let DetailDic : NSMutableDictionary = self.arrayOfRiskItems[Index] as! NSMutableDictionary
            let index : Int = Int(HelpAppManager.shared().checkArrayValue(self.arrayOfItems , key: "date", checkValue: DetailDic["date"] as! String))
            if index < self.arrayOfItems.count {
                let DetailDic : NSMutableDictionary = self.arrayOfItems[index] as! NSMutableDictionary
                let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
                array.add(self.arrayOfRiskItems[Index])
                DetailDic.setObject(array, forKey: "List" as NSCopying)
            }
        }
        self.tabelRiskManagement.reloadData()
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return self.arrayOfItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let DetailDic : NSMutableDictionary = self.arrayOfItems[section] as! NSMutableDictionary
        let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
        return array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 160;
        }
        else {
            return 135;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRiskManagementID", for: indexPath as IndexPath) as! CellRiskManagement
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        let DetailDic : NSMutableDictionary = self.arrayOfItems[indexPath.section] as! NSMutableDictionary
        let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
        let DictionaryDetail = array[indexPath.row] as! NSMutableDictionary
        
        AppManager.sharedInstance.viewShadow(MainView: cell.viewMessage)
        cell.lableDate.text = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail["datetime"] as! String, Format: "dd-MMM-yyyy hh:mm a")
        
        cell.lableAHASay.text = String(format: "AHA Says:Hi %@",AppManager.sharedInstance.userName()) as String
        cell.lableMessage.text = DictionaryDetail["alerts"] as? String
        cell.lableDot.layer.cornerRadius = 4.0
        cell.buttonMessage.layer.borderWidth = 2.0
        cell.buttonMessage.layer.borderColor = UIColor(red: 42.0/255, green: 184.0/255, blue: 181.0/255, alpha: 1.0).cgColor
        
        cell.buttonMessage.tag = indexPath.row
        cell.buttonMessage.addTarget(self, action: #selector(RiskViewController.recommandationMessage(sender:)), for: .touchUpInside)
        
        if(indexPath.row == 0){
            cell.viewDate.isHidden = false
            cell.viewMessage.setY(30)
            cell.lableLine.setY(25)
            cell.lableLine.setHeight(135)
        }
        else {
            cell.viewDate.isHidden = true
            cell.viewMessage.setY(5)
            cell.lableLine.setY(0)
            cell.lableLine.setHeight(135)
        }
        return cell
    }
    func recommandationMessage(sender : AnyObject) {
        let view : UIView = sender.superview!!
        let cell : CellRiskManagement = view.superview?.superview as! CellRiskManagement
        var indexPath: IndexPath? = self.tabelRiskManagement.indexPath(for: cell)
        let DetailDic : NSMutableDictionary = self.arrayOfItems[indexPath!.section] as! NSMutableDictionary
        let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
        let DictionaryDetail = array[(indexPath?.row)!] as! NSMutableDictionary
        
        let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
        viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
        AppDelegate.appDelegate().window?.addSubview(viewAlert)
        viewAlert.delegate = self
        viewAlert.IndexTag = "101"
        viewAlert.AlertType = "Text"
        viewAlert.isSingle = true
        viewAlert.AlertMessage = DictionaryDetail["recommendations"] as! NSString
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
