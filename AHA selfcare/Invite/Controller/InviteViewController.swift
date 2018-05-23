//
//  InviteViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 02/08/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    var delegate : AnyObject?
    var mainViewController: UIViewController!

    @IBOutlet weak var lblCode : UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        let viewInvite: ViewInvite = (Bundle .main.loadNibNamed("ViewInvite", owner: self, options: nil)![0] as! ViewInvite)
        viewInvite.frame = CGRect(x: 0, y: 80, width: self.view.width(), height: self.view.height() - 80)
        viewInvite.delegate = self
        self.view.addSubview(viewInvite)
        viewInvite.lblCode.text = AppManager.sharedInstance.referralCode()
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
