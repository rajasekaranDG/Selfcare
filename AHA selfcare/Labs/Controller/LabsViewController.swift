//
//  LabsViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 05/08/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class LabsViewController: UIViewController {

    var delegate : AnyObject?
    var mainViewController: UIViewController!

    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func menGold(_ sender : Any) {
        let LabDetailVC : LabDetailViewController = LabDetailViewController(nibName: "LabDetailViewController", bundle : nil)
        LabDetailVC.delegate = self
        LabDetailVC.stringType = "Wellness Gold Male"
        self.navigationController?.pushViewController(LabDetailVC, animated: true)

    }
    @IBAction func femeleGold(_ sender : Any) {
        let LabDetailVC : LabDetailViewController = LabDetailViewController(nibName: "LabDetailViewController", bundle : nil)
        LabDetailVC.delegate = self
        LabDetailVC.stringType = "Wellness Gold Female"
        self.navigationController?.pushViewController(LabDetailVC, animated: true)

    }
    @IBAction func menPlatium(_ sender : Any) {
        let LabDetailVC : LabDetailViewController = LabDetailViewController(nibName: "LabDetailViewController", bundle : nil)
        LabDetailVC.delegate = self
        LabDetailVC.stringType = "Wellness Platium Male"
        self.navigationController?.pushViewController(LabDetailVC, animated: true)

    }
    @IBAction func femelePlatium(_ sender : Any) {
        let LabDetailVC : LabDetailViewController = LabDetailViewController(nibName: "LabDetailViewController", bundle : nil)
        LabDetailVC.delegate = self
        LabDetailVC.stringType = "Wellness Platium Female"
        self.navigationController?.pushViewController(LabDetailVC, animated: true)
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
