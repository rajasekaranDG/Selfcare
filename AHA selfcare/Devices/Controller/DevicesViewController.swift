//
//  DevicesViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 12/07/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class DevicesViewController: UIViewController {

    var delegate : AnyObject?
    var mainViewController: UIViewController!

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
