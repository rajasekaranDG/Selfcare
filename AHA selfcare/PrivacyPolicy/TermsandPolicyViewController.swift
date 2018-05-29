//
//  TermsandPolicyViewController.swift
//  AHA selfcare
//
//  Created by Leo Chelliah on 29/05/18.
//  Copyright © 2018 Sivachandiran. All rights reserved.
//

import UIKit

class TermsandPolicyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    
    var privacyArray = [String]()
    var mainViewController: UIViewController!
   
    @IBOutlet weak var tablePrivacy : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.tablePrivacy.register(UINib(nibName: "TermsandPrivacyTableViewCell", bundle: nil), forCellReuseIdentifier: "TermsandPrivacyTableViewCell")
        self.privacyArray = ["Terms & Conditions","Privacy Policy","End User License Ageement"]
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    
    // MARK:- TableView Delegates
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privacyArray.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150;
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermsandPrivacyTableViewCell", for: indexPath as IndexPath) as! TermsandPrivacyTableViewCell
        cell.selectionStyle = .none
        
        if(indexPath.row%2 == 0){
            cell.backgroundColor =  UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:240.0/255.0, alpha: 1.000)
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        cell.lblTitle.text = self.privacyArray[indexPath.row]
//        cell.buttonSelect.addTarget(self, action: #selector(AssessmentViewController.assessmentSelectClick(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
             let privacypolicyVC = PrivacyPolicyViewController(nibName : "PrivacyPolicyViewController" , bundle : nil)
            privacypolicyVC.urlString = "http://ahahealth.io/terms-and-conditions/"
            privacypolicyVC.titleString = "Terms and Conditions"
            self.navigationController?.pushViewController(privacypolicyVC, animated: true)
        }
        else if indexPath.row == 1 {
            
            let privacypolicyVC = PrivacyPolicyViewController(nibName : "PrivacyPolicyViewController" , bundle : nil)
            privacypolicyVC.urlString = "http://ahahealth.io/privacy-policy/"
            privacypolicyVC.titleString = "Privacy policy"
            self.navigationController?.pushViewController(privacypolicyVC, animated: true)
        }
        else if indexPath.row == 2 {
            
            let privacypolicyVC = PrivacyPolicyViewController(nibName : "PrivacyPolicyViewController" , bundle : nil)
            privacypolicyVC.urlString = "http://ahahealth.io/end-user-licence-agreement/"
            privacypolicyVC.titleString = "End User License Agreement"
            self.navigationController?.pushViewController(privacypolicyVC, animated: true)
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
