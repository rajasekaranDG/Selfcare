//
//  MonitoringViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

let kItemsPerCell = 2

class MonitoringViewController: UIViewController {

    var delegate : AnyObject?
    var monitoringArray = [[String: String]]()

    @IBOutlet weak var tableMonitoring : UITableView!
    
    @IBAction func MenuClick(_ sender : Any) {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
