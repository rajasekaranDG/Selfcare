//
//  ObesityStartViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 07/07/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ObesityStartViewController: UIViewController {

    var delegate : AnyObject?
    
    @IBOutlet weak var labelMessage : UILabel!
    @IBOutlet weak var buttonStart : UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.labelMessage.text = "Please use this assessment to find out if you are of healthy weight.\n\nBody Mass Index(BMI) is a measure of body fat based on height and weight that applies to adult men and women.\n\nUnderweight = <18.5\nNormal weight = 18.5–24.9\nOverweight = 25–29.9\nObesity = BMI of 30 or greater"
        
        self.buttonStart.layer.cornerRadius = 6.0
        self.buttonStart.layer.borderWidth = 1
        self.buttonStart.layer.borderColor = UIColor(red: 42.0/255, green: 184.0/255, blue: 181.0/255, alpha: 1.0).cgColor

    }
    @IBAction func StartObesity(_ sender : Any) {
        let ObesityVC : ObesityViewController = ObesityViewController(nibName : "ObesityViewController" , bundle : nil)
        ObesityVC.delegate = self.delegate
        ObesityVC.delegateStart = self
        self.navigationController?.pushViewController(ObesityVC, animated: true)
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
