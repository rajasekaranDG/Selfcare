//
//  SignupViewController.swift
//  CCMC_User
//
//  Created by Sivachandiran on 03/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import PhoneNumberKit

class SignupViewController: UIViewController,UITextFieldDelegate {

    var delegate : AnyObject?
    var stringDOB : NSString = ""
    var isAgreeTerms = false
    
    
    @IBOutlet weak var scrollViewMain : TPKeyboardAvoidingScrollView!
    @IBOutlet weak var imagePhoto : UIImageView!
    @IBOutlet weak var buttonUpload : UIButton!
    @IBOutlet weak var buttonCancel : UIButton!
    
    @IBOutlet weak var textName : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textEmail : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textPassword : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textPhoneNumber : PhoneNumberTextField!
    @IBOutlet weak var lableDateOfBirth : UILabel!
    @IBOutlet weak var viewTeams : UIView!
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var lblLineUsername : UILabel!
    @IBOutlet weak var lblLineEmail : UILabel!
    @IBOutlet weak var lblLinePassword : UILabel!
    @IBOutlet weak var lblLinePhone : UILabel!
    @IBOutlet weak var lblLineDOB : UILabel!
    @IBOutlet weak var lblErrorUsername : UILabel!
    @IBOutlet weak var lblErrorEmail : UILabel!
    @IBOutlet weak var lblErrorPassword : UILabel!
    @IBOutlet weak var lblErrorPhone : UILabel!
    @IBOutlet weak var lblErrorDOB : UILabel!
    @IBOutlet weak var lblDOB : UILabel!
    @IBOutlet weak var lblMobileNumber : UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if range.length + range.location > textField.text!.characters.count {
            return false
        }
        if(textField == self.textPhoneNumber){
            let newLength = textField.text!.characters.count + string.characters.count - range.length
            if(newLength > 0){
                self.lblMobileNumber.isHidden = false
                UIView.animate(withDuration: 0.4, animations: {() -> Void in
                    self.lblMobileNumber.setY(-3)
                    self.lblMobileNumber.alpha = 1.0
                }, completion: {(finished: Bool) -> Void in
                })
            }
            else {
                UIView.animate(withDuration: 0.4, animations: {() -> Void in
                    self.lblMobileNumber.setY(20)
                    self.lblMobileNumber.alpha = 0.0
                }, completion: {(finished: Bool) -> Void in
                    self.lblMobileNumber.isHidden = true
                })
            }
            if(newLength > 0){
                self.lblErrorPhone.isHidden = true
            }
            else {
                self.lblErrorPhone.isHidden = false
            }
            let maxLength = 16
            return txtAfterUpdate.count <= maxLength
        }
        else if(textField == self.textName){
            let newLength = textField.text!.count + string.count - range.length
            if(newLength > 0){
                self.lblErrorUsername.isHidden = true
            }
            else {
                self.lblErrorUsername.isHidden = false
            }
            let maxLength = 24
            return txtAfterUpdate.count <= maxLength
        }
        else if(textField == self.textEmail){
            let newLength = textField.text!.count + string.count - range.length
            if(newLength > 0){
                self.lblErrorEmail.isHidden = true
            }
            else {
                self.lblErrorEmail.isHidden = false
            }
        }
        else if(textField == self.textPassword){
            let newLength = textField.text!.count + string.characters.count - range.length
            if(newLength > 0){
                self.lblErrorPassword.isHidden = true
            }
            else {
                self.lblErrorPassword.isHidden = false
            }
        }
        return true
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.textName.delegate = self
        self.textEmail.delegate = self
        self.textPassword.delegate = self
        self.textName.delegate = self

        self.scrollViewMain.contentSizeToFit()
        self.lblMobileNumber.alpha = 1.0

        self.textName.placeholder = "Enter username"
        self.textName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textName.floatingLabelInactiveTextColor = UIColor.gray

        self.textEmail.placeholder = "Enter email"
        self.textEmail.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textEmail.floatingLabelInactiveTextColor = UIColor.gray

        self.textPassword.placeholder = "Enter password"
        self.textPassword.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textPassword.floatingLabelInactiveTextColor = UIColor.gray

//        self.textPhoneNumber.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
//        self.textPhoneNumber.floatingLabelInactiveTextColor = UIColor.gray

        self.lblLineUsername.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineEmail.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePassword.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePhone.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineDOB.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblErrorUsername.isHidden = true
        self.lblErrorEmail.isHidden = true
        self.lblErrorPassword.isHidden = true
        self.lblErrorPhone.isHidden = true
        self.lblErrorDOB.isHidden = true

