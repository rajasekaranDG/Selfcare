//
//  HistoryViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 10/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController {

    var delegate : AnyObject?
    var moduleType : String = ""
    var historyArray = [JSON] ()
    var historylistArray :NSMutableArray = []
    var startDate : String = ""
    var endDate : String = ""
    var PageWidth : CGFloat = 0.0
    @IBOutlet weak var labelEmpty : UILabel!
    
    @IBOutlet weak var tableHistory : UITableView!
    @IBOutlet weak var labelTitle : UILabel!

    @IBAction func backClick(_ sender: Any) {
        if(self.delegate is MonitoringDetailViewController) {
            let MonitoringDetailVC : MonitoringDetailViewController = (self.delegate as! MonitoringDetailViewController)
            MonitoringDetailVC.backClick("")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableHistory.addSubview(self.refreshControl)
        self.PageWidth = (iPhone6Pluse) ? 414 : (iPhone6) ? 375 : 320

        self.tableHistory.register(UINib(nibName: "CellHistory", bundle: nil), forCellReuseIdentifier: "CellHistoryID")
        self.startDate = AppManager.sharedInstance.conertDateToString(Date: HelpAppManager.shared().thisMonthStartdate()! as NSDate, formate: "yyyy-MM-dd")
        self.endDate = AppManager.sharedInstance.conertDateToString(Date: HelpAppManager.shared().thisMonthLastdate()! as NSDate, formate: "yyyy-MM-dd")
        self.startDate = String(format: "%@ 00:00:00",self.startDate) as String
        self.endDate = String(format: "%@ 23:59:59",self.endDate) as String

        print(self.startDate,self.endDate)
        self.labelTitle.text = self.moduleType as String
        self.fetchHistoryList()
    }
    func fetchHistoryList () {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let address = String(format: "%@monitoring/%@/%@?startDate=%@&endDate=%@",kAPIDOMAIN,self.setUrl(),AppManager.sharedInstance.userName(),self.startDate,self.endDate) as String

        let escapedString = address.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        Alamofire.request(escapedString!)
            .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
            .responseJSON { response in
                
                 MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                if(self.refreshControl.isRefreshing == true ) {
                    self.refreshControl.endRefreshing()
                }
                let jData = JSON(data: response.data!)
                self.historyArray = jData.arrayValue
                print(self.historyArray)
                self.labelEmpty.isHidden = false
                 if(self.historyArray.count != 0){
                self.labelEmpty.isHidden = true
                }
                self.checkDate()
        }
    }
    func checkDate () {
        
        let listArray : NSMutableArray = []
        for Index in 0..<self.historyArray.count {
            let detailDic : NSMutableDictionary = NSMutableDictionary()
            let array : NSMutableArray = []
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: self.historyArray[Index][self.setKeyName()].stringValue, Format: "dd-MMM-yyyy")
            detailDic.setObject(self.historyArray[Index][self.setKeyName()].stringValue, forKey: self.setKeyName() as NSCopying)
            detailDic.setObject(stringDate, forKey: "Date" as NSCopying)
            detailDic.setObject(array, forKey: "List" as NSCopying)
            listArray.add(detailDic)
        }
        let set = NSSet(array: listArray as! [Any])
        self.historylistArray = AppManager.sharedInstance.convertToNSMutableArray(array: set.allObjects as NSArray)//set.allObjects as! NSMutableArray

        for Index in 0..<self.historyArray.count {
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: self.historyArray[Index][self.setKeyName()].stringValue, Format: "dd-MMM-yyyy")
            let index : Int = Int(HelpAppManager.shared().checkArrayValue(self.historylistArray , key: "Date", checkValue: stringDate))
            if index < self.historylistArray.count {
                let DetailDic : NSMutableDictionary = self.historylistArray[index] as! NSMutableDictionary
                let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
                array.add(self.historyArray[Index])
                DetailDic.setObject(array, forKey: "List" as NSCopying)
            }
        }
        self.tableHistory.reloadData()
    }
    func setKeyName() -> String {
        var KeyString : String = ""
        if(self.moduleType == "Sports"){
            KeyString = "sportStartTime"
        }
        else {
            KeyString = "measurementDate"
        }
        return KeyString
    }
    func setKeyValue() -> String {
        var KeyString : String = ""
        if(self.moduleType == "Sports"){
            KeyString = "sportStartTime"
        }
        else {
            KeyString = "Date"
        }
        return KeyString
    }
    func setUrl() -> String {
        let urlString = self.moduleType.replacingOccurrences(of: " ", with: "")
        return urlString
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return self.historylistArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let DetailDic : NSMutableDictionary = self.historylistArray[section] as! NSMutableDictionary
        let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
        return array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cellHeight : CGFloat = 0.0;

        if(indexPath.row == 0){
            cellHeight = cellHeight + 25;
        }
        else {
            cellHeight = cellHeight + 0;
        }

        if(self.moduleType == "Blood Glucose"){
            
            cellHeight = cellHeight + 55;
            let DetailDic : NSMutableDictionary = self.historylistArray[indexPath.section] as! NSMutableDictionary
            let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
            let DictionaryDetail = array[indexPath.row] as! JSON

            let Meal : String = NSString(format: "Meal %@",DictionaryDetail["beforeMeal"].stringValue) as String
            let Context : String = NSString(format: "Context %@",DictionaryDetail["context"].stringValue) as String

            let constraintMeal: CGSize = CGSize(width: (self.PageWidth - 75), height: 2000.0)
            if(Meal != "Meal "){
                let SizeOfMeal: CGSize = AppManager.sharedInstance.dynamicHeightCalculation(current_constraint: constraintMeal,
                                                                                            descriptions: Meal , fontfamily: UIFont(name: kFontSanFranciscoMedium, size: 18)!)
                cellHeight = cellHeight + max(SizeOfMeal.height, 20) + 10
            }
            let SizeOfContext: CGSize = AppManager.sharedInstance.dynamicHeightCalculation(current_constraint: constraintMeal,
                                                                                           descriptions: Context , fontfamily: UIFont(name: kFontSanFranciscoMedium, size: 18)!)
            cellHeight = cellHeight + max(SizeOfContext.height, 20)

            return cellHeight
        }
        else {
            return cellHeight + 75
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHistoryID", for: indexPath as IndexPath) as! CellHistory
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear

        let DetailDic : NSMutableDictionary = self.historylistArray[indexPath.section] as! NSMutableDictionary
        let array : NSMutableArray = DetailDic["List"] as! NSMutableArray
        let DictionaryDetail = array[indexPath.row] as! JSON

        AppManager.sharedInstance.viewShadow(MainView: cell.viewMessage)
        let dateandTime = DetailDic[self.setKeyName()] as? String
        let splitArr = dateandTime?.components(separatedBy: " ")
        if splitArr?.count == 2 {
        cell.lableDate.text = splitArr?.first
        
        }
        else if splitArr?.count == 1 {
            cell.lableDate.text = splitArr?.first
        }
        cell.lableDot.layer.cornerRadius = 4.0
        cell.lableDot.layer.borderWidth = 2.0
        cell.lableDot.layer.borderColor = UIColor(red: 184.0/255, green: 184.0/255, blue: 184.0/255, alpha: 1.0).cgColor
        
        cell.lableSport.isHidden = true
        cell.lableActivity.isHidden = true
        cell.lableMessage.isHidden = true
        cell.lableLastMeal.isHidden = true
        cell.lableContext.isHidden = true
        cell.viewBP.isHidden = true

        if(indexPath.row == 0){
            cell.viewDate.isHidden = false
            cell.viewMessage.setY(30)
            cell.lableLine.setY(25)
            cell.lableLine.setHeight(75)
        }
        else {
            cell.viewDate.isHidden = true
            cell.viewMessage.setY(5)
            cell.lableLine.setY(0)
            cell.lableLine.setHeight(75)
        }
        if(self.moduleType == "Blood Pressure") {
            
            cell.viewBP.isHidden = false
            cell.lableActivity.isHidden = false
            
            cell.lableActivity.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Blood Pressure %@/%@",DictionaryDetail["systolic"].stringValue,DictionaryDetail["diastolic"].stringValue) as String, highlight: "Blood Pressure", h2: "", size: 16, FontName: kFontSanFranciscoMedium)
            cell.lableBP.text = String(format: "%@ BPM",DictionaryDetail["heartRate"].stringValue) as String
            
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail[self.setKeyName()].stringValue, Format: "yyyy-MM-dd hh:mm")
            let splitArr = stringDate.components(separatedBy: " ")
            if splitArr.count == 2 {
                cell.lableTime.text = splitArr.last
            }
        }
        else if(self.moduleType == "Blood Glucose") {
            cell.lableMessage.isHidden = false
            cell.lableLastMeal.isHidden = true
            cell.lableContext.isHidden = false
            cell.lableMessage.setHeight(20)

            cell.lableMessage.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Glucose is %@ %@",DictionaryDetail["bloodGlucoseValue"].stringValue,DictionaryDetail["bloodGlucoseUnit"].stringValue) as String, highlight: "Glucose is",h2: "",size: 18, FontName: kFontSanFranciscoMedium)
            
            let Meal : String = NSString(format: "Meal %@",DictionaryDetail["beforeMeal"].stringValue) as String
            let Context : String = NSString(format: "Context %@",DictionaryDetail["context"].stringValue) as String

            var cellHeight : CGFloat = 0.0;
            let constraintMeal: CGSize = CGSize(width: (self.PageWidth - 75), height: 2000.0)

            if(Meal != "Meal "){
                cell.lableLastMeal.isHidden = false
                cell.lableLastMeal.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Meal %@",DictionaryDetail["beforeMeal"].stringValue) as String, highlight: "Meal",h2: "",size: 18, FontName: kFontSanFranciscoMedium)
                let SizeOfMeal: CGSize = AppManager.sharedInstance.dynamicHeightCalculation(current_constraint: constraintMeal,
                                                                                            descriptions: Meal , fontfamily: UIFont(name: kFontSanFranciscoMedium, size: 18)!)
                cellHeight = cellHeight + max(SizeOfMeal.height, 20)
                cell.lableLastMeal.setY(cell.lableMessage.maxy()+10)
                cell.lableContext.setY(cell.lableLastMeal.maxy()+10)
            }
            else {
                cell.lableContext.setY(cell.lableMessage.maxy()+10)
            }
            cell.lableContext.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Context %@",DictionaryDetail["context"].stringValue) as String, highlight: "Context",h2: "",size: 18, FontName: kFontSanFranciscoMedium)

            let SizeOfContext: CGSize = AppManager.sharedInstance.dynamicHeightCalculation(current_constraint: constraintMeal,
                                                                                           descriptions: Context , fontfamily: UIFont(name: kFontSanFranciscoMedium, size: 18)!)
            cellHeight = cellHeight + max(SizeOfContext.height, 20)
            
            cell.viewMessage.setHeight(cell.lableContext.maxy() + 10)
            cell.lableLine.setHeight(cell.viewMessage.height()+15)
            
             let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail[self.setKeyName()].stringValue, Format: "yyyy-MM-dd hh:mm")
            let splitArr = stringDate.components(separatedBy: " ")
            if splitArr.count == 2 {
                cell.lableTime.text = splitArr.last
            }
        }
        else if(self.moduleType == "Weight") {
            cell.lableMessage.isHidden = false
            
            let bmiValue = Double(DictionaryDetail["bmi"].stringValue)
            let roundOffValue = String(format: "%.2f", bmiValue ?? "")
            cell.lableMessage.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Weight is  %@ /  BMI is %@",DictionaryDetail["wgt"].stringValue, roundOffValue ) as String, highlight: "Weight is", h2: "BMI is", size: 18, FontName: kFontSanFranciscoMedium)
            
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail[self.setKeyName()].stringValue, Format: "yyyy-MM-dd hh:mm")

            let splitArr = stringDate.components(separatedBy: " ")
            if splitArr.count == 2 {
                cell.lableTime.text = splitArr.last
            }
        }
        else if(self.moduleType == "Sleep") {
            cell.lableMessage.isHidden = false
            cell.lableMessage.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Hours slept %@ /  Awaken %@",DictionaryDetail["hoursSlept"].stringValue, DictionaryDetail["awaken"].stringValue) as String, highlight: "Hours slept", h2: "Awaken", size: 18, FontName: kFontSanFranciscoMedium)
            
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail[self.setKeyName()].stringValue, Format: "yyyy-MM-dd hh:mm")

            let splitArr = stringDate.components(separatedBy: " ")
            if splitArr.count == 2 {
                cell.lableTime.text = splitArr.last
            }
           
        }
        else if(self.moduleType == "Activity") {
            cell.lableSport.isHidden = false
            cell.lableActivity.isHidden = false

            cell.lableActivity.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Distance travelled  %@",DictionaryDetail["distanceTraveled"].stringValue) as String, highlight: "Distance travelled", h2: "", size: 18, FontName: kFontSanFranciscoMedium)

            cell.lableSport.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Steps  %@",DictionaryDetail["steps"].stringValue) as String, highlight: "Steps", h2: "", size: 18, FontName: kFontSanFranciscoMedium)
            
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail[self.setKeyName()].stringValue, Format: "yyyy-MM-dd hh:mm")

            let splitArr = stringDate.components(separatedBy: " ")
            if splitArr.count == 2 {
                cell.lableTime.text = splitArr.last
            }
        }
        else if(self.moduleType == "Sports") {
            cell.lableSport.isHidden = false
            cell.lableActivity.isHidden = false
            cell.lableActivity.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Sports  %@",DictionaryDetail["sportName"].stringValue) as String, highlight: "Sports", h2: "", size: 18, FontName: kFontSanFranciscoMedium)
            
            cell.lableSport.attributedText = AppManager.sharedInstance.attributedTextWithColor(text: NSString(format: "Calories  %@",DictionaryDetail["calories"].stringValue) as String, highlight: "Calories", h2: "", size: 18, FontName: kFontSanFranciscoMedium)
            
            let stringDate : String = AppManager.sharedInstance.conertDateStringToString(Date: DictionaryDetail[self.setKeyName()].stringValue, Format: "yyyy-MM-dd hh:mm")

            let splitArr = stringDate.components(separatedBy: " ")
            if splitArr.count == 2 {
                cell.lableTime.text = splitArr.last
            }
        }//184

        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(HistoryViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
          self.fetchHistoryList()
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
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
