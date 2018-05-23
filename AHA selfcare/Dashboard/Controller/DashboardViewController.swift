//
//  DashboardViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DashboardViewController: UIViewController {

    @IBOutlet weak var tabelRiskManagement : UITableView!

    @IBOutlet weak var viewAssessment : UIView!
    @IBOutlet weak var viewShop : UIView!
    @IBOutlet weak var viewMonitoring : UIView!
    @IBOutlet weak var viewRecords : UIView!
    @IBOutlet weak var viewRisk : UIView!
    
    @IBOutlet weak var imageAssessment : UIImageView!
    @IBOutlet weak var imageShop : UIImageView!
    @IBOutlet weak var imageMonitoring : UIImageView!
    @IBOutlet weak var imageRecords : UIImageView!
    
    @IBOutlet weak var lableAssessment : UILabel!
    @IBOutlet weak var lableShop : UILabel!
    @IBOutlet weak var lableMonitoring : UILabel!
    @IBOutlet weak var lableRecords : UILabel!
        
    @IBOutlet weak var ViewBottom : UIView!
    @IBOutlet weak var lableLine : UILabel!
    @IBOutlet weak var viewEmpty : UIView!

    var assessmentVC : AssessmentViewController!
    var monitoringVC : MonitoringViewController!
    var assessmentStartVC : StartAssessmentViewController!
    var monitoringStartVC : StartMonitoringViewController!
    var recordsVC : RecordsViewController!
    var shopsVC : ShopViewController!
    
    var arrayOfItems :NSMutableArray = []
    var arrayOfRiskItems :NSMutableArray = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    @IBAction func logoutclick (_ sender : Any) {
        
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "userage")
        UserDefaults.standard.removeObject(forKey: "password")
        let SignInVC : SignInViewController = SignInViewController(nibName : "SignInViewController" , bundle : nil)
        self.navigationController?.pushViewController(SignInVC, animated: false)
    }
    @IBAction func AssessmentClick(_ sender: Any) {
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
            self.lableLine.setX(self.viewAssessment.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.monitoringStartVC != nil{
            self.monitoringStartVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.monitoringVC != nil{
            self.monitoringVC.view .removeFromSuperview();
        }


        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        
        if(AppManager.sharedInstance.assessmentStartFlag() == ""){
            let UserDefaultsDetails = UserDefaults.standard
            UserDefaultsDetails.setValue("Y" , forKey: "assessmentStartFlag")
            UserDefaultsDetails.synchronize()

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
            self.lableLine.setX(self.viewShop.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.monitoringStartVC != nil{
            self.monitoringStartVC.view .removeFromSuperview();
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
            self.lableLine.setX(self.viewMonitoring.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.monitoringStartVC != nil{
            self.monitoringStartVC.view .removeFromSuperview();
        }
        if self.assessmentVC != nil{
            self.assessmentVC.view .removeFromSuperview();
        }
        if self.monitoringVC != nil{
            self.monitoringVC.view .removeFromSuperview();
        }
        let PageWidth : CGFloat = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320
        if(AppManager.sharedInstance.MonitoringStartFlag() == ""){
            self.monitoringStartVC = StartMonitoringViewController(nibName : "StartMonitoringViewController" , bundle : nil)
            self.monitoringStartVC.delegate = self
            self.monitoringStartVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
            self.view.addSubview(self.monitoringStartVC.view)
            self.view.bringSubview(toFront: self.ViewBottom)
        }
        else {
            self.monitoringVC = MonitoringViewController(nibName : "MonitoringViewController" , bundle : nil)
            self.monitoringVC.delegate = self
            self.monitoringVC.view.frame = CGRect(x: 0, y: 0, width: PageWidth, height: self.view.height() - 60)
            self.view.addSubview(self.monitoringVC.view)
            self.view.bringSubview(toFront: self.ViewBottom)
        }

    }
    @IBAction func RecordsClick(_ sender: Any) {
        self.imageAssessment.isHighlighted = false
        self.imageShop.isHighlighted = false
        self.imageMonitoring.isHighlighted = false
        self.imageRecords.isHighlighted = true
        self.lableAssessment.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.000)
        
        self.lableLine.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewRecords.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.monitoringStartVC != nil{
            self.monitoringStartVC.view .removeFromSuperview();
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
    @IBAction func DashboardClick(_ sender: Any) {
        self.imageAssessment.isHighlighted = false
        self.imageShop.isHighlighted = false
        self.imageMonitoring.isHighlighted = false
        self.imageRecords.isHighlighted = false
        self.lableAssessment.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableShop.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableMonitoring.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableRecords.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)
        self.lableLine.isHidden = true
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lableLine.setX(self.viewRisk.minx() + 10)
        }, completion: {(finished: Bool) -> Void in
        })
        
        if self.assessmentStartVC != nil{
            self.assessmentStartVC.view .removeFromSuperview();
        }
        if self.monitoringStartVC != nil{
            self.monitoringStartVC.view .removeFromSuperview();
        }
        if self.shopsVC != nil{
            self.shopsVC.view .removeFromSuperview();
        }
        if self.recordsVC != nil{
            self.recordsVC.view .removeFromSuperview();
        }
        self.fetchUserDetail()
        self.fetchRishManagemnet()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.lableLine.setWidth(self.viewAssessment.width() - 20)
        self.lableLine.setX(self.viewMonitoring.minx() + 10)
        self.lableLine.isHidden = true
        
        self.ViewBottom.layer.shadowColor = UIColor.gray.cgColor
        self.ViewBottom.layer.shadowOpacity = 0.3
        self.ViewBottom.layer.shadowRadius = 1.0
        self.ViewBottom.layer.shadowOffset = CGSize(width: 2.0, height: -1.3)
        
        self.tabelRiskManagement.register(UINib(nibName: "CellRiskManagement", bundle: nil), forCellReuseIdentifier: "CellRiskManagementID")
        print(AppManager.sharedInstance.userName())
        
        self.fetchUserDetail()
        self.fetchRishManagemnet()
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
                            UserDefaultsDetails.synchronize()//detailDic["height"]
                            
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
                        arrayLsit = arrayLsit.reversed() as! NSMutableArray
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
        cell.buttonMessage.addTarget(self, action: #selector(DashboardViewController.recommandationMessage(sender:)), for: .touchUpInside)

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

}
extension DashboardViewController : SlideMenuControllerDelegate {
    
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

