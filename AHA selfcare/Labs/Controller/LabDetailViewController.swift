//
//  LabDetailViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 06/08/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class LabDetailViewController: UIViewController {

    var delegate : AnyObject?
    var stringType : NSString = ""
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var imageIcon : UIImageView!

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(stringType.isEqual(to: "Wellness Gold Male")){
            self.labelTitle.text = "Wellness Gold Male"
            imageIcon.image = UIImage(named: "gold_male.jpg")
        }
        else if(stringType.isEqual(to: "Wellness Gold Female")){
            self.labelTitle.text = "Wellness Gold Female"
            imageIcon.image = UIImage(named: "gold_female.jpg")
        }
        else if(stringType.isEqual(to: "Wellness Platium Male")){
            self.labelTitle.text = "Wellness Platium Male"
            imageIcon.image = UIImage(named: "plat_male.jpg")
        }
        else if(stringType.isEqual(to: "Wellness Platium Female")){
            self.labelTitle.text = "Wellness Platium Female"
            imageIcon.image = UIImage(named: "plat_female.jpg")
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
