//
//  RecordsViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 14/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {

    var delegate : AnyObject?
    
    @IBOutlet weak var labelEmpty : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK:- Button Actions
    
    @IBAction func MenuClick(_ sender : Any) {
       
        if self.delegate is StartMonitoringViewController {
            let StartMonitoringVC : StartMonitoringViewController = (self.delegate as! StartMonitoringViewController)
            StartMonitoringVC.menuClick("")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension RecordsViewController : SlideMenuControllerDelegate {
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

