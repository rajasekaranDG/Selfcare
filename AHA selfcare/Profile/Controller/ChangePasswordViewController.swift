//
//  ChangePasswordViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 30/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {

    var delegate : AnyObject?
    @IBOutlet weak var textPassword : RPFloatingPlaceholderTextField!
    @IBOutlet weak var lblLinePassword : UILabel!
    @IBOutlet weak var lblErrorPassword : UILabel!
    @IBOutlet weak var textConfirmPassword : RPFloatingPlaceholderTextField!
    @IBOutlet weak var lblLineConfirmPassword : UILabel!
    @IBOutlet weak var lblErrorConfirmPassword : UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func isEmptyTextField(_ txt: String) -> Bool {
        return ((txt == "") || (txt.characters.count ) == 0)
    }

    @IBAction func registerClick(_ sender: Any) {
        
        if self.isEmptyTextField(self.textPassword.text!) {
            self.lblLinePassword.backgroundColor = UIColor.red
            self.lblErrorPassword.isHidden = false
        }
        else if self.isEmptyTextField(self.textConfirmPassword.text!) {
            self.lblLineConfirmPassword.backgroundColor = UIColor.red
            self.lblErrorConfirmPassword.isHidden = false
        }
        else if(self.textPassword.text! != self.textConfirmPassword.text!){
            self.showAlert(message: "New password and Confirm password is wrong")
        }
        else {
            let Parsedictionary: NSMutableDictionary = ["password": self.textPassword.text!,] as NSMutableDictionary
            
            
            let address = String(format: "%@user/%@/update",kAPIDOMAIN,AppManager.sharedInstance.userName()) as String
            let aUrl = URL(string:address)!
            var urlRequest = URLRequest(url: aUrl)
            
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.setValue(AppManager.sharedInstance.authendication(), forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let arraytest : NSMutableArray = []
            arraytest.add(Parsedictionary)
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let aDataParameter = try! JSONSerialization.data(withJSONObject: arraytest, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json = NSString(data: aDataParameter, encoding: String.Encoding.utf8.rawValue)
            if let json = json {
                print(json)
            }
            
            urlRequest.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
            Alamofire.request(urlRequest)
                .authenticate(user: AppManager.sharedInstance.userName(),password: AppManager.sharedInstance.userPassword())
                .responseJSON { response in
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers)
                        print(jsonObject)
                        let Success : NSString = AppManager.sharedInstance.checkDictionaryKeyValue(DetailDictionary: jsonObject as! NSMutableDictionary, key: "status") as NSString
                        if(Success.isEqual(to: "success")) {

                            let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                            viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
                            AppDelegate.appDelegate().window?.addSubview(viewAlert)
                            viewAlert.delegate = self
                            viewAlert.IndexTag = "101"
                            viewAlert.AlertType = "Text"
                            viewAlert.isSingle = true
                            viewAlert.AlertMessage = "Password update successfully"
                            viewAlert.UpdateDetailView()
                            viewAlert.alpha = 0
                            
                            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                                viewAlert.alpha = 1
                            }, completion: {(finished: Bool) -> Void in
                            })

                        }
                        else {
                            var message : NSString = AppManager.sharedInstance.checkDictionaryKeyValue(DetailDictionary: jsonObject as! NSMutableDictionary, key: "message") as NSString
                            if(message.isEqual(to:"")){
                                message = "password not changed"
                            }
                            self.showAlert(message: message as String)
                        }
                        
                    } catch let error {
                        print(error)
                    }
            }
            
        }
    }
    func closeView() {
        self.backClick("")
    }
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
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