        self.lblDOB.textColor = UIColor.gray
        self.lblMobileNumber.textColor = UIColor.gray
        
    }
    @IBAction func dateOfBirth(_ sender : Any) {
        
        self.view.endEditing(true)
        let viewDatePicker: ViewDatePicker = (Bundle .main.loadNibNamed("ViewDatePicker", owner: self, options: nil)![0] as! ViewDatePicker)
        viewDatePicker.delegate = self
        viewDatePicker.typeString = "DOB"
        viewDatePicker.TitleString = "Date of Birth"
        viewDatePicker.UpdateView()
        viewDatePicker.frame = CGRect(x: 0, y: self.view.height(), width: self.view.width(), height: self.view.height())
        self.view .addSubview(viewDatePicker)
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            viewDatePicker.setY(0)
        }, completion: {(finished: Bool) -> Void in
            
        })
    }
    func updateDetail(selectDate : String) {
        
        self.lableDateOfBirth.text = AppManager.sharedInstance.conertDateStringToString2(Date: selectDate, Format: "dd-MM-yyyy")
        self.stringDOB = selectDate as NSString
        self.lableDateOfBirth.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        self.lblErrorDOB.isHidden = true

        self.lblDOB.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lblDOB.setY(-3)
        }, completion: {(finished: Bool) -> Void in
        })
    }
    func isEmptyTextField(_ txt: String) -> Bool {
        return ((txt == "") || (txt.count ) == 0)
    }
    func isValidEmail(_ checkString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: checkString)
    }
    @IBAction func registerClick(_ sender: Any) {
        
        if self.isEmptyTextField(self.textName.text!) {
            self.lblLineUsername.backgroundColor = UIColor.red
            self.lblErrorUsername.isHidden = false
        }
        if self.isEmptyTextField(self.textEmail.text!) {
            self.lblErrorEmail.backgroundColor = UIColor.red
            self.lblErrorEmail.isHidden = false
            self.lblErrorEmail.text = "Enter email id"
            return
        }
        if !self.isValidEmail(self.textEmail.text!) {
            self.lblLineEmail.backgroundColor = UIColor.red
            self.lblErrorEmail.isHidden = false
            self.lblErrorEmail.text = "Enter valid email id"
            return
        }
        if self.isEmptyTextField(self.textPassword.text!) {
            self.lblLinePassword.backgroundColor = UIColor.red
            self.lblErrorPassword.isHidden = false
            self.lblErrorPassword.text = "Enter Password"
        }
        if (self.textPassword.text?.count)! < 6 {
            self.lblLinePassword.backgroundColor = UIColor.red
            self.lblErrorPassword.isHidden = false
            self.lblErrorPassword.text = "Enter minimum 6 characters"
            return
        }
        if self.isEmptyTextField(self.textPhoneNumber.text!) {
            self.lblLinePhone.backgroundColor = UIColor.red
            self.lblErrorPhone.isHidden = false
        }
        if self.stringDOB == "" {
            self.lblLineDOB.backgroundColor = UIColor.red
            self.lblErrorDOB.isHidden = false
        }
        if(!(self.isEmptyTextField(self.textName.text!)) && (self.isValidEmail(self.textEmail.text!)) && !(self.isEmptyTextField(self.textPassword.text!)) && !(self.isEmptyTextField(self.textPhoneNumber.text!)) && !(self.isEmptyTextField(self.lableDateOfBirth.text!)) && (self.lableDateOfBirth.text != "Enter Your Date Of Birth")) && isAgreeTerms != false {

            let uname = self.textName.text!.lowercased()
            let Parsedictionary: NSMutableDictionary = ["_id": uname,
                                                        "email": self.textEmail.text!,
                                                        "password": self.textPassword.text!,
                                                        "mobile": self.textPhoneNumber.text!,
                                                        "dataOfBirth": self.stringDOB,
                                                        "referrercode": "ea1",
                                                        "firstName": "",
                                                        "lastname": "",
                                                        "govtId": "",
                                                        "_class": "com.selfcare.shared.data.User",
                                                        "profile": "Patient",
                                                        "healthProfile": "Diabetes",
                                                        "versionNo": 0,
                                                        "gender": "",
                                                        "country": "",
                                                        "state": "",
                                                        "city": "",
                                                        "postalCode": "",
                                                        "height": 0,
                                                        "weight": 0,] as NSMutableDictionary
            Parsedictionary.setObject(AppManager.sharedInstance.subuserCreate(Dic: Parsedictionary), forKey: "data" as NSCopying)
            
            let address = String(format: "%@user/create",kAPIDOMAIN) as String
            let aUrl = URL(string:address)!
            var urlRequest = URLRequest(url: aUrl)
            
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            //            urlRequest.setValue(AppManager.sharedInstance.authendication(), forHTTPHeaderField: "Authorization")
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
                            viewAlert.AlertMessage = "Please check your email. Confirm by clicking the link and log back in"
                            viewAlert.UpdateDetailView()
                            viewAlert.alpha = 0
                            
                            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                                viewAlert.alpha = 1
                            }, completion: {(finished: Bool) -> Void in
                            })

//                            let UserDefaultsDetails = UserDefaults.standard
//                            UserDefaultsDetails.setValue(self.textName.text! , forKey: "username")
//                            UserDefaultsDetails.setValue(self.textPassword.text! , forKey: "password")
//                            UserDefaultsDetails.synchronize()
//
                        }
                        else {
                            var message : NSString = AppManager.sharedInstance.checkDictionaryKeyValue(DetailDictionary: jsonObject as! NSMutableDictionary, key: "applicationMessage") as NSString
                            if(message.isEqual(to:"")){
                                message = "Provide a different user id as this user already exists."
                            }
                            self.showAlert(message: message as String)
                        }
                        
                    } catch let error {
                        print(error)
                    }
                    
            }
            
        }
        else if isAgreeTerms == false {
//             self.showAlert(message: "Please " as String)
        }
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
    func gobackLoginPage() {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- Button Action
    @IBAction func didTapOnReadPolicy(_ sender: UIButton) {
        
        let SignupVC : ReadPolicyViewController = ReadPolicyViewController(nibName : "ReadPolicyViewController" , bundle : nil)
        self.navigationController?.pushViewController(SignupVC, animated: true)
        
       
    }
     @IBAction func btnTermsandConditionTapped(_ sender: UIButton) {
        
        let btn = sender
        
        btn.isSelected = !btn.isSelected
        
        isAgreeTerms = false
        if btn.isSelected {
            isAgreeTerms = true
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
