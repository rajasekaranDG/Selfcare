//
//  AddDataViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 14/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddDataViewController: UIViewController {

    var delegate : AnyObject?
    var moduleType : String = ""
    var bloodPressureArray : NSMutableArray = []
    var bloodGlucoseArray : NSMutableArray = []
    var weightArray : NSMutableArray = []
    var sleepArray : NSMutableArray = []
    var activityArray : NSMutableArray = []
    var sportsArray : NSMutableArray = []
    var monitoringParameterArray = [JSON] ()
    var titleString : NSString = ""

    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var scrollPages : UIScrollView!
    
    @IBAction func backClick(_ sender: Any) {
        if(self.delegate is MonitoringDetailViewController) {
            let MonitoringDetailVC : MonitoringDetailViewController = (self.delegate as! MonitoringDetailViewController)
            MonitoringDetailVC.backClick("")
        }
    }
    func dataAdded() {
        if self.delegate is MonitoringDetailViewController {
            let MonitoringDetailVC : MonitoringDetailViewController = (self.delegate as! MonitoringDetailViewController)
//            MonitoringDetailVC.HistoryClick("")
             MonitoringDetailVC.SummaryClick("")
            
        }
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
                
                }
                self.setPagesinScroll()
        }
    }
    func setUrl() -> String {
        let urlString = self.moduleType.replacingOccurrences(of: " ", with: "")
        return urlString
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //
        self.bloodPressureArray = HelpAppManager.shared().insertBloodPressureDictionary()
        self.bloodGlucoseArray = HelpAppManager.shared().insertBloodGlucoseDictionary()
        self.weightArray = HelpAppManager.shared().insertWeigtDictionary()
        self.sleepArray = HelpAppManager.shared().insertSleepDictionary()
        self.activityArray = HelpAppManager.shared().insertActiviDtyictionary()
        self.sportsArray = HelpAppManager.shared().insertSportsDictionary()

        self.labelTitle.text = String(format : "Add %@",self.titleString as String)
        self.fetchMonitoringParameters()
    }
    func setarrayDetail ()-> NSMutableArray {
        var arrayList : NSMutableArray = []
        if(self.moduleType == "Blood Pressure"){
            arrayList = self.bloodPressureArray
        }
        else if(self.moduleType == "Blood Glucose"){
            arrayList = self.bloodGlucoseArray
        }
        else if(self.moduleType == "Weight"){
            arrayList = self.weightArray
        }
        else if(self.moduleType == "Sleep"){
            arrayList = self.sleepArray
        }
        else if(self.moduleType == "Activity"){
            arrayList = self.activityArray
        }
        else if(self.moduleType == "Sports"){
            arrayList = self.sportsArray
        }
        return arrayList
    }
    func setPagesinScroll() {
        
        let subViews = self.scrollPages.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        var xValue : CGFloat = 0
        var count : Int = 0

        let arrayOfItems : NSMutableArray = self.setarrayDetail()
        
        let Count : CGFloat = CGFloat(arrayOfItems.count)
        let f: CGFloat = Count/2
        let roundedVal = Int(ceil(Double(f)))

        for Index in 0..<roundedVal {
            let viewAddDataPage : ViewAddDataPage = (Bundle .main.loadNibNamed("ViewAddDataPage", owner: self, options: nil)![0] as! ViewAddDataPage)
            viewAddDataPage.frame = CGRect(x: xValue, y: 0, width: self.view.width(), height: self.view.height() - 64)
            viewAddDataPage.delegate = self
            viewAddDataPage.arrayList = arrayOfItems
            viewAddDataPage.tag = count
            viewAddDataPage.moduleType = self.moduleType
            viewAddDataPage.currentPage = Index
            viewAddDataPage.totalPage = roundedVal
            viewAddDataPage.monitoringParameterArray = monitoringParameterArray
            self.scrollPages.addSubview(viewAddDataPage)
            viewAddDataPage.updateView()
            xValue = xValue + self.view.width()
            count = count + 2
        }
        self.scrollPages.contentSize = CGSize(width: xValue, height: self.view.height() - 64)
        
    }
    func scrollToNextPage(page: Int) {
        if(self.moduleType == "Weight"){
            self.setPagesinScroll()
        }
        var frame: CGRect = self.scrollPages.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrollPages.scrollRectToVisible(frame, animated: true)
    }
    func scrollToPreviousPage(page: Int) {
        var frame: CGRect = self.scrollPages.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrollPages.scrollRectToVisible(frame, animated: true)
    }
    @IBAction func MonitoringParameters (_ sender : Any){
        if self.delegate is MonitoringDetailViewController {
            let MonitoringDetailVC : MonitoringDetailViewController = (self.delegate as! MonitoringDetailViewController)
            let MonitoringParameterVC : MonitoringParametersViewController = MonitoringParametersViewController(nibName : "MonitoringParametersViewController" , bundle : nil)
            MonitoringParameterVC.delegate = self
            MonitoringParameterVC.moduleType = self.moduleType as String
            MonitoringDetailVC.navigationController?.pushViewController(MonitoringParameterVC, animated: true)
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
