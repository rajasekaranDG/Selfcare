//
//  EditProfileViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 30/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PhoneNumberKit

class EditProfileViewController: UIViewController,UITextFieldDelegate {

    var delegate : AnyObject?
    var genderString : NSString = ""
    var stringDOB : NSString = ""

    @IBOutlet weak var scrollViewMain : TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var textFirstName : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textLastName : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textEmail : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textPhoneNumber : PhoneNumberTextField!
    @IBOutlet weak var lableDateOfBirth : UILabel!
    @IBOutlet weak var textID : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textHeigth : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textWeight : RPFloatingPlaceholderTextField!
    @IBOutlet weak var lableGender : UILabel!
    @IBOutlet weak var textCountry : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textState : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textCity  : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textPincode : RPFloatingPlaceholderTextField!
    
    @IBOutlet weak var viewTeams : UIView!
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var lblLineFirstname : UILabel!
    @IBOutlet weak var lblLineLastname : UILabel!
    @IBOutlet weak var lblLineEmail : UILabel!
    @IBOutlet weak var lblLinePhone : UILabel!
    @IBOutlet weak var lblLineDOB : UILabel!
    @IBOutlet weak var lblLineID : UILabel!
    @IBOutlet weak var lblLineHeight : UILabel!
    @IBOutlet weak var lblLineWeight : UILabel!
    @IBOutlet weak var lblLineGender : UILabel!
    @IBOutlet weak var lblLineState : UILabel!
    @IBOutlet weak var lblLineCountry : UILabel!
    @IBOutlet weak var lblLineCity : UILabel!
    @IBOutlet weak var lblLinePincode : UILabel!
    
    @IBOutlet weak var lblErrorFirstname : UILabel!
    @IBOutlet weak var lblErrorLastname : UILabel!
    @IBOutlet weak var lblErrorEmail : UILabel!
    @IBOutlet weak var lblErrorPhone : UILabel!
    @IBOutlet weak var lblErrorDOB : UILabel!
    @IBOutlet weak var lblErrorID : UILabel!
    @IBOutlet weak var lblErrorGender : UILabel!
    @IBOutlet weak var lblErrorHeight : UILabel!
    @IBOutlet weak var lblErrorWeight : UILabel!
    @IBOutlet weak var lblErrorCountry : UILabel!
    @IBOutlet weak var lblErrorState : UILabel!
    @IBOutlet weak var lblErrorCity : UILabel!
    @IBOutlet weak var lblErrorPincode : UILabel!
    
    @IBOutlet weak var lblGender : UILabel!
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
        
        if range.length + range.location > textField.text!.characters.count {
            return false
        }
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.lblMobileNumber.isHidden = false
        self.lblMobileNumber.setY(-3)
        self.lblMobileNumber.alpha = 1.0

        self.lblGender.isHidden = false
        self.lblGender.setY(-3)
        self.lblGender.alpha = 1.0

        self.lableDateOfBirth.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        self.lblDOB.setY(-3)
        self.lblDOB.isHidden = false

