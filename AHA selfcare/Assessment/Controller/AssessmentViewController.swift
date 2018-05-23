//
//  AssessmentViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class AssessmentViewController: UIViewController {

    var delegate : AnyObject?
    var assessmentArray = [[String: String]]()
    
    @IBOutlet weak var tableAssessment : UITableView!
    
    @IBAction func MenuClick(_ sender : Any) {
//        if self.delegate is StartMonitoringViewController {
//            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
//            StartMonitoringVC.AssessmentClick("")
//        }
        
        if self.delegate is StartMonitoringViewController {
            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoringVC.menuClick("")
        }
    }
    func goMonitoringHome() {
        if self.delegate is StartMonitoringViewController {
            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoringVC.AssessmentClick("")
        }
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableAssessment.register(UINib(nibName: "CellAssessment", bundle: nil), forCellReuseIdentifier: "CellAssessmentID")
        self.assessmentArray = [["Image": "obesity.png","Title": "Obesity"],
                                ["Image": "cardiovascular.png", "Title": "Cardiovascular"],
//                                ["Image": "caregiver.png", "Title": "CareGiver"],
                                ["Image": "diabetes.png", "Title": "Diabetes"]]
        self.tableAssessment.reloadData()
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assessmentArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150;
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAssessmentID", for: indexPath as IndexPath) as! CellAssessment
        cell.selectionStyle = .none
        
        if(indexPath.row%2 == 0){
            cell.backgroundColor =  UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:240.0/255.0, alpha: 1.000)
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        cell.lblTitle.text = self.assessmentArray[indexPath.row]["Title"]
        cell.imageIcon.image = UIImage(named: self.assessmentArray[indexPath.row]["Image"]!)
        cell.buttonSelect.tag = indexPath.row
        cell.buttonSelect.addTarget(self, action: #selector(AssessmentViewController.assessmentSelectClick(_:)), for: .touchUpInside)

        return cell
    }
    func assessmentSelectClick (_ sender: UIButton) {
        let stringTitle : String = self.assessmentArray[sender.tag]["Title"]!
        if(stringTitle == "Obesity"){
            
            if(AppManager.sharedInstance.obesityStartFlag() == ""){
                let UserDefaultsDetails = UserDefaults.standard
                UserDefaultsDetails.setValue("Y" , forKey: "obesityStartFlag")
                UserDefaultsDetails.synchronize()

                let StartObesityVC : ObesityStartViewController = ObesityStartViewController(nibName : "ObesityStartViewController" , bundle : nil)
                StartObesityVC.delegate = self
                self.navigationController?.pushViewController(StartObesityVC, animated: true)
            }
            else {
                let ObesityVC : ObesityViewController = ObesityViewController(nibName : "ObesityViewController" , bundle : nil)
                ObesityVC.delegate = self
                ObesityVC.delegateStart = self
                self.delegate?.navigationController??.pushViewController(ObesityVC, animated: true)
            }
        }
        else if(stringTitle == "Cardiovascular"){
            let CardiovascularVC : CardiovascularViewController = CardiovascularViewController(nibName : "CardiovascularViewController" , bundle : nil)
            CardiovascularVC.delegate = self
            self.delegate?.navigationController??.pushViewController(CardiovascularVC, animated: true)
        }
        else if(stringTitle == "Diabetes"){
//            let DiabetesVC : DiabetesViewController = DiabetesViewController(nibName : "DiabetesViewController" , bundle : nil)
//            DiabetesVC.delegate = self
//            self.delegate?.navigationController??.pushViewController(DiabetesVC, animated: true)
            let aViewController : ComingSoonViewController = ComingSoonViewController(nibName : "ComingSoonViewController" , bundle : nil)
            self.delegate?.navigationController??.pushViewController(aViewController, animated: true)
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

