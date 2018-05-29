//
//  SignInViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 05/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrollViewMain : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var textUserName : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textPassword : RPFloatingPlaceholderTextField!
    @IBOutlet weak var lblLineUsername : UILabel!
    @IBOutlet weak var lblLinePassword : UILabel!
    @IBOutlet weak var lblErrorUsername : UILabel!
    @IBOutlet weak var lblErrorPassword : UILabel!
    @IBOutlet weak var buttonShow : UIButton!

    var data : NSMutableData = NSMutableData()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func BackClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if(textField == self.textUserName){
//            self.lblLineUsername.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
//            self.lblErrorUsername.isHidden = true
//        }
//        else if(textField == self.textPassword){
//            self.lblLinePassword.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
//            self.lblErrorPassword.isHidden = true
//        }
//    }
    @IBAction func showHidePassword(_ sender : UIButton){
        
        let btn = sender
        btn.isSelected = !btn.isSelected
        
        if(self.buttonShow.isSelected){
            self.textPassword.isSecureTextEntry = false
        }
        else {
            self.textPassword.isSecureTextEntry = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.textUserName.text = "d16"
//        self.textPassword.text = "123456"
        
        self.navigationController?.isNavigationBarHidden = true

        self.lblLineUsername.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePassword.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblErrorUsername.isHidden = true
        self.lblErrorPassword.isHidden = true

        self.textUserName.delegate = self
        self.textUserName.placeholder = "User name"
        self.textUserName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textUserName.floatingLabelInactiveTextColor = UIColor.gray

        self.textPassword.delegate = self
        self.textPassword.placeholder = "Password"
        self.textPassword.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textPassword.floatingLabelInactiveTextColor = UIColor.gray

        self.scrollViewMain.contentSizeToFit()
    }
    @IBAction func signInClick (_ sender: Any){
        
        self.lblLineUsername.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePassword.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblErrorUsername.isHidden = true
        self.lblErrorPassword.isHidden = true

        if((self.isEmptyTextField(self.textUserName.text!)) && (self.isEmptyTextField(self.textPassword.text!))){
            self.lblLineUsername.backgroundColor = UIColor.red
            self.lblLinePassword.backgroundColor = UIColor.red
            self.lblErrorUsername.isHidden = false
            self.lblErrorPassword.isHidden = false
            return
        }
        else if self.isEmptyTextField(self.textUserName.text!) {
            self.lblLineUsername.backgroundColor = UIColor.red
            self.lblErrorUsername.isHidden = false
            return
        }
        else if self.isEmptyTextField(self.textPassword.text!) {
            self.lblLinePassword.backgroundColor = UIColor.red
            self.lblErrorPassword.isHidden = false
            return
        }
        else {
            
            let username = self.textUserName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let aParameters : Parameters = ["username":username.lowercased(),"password":self.textPassword.text!]
            
            let stringURL : String = String(format : "%@user/authenticate",kAPIDOMAIN)
            let aUrl = URL(string:stringURL)!
            var urlRequest = URLRequest(url: aUrl)
            
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.setValue(AppManager.sharedInstance.authendication(), forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let aDataParameter = try! JSONSerialization.data(withJSONObject: aParameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let json = NSString(data: aDataParameter, encoding: String.Encoding.utf8.rawValue)
            if let json = json {
                print(json)
            }
            
            urlRequest.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    let Detail : NSDictionary = response.result.value as! NSDictionary
                    print(Detail)

                    let Status : NSString = Detail["status"] as! NSString
                    if Status.isEqual(to: "success"){
                        let UserDefaultsDetail = UserDefaults.standard
                        UserDefaultsDetail.setValue(username.lowercased() , forKey: "username")
                        UserDefaultsDetail.setValue(self.textPassword.text! , forKey: "password")
                        UserDefaultsDetail.synchronize()
                        
                        let userArray : NSArray = Detail["data"] as! NSArray
                        print(userArray)
                        if(userArray.count != 0){
                            let detailDictionary : NSDictionary = userArray[0] as! NSDictionary
                            let dictionarydetail : NSDictionary = detailDictionary["user"] as! NSDictionary
                            let detailDic : NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: dictionarydetail) as NSMutableDictionary
                            let stringDOB : String = AppManager.sharedInstance.conertDateToString(Date: AppManager.sharedInstance.dateFromMilliseconds(ms: detailDic["dataOfBirth"] as! NSNumber), formate: "yyyy-MM-dd")
                            
                            let UserDefaultsDetails = UserDefaults.standard
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.convertAge(birthDay: AppManager.sharedInstance.dateFromMilliseconds(ms: detailDic["dataOfBirth"] as! NSNumber)) , forKey: "userage")
                            UserDefaultsDetails.setValue(stringDOB as String , forKey: "dataOfBirth")
                            UserDefaultsDetails.setValue(detailDic["email"] as? String , forKey: "email")
                            UserDefaultsDetails.setValue(detailDic["gender"] as? String , forKey: "gender")
                           
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic , key: "height") as String , forKey: "height")
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic , key: "weight") as String , forKey: "weight")
                            UserDefaultsDetails.setValue(detailDic["govtId"] as? String , forKey: "govtId")
                            UserDefaultsDetails.setValue(detailDic["firstName"] as? String , forKey: "firstName")
                            UserDefaultsDetails.setValue(detailDic["lastname"] as? String , forKey: "lastname")
                            UserDefaultsDetails.setValue(detailDic["country"] as? String , forKey: "country")
                            UserDefaultsDetails.setValue(detailDic["city"] as? String , forKey: "city")
                            UserDefaultsDetails.setValue(detailDic["state"] as? String , forKey: "state")
                            UserDefaultsDetails.setValue(detailDic["postalCode"] as? String , forKey: "postalCode")
                            UserDefaultsDetails.setValue(detailDic["mobile"] as? String , forKey: "mobile")
                            UserDefaultsDetails.setValue(detailDic["appVersion"] as? String , forKey: "appVersion")
                            UserDefaultsDetails.setValue(detailDic["referralCode"] as? String , forKey: "referralCode")
                            UserDefaultsDetails.setValue(detailDic["versionNo"] as? String , forKey: "versionNo")
                            UserDefaultsDetails.synchronize()//detailDic["height"]
                            
                            let stringAgree : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic , key: "agree") as NSString
                            let stringActivated : NSString = AppManager.sharedInstance.checkNumberString(DetailDictionary: detailDic , key: "general") as NSString

                            if((stringAgree.isEqual(to: "0")) && (stringActivated.isEqual(to: "0"))){
                                let MeassageVC : MessageViewController = MessageViewController(nibName : "MessageViewController" , bundle : nil)
                                MeassageVC.delegate = self
                                self.navigationController?.pushViewController(MeassageVC, animated: true)
                            }
                            else if((stringAgree.isEqual(to: "1")) && (stringActivated.isEqual(to: "1"))){
                                (UIApplication.shared.delegate as! AppDelegate).initSetView()
                            }
                            else if (stringAgree.isEqual(to: "0")){
                                let MeassageVC : MessageViewController = MessageViewController(nibName : "MessageViewController" , bundle : nil)
                                MeassageVC.delegate = self
                                self.navigationController?.pushViewController(MeassageVC, animated: true)
                            }
                            else if(stringActivated.isEqual(to: "0")){
                                let UpdateInfoVC : UpdateUserInfoViewController = UpdateUserInfoViewController(nibName : "UpdateUserInfoViewController" , bundle : nil)
                                UpdateInfoVC.delegate = self
                                self.navigationController?.pushViewController(UpdateInfoVC, animated: true)
                            }

                        }
                        else {
                            
                        }
//                        (UIApplication.shared.delegate as! AppDelegate).initSetView()
                    }
                    else {
                        
                        let aErrMessage = Detail["applicationMessage"] as! String
                        self.showAlert(message: aErrMessage)
                    }
            }
        }
    }
    @IBAction func forgotPasswordClick (_ sender: Any){
        let ForgotPasswordVC : ForgotPasswordViewController = ForgotPasswordViewController(nibName : "ForgotPasswordViewController" , bundle : nil)
        ForgotPasswordVC.delegate = self
        self.navigationController?.pushViewController(ForgotPasswordVC, animated: true)
    }
    @IBAction func signupClick (_ sender: Any){
        let SignupVC : SignupViewController = SignupViewController(nibName : "SignupViewController" , bundle : nil)
        self.navigationController?.pushViewController(SignupVC, animated: true)
    }
    func isEmptyTextField(_ txt: String) -> Bool {
        return ((txt == "") || (txt.count ) == 0)
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
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