        self.lableGender.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)

        self.stringDOB = AppManager.sharedInstance.userDOB() as NSString
        self.textFirstName.text = AppManager.sharedInstance.userFirstName()
        self.textLastName.text = AppManager.sharedInstance.userLastName()
        self.textEmail.text = AppManager.sharedInstance.userMail()
        self.textPhoneNumber.text = AppManager.sharedInstance.userMobile()
        let srtingDate : String = AppManager.sharedInstance.userDOB()
        if srtingDate != "" {
            self.lableDateOfBirth.text = AppManager.sharedInstance.conertDateStringToString2(Date: AppManager.sharedInstance.userDOB(), Format: "dd-MM-yyyy")
        }
        else {
            self.lableDateOfBirth.textColor = UIColor(red: 180.0/255, green: 180.0/255, blue: 180.0/255, alpha: 1.0)
        }
        self.lableGender.text = AppManager.sharedInstance.userGender()
        self.textHeigth.text = String(format: "%@",AppManager.sharedInstance.userHeight())
        self.textWeight.text = String(format: "%@",AppManager.sharedInstance.userWeight())
        self.textID.text = AppManager.sharedInstance.userGovtId()
        self.textCity.text = AppManager.sharedInstance.userCity()
        self.textState.text = AppManager.sharedInstance.userState()
        self.textCountry.text = AppManager.sharedInstance.userCountry()
        self.textPincode.text = AppManager.sharedInstance.userPostalCode()
        self.genderString = AppManager.sharedInstance.userGender() as NSString
        
        self.textFirstName.placeholder = "Enter first name"
        self.textFirstName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textFirstName.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textLastName.placeholder = "Enter last name"
        self.textLastName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textLastName.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textEmail.placeholder = "Enter email"
        self.textEmail.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textEmail.floatingLabelInactiveTextColor = UIColor.gray

        self.textID.placeholder = "Enter ID (NHS/AHA)"
        self.textID.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textID.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textHeigth.placeholder = "Enter Height (Cm)"
        self.textHeigth.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textHeigth.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textWeight.placeholder = "Enter Weight (Kg)"
        self.textWeight.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textWeight.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textCountry.placeholder = "Enter Country"
        self.textCountry.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textCountry.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textState.placeholder = "Enter State/County"
        self.textState.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textState.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textCity.placeholder = "Enter City"
        self.textCity.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textCity.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textPincode.placeholder = "Enter postalCode"
        self.textPincode.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textPincode.floatingLabelInactiveTextColor = UIColor.gray
        
        self.lblLineFirstname.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineLastname.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineEmail.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePhone.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineDOB.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineID.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineHeight.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineWeight.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineCountry.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineState.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineCity.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePincode.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        
        self.lblErrorFirstname.isHidden = true
        self.lblErrorLastname.isHidden = true
        self.lblErrorEmail.isHidden = true
        self.lblErrorPhone.isHidden = true
        self.lblErrorDOB.isHidden = true
        self.lblErrorID.isHidden = true
        self.lblErrorHeight.isHidden = true
        self.lblErrorWeight.isHidden = true
        self.lblErrorGender.isHidden = true
        self.lblErrorCountry.isHidden = true
        self.lblErrorState.isHidden = true
        self.lblErrorCity.isHidden = true
        self.lblErrorPincode.isHidden = true
        
        self.lblDOB.textColor = UIColor.gray
        self.lblMobileNumber.textColor = UIColor.gray
        self.lblGender.textColor = UIColor.gray
        self.scrollViewMain.contentSizeToFit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    func handleKeyboard(notification:NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                self.viewBottom.setY(self.view.height() - ((keyboardFrame?.height)! + 50))
            })
        }
    }
    func handleHideKeyboard(notification:NSNotification){
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.viewBottom.setY(self.view.height() - 50)
        })
    }
    @IBAction func genderSelect(_ sender : UIButton) {
        if(sender.tag == 1){
            self.genderString = "Male"
            self.lableGender.text = "Male"
            self.lableGender.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        }
        else if(sender.tag == 2){
            self.genderString = "Female"
            self.lableGender.text = "Female"
            self.lableGender.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.000)
        }
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
        
        self.lblDOB.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.lblDOB.setY(-3)
        }, completion: {(finished: Bool) -> Void in
        })
    }
    func isEmptyTextField(_ txt: String) -> Bool {
        return ((txt == "") || (txt.characters.count ) == 0)
    }
    func isValidEmail(_ checkString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: checkString)
    }
    @IBAction func registerClick(_ sender: Any) {
        
//        if self.isEmptyTextField(self.textFirstName.text!) {
//            self.lblLineFirstname.backgroundColor = UIColor.red
//            self.lblErrorFirstname.isHidden = false
//        }
//        if self.isEmptyTextField(self.textLastName.text!) {
//            self.lblLineLastname.backgroundColor = UIColor.red
//            self.lblErrorLastname.isHidden = false
//        }
//        if self.isEmptyTextField(self.textID.text!) {
//            self.lblLineID.backgroundColor = UIColor.red
//            self.lblErrorID.isHidden = false
//        }
//        if self.stringDOB == "" {
//            self.lblLineDOB.backgroundColor = UIColor.red
//            self.lblErrorDOB.isHidden = false
//        }
//        if self.isEmptyTextField(self.textHeigth.text!) {
//            self.lblLineHeight.backgroundColor = UIColor.red
//            self.lblErrorHeight.isHidden = false
//        }
//        if self.isEmptyTextField(self.textWeight.text!) {
//            self.lblLineWeight.backgroundColor = UIColor.red
//            self.lblErrorWeight.isHidden = false
//        }
//        if self.lableGender.text! == "Enter Your Gender" {
//            self.lblLineGender.backgroundColor = UIColor.red
//            self.lblErrorGender.isHidden = false
//        }
//        if self.isEmptyTextField(self.textID.text!) {
//            self.lblLineID.backgroundColor = UIColor.red
//            self.lblErrorID.isHidden = false
//        }
//        if self.isEmptyTextField(self.textCountry.text!) {
//            self.lblLineCountry.backgroundColor = UIColor.red
//            self.lblErrorCountry.isHidden = false
//        }
//        if self.isEmptyTextField(self.textState.text!) {
//            self.lblLineState.backgroundColor = UIColor.red
//            self.lblErrorState.isHidden = false
//        }
//        if self.isEmptyTextField(self.textCity.text!) {
//            self.lblLineCity.backgroundColor = UIColor.red
//            self.lblErrorCity.isHidden = false
//        }
//        if self.isEmptyTextField(self.textPincode.text!) {
//            self.lblLinePincode.backgroundColor = UIColor.red
//            self.lblErrorPincode.isHidden = false
//        }
        self.view.endEditing(true)
        if(!(self.isEmptyTextField(self.textFirstName.text!)) && !(self.isEmptyTextField(self.textHeigth.text!)) && !(self.isEmptyTextField(self.textWeight.text!)) && !(self.isEmptyTextField(self.textCountry.text!)) && !(self.isEmptyTextField(self.textState.text!)) && !(self.isEmptyTextField(self.textCity.text!)) && !(self.isEmptyTextField(self.textPincode.text!))){
            
            let HeightInt = Double(self.textHeigth.text!)
            let HeightNumber = NSNumber(value:HeightInt!)
            let WeightInt = Double(self.textWeight.text!)
            let WeightNumber = NSNumber(value:WeightInt!)
            
            let Parsedictionary: NSMutableDictionary = ["firstName": self.textFirstName.text!,
                                                        "lastname": self.textLastName.text!,
                                                        "email": self.textEmail.text!,
                                                        "mobile": self.textPhoneNumber.text!,
                                                        "dataOfBirth": self.stringDOB,
                                                        "height": HeightNumber,
                                                        "weight": WeightNumber,
                                                        "govtId": self.textID.text!,
                                                        "gender": self.genderString,
                                                        "country": self.textCountry.text!,
                                                        "state": self.textState.text!,
                                                        "city": self.textCity.text!,
                                                        "postalCode": self.textPincode.text!,] as NSMutableDictionary
            
            
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
                            
                            
                            let UserDefaultsDetails = UserDefaults.standard
                            
                            UserDefaultsDetails.setValue(AppManager.sharedInstance.convertAge(birthDay: AppManager.sharedInstance.ConertDateStringToDate(Date: self.stringDOB as String, Format: "yyyy-MM-dd HH:mm:ss") as NSDate) , forKey: "userage")
                            UserDefaultsDetails.setValue(self.stringDOB , forKey: "dataOfBirth")
                            UserDefaultsDetails.setValue(self.textEmail.text! , forKey: "email")
                            UserDefaultsDetails.setValue(self.genderString , forKey: "gender")
                            UserDefaultsDetails.setValue(self.textHeigth.text! , forKey: "height")
                            UserDefaultsDetails.setValue(self.textWeight.text! , forKey: "weight")
                            UserDefaultsDetails.setValue(self.textID.text! , forKey: "govtId")
                            UserDefaultsDetails.setValue(self.textFirstName.text! , forKey: "firstName")
                            UserDefaultsDetails.setValue(self.textLastName.text! , forKey: "lastname")
                            UserDefaultsDetails.setValue(self.textCountry.text! , forKey: "country")
                            UserDefaultsDetails.setValue(self.textCity.text! , forKey: "city")
                            UserDefaultsDetails.setValue(self.textState.text! , forKey: "state")
                            UserDefaultsDetails.setValue(self.textPincode.text! , forKey: "postalCode")
                            UserDefaultsDetails.setValue(self.textPhoneNumber.text! , forKey: "mobile")
                            UserDefaultsDetails.synchronize()
                            
                            if self.delegate is ProfileViewController {
                                let ProfileVC : ProfileViewController = (self.delegate as! ProfileViewController)
                                ProfileVC.updateInformation()
                            }
                            let viewAlert: ViewAlertMessage = (Bundle.main.loadNibNamed("ViewAlertMessage", owner: self, options: nil)![0] as! ViewAlertMessage)
                            viewAlert.frame = (AppDelegate.appDelegate().window?.bounds)!
                            AppDelegate.appDelegate().window?.addSubview(viewAlert)
                            viewAlert.delegate = self
                            viewAlert.IndexTag = "101"
                            viewAlert.AlertType = "Text"
                            viewAlert.isSingle = true
                            viewAlert.AlertMessage = "Information update successfully"
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
                                message = "username already registered"
                            }
                            self.showAlert(message: message as String)
                        }
                        
                    } catch let error {
                        print(error)
                    }
            }
            
        }
        else {
            self.showAlert(message: "Please enter the all field")
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
    func closeView() {
        self.backClick("")
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
