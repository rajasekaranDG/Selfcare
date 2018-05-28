//
//  MessageViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 14/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    var delegate : AnyObject?
    
    @IBOutlet weak var labelMessage : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.labelMessage.text = "Welcome \(AppManager.sharedInstance.userName()) \n \n AHA Health App does not replace Doctor Advice and the Users or Patients must only use the app in conjunction with clinician's advice. \n \n AHA Health accept no responsibility for clinical use or misuse of this App."
        
    }
    @IBAction func continueClick(_ sender: Any) {
        let UpdateInfoVC : UpdateUserInfoViewController = UpdateUserInfoViewController(nibName : "UpdateUserInfoViewController" , bundle : nil)
        UpdateInfoVC.delegate = self
        self.navigationController?.pushViewController(UpdateInfoVC, animated: true)
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
