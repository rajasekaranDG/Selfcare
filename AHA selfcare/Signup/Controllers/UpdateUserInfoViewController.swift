//
//  UpdateUserInfoViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 29/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var NAMELIMIT = 24
var HEIGHTLIMIT = 6
var POSTAlCODELIMIT = 10

class UpdateUserInfoViewController: UIViewController,UITextFieldDelegate {

    var delegate : AnyObject?
    var genderString : NSString = ""
    
    
    @IBOutlet weak var scrollViewMain : TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var textFirstName : RPFloatingPlaceholderTextField!
    @IBOutlet weak var textLastName : RPFloatingPlaceholderTextField!
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
    @IBOutlet weak var lblErrorID : UILabel!
    @IBOutlet weak var lblErrorGender : UILabel!
    @IBOutlet weak var lblErrorHeight : UILabel!
    @IBOutlet weak var lblErrorWeight : UILabel!
    @IBOutlet weak var lblErrorCountry : UILabel!
    @IBOutlet weak var lblErrorState : UILabel!
    @IBOutlet weak var lblErrorCity : UILabel!
    @IBOutlet weak var lblErrorPincode : UILabel!

    @IBOutlet weak var lblGender : UILabel!
    
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
        
        
        
        if textField == textFirstName {
            let maxLength = NAMELIMIT
            return txtAfterUpdate.count <= maxLength
        }
        else if textField == textLastName {
            let maxLength = NAMELIMIT
            return txtAfterUpdate.count <= maxLength
        }
        else if textField == textHeigth {
            let maxLength = HEIGHTLIMIT
            return txtAfterUpdate.count <= maxLength
        }
        else if textField == textWeight {
            let maxLength = HEIGHTLIMIT
            return txtAfterUpdate.count <= maxLength
        }
        else if textField == textPincode {
            let maxLength = POSTAlCODELIMIT
            return txtAfterUpdate.count <= maxLength
        }
        if range.length + range.location > textField.text!.count {
            return false
        }
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.scrollViewMain.contentSizeToFit()
        
        self.textFirstName.placeholder = "Enter first name"
        self.textFirstName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textFirstName.floatingLabelInactiveTextColor = UIColor.gray
        
        self.textLastName.placeholder = "Enter last name"
        self.textLastName.floatingLabelActiveTextColor = UIColor(red: 42.0/255, green: 180.0/255, blue: 185.0/255, alpha: 1.0)
        self.textLastName.floatingLabelInactiveTextColor = UIColor.gray
        
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
        self.lblLineID.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineHeight.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineWeight.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineCountry.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineState.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLineCity.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)
        self.lblLinePincode.backgroundColor = UIColor(red: 210.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1.0)

        self.lblErrorFirstname.isHidden = true
        self.lblErrorLastname.isHidden = true
        self.lblErrorID.isHidden = true
        self.lblErrorHeight.isHidden = true
        self.lblErrorWeight.isHidden = true
        self.lblErrorGender.isHidden = true
        self.lblErrorCountry.isHidden = true
        self.lblErrorState.isHidden = true
        self.lblErrorCity.isHidden = true
        self.lblErrorPincode.isHidden = true

        
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
    func isEmptyTextField(_ txt: String) -> Bool {
        return ((txt == "") || (txt.characters.count ) == 0)
    }
    @IBAction func registerClick(_ sender: Any) {
        
        if self.isEmptyTextField(self.textFirstName.text!) {
            self.showAlert(message: "Please enter firstname")
        }
//        if self.isEmptyTextField(self.textLastName.text!) {
//            self.showAlert(message: "Please enter lastname")
//        }
       
        if self.isEmptyTextField(self.textCountry.text!) {
            self.showAlert(message: "Please enter Country")
        }
        if self.isEmptyTextField(self.textState.text! as String) {
            self.showAlert(message: "Please enter State")
        }
        if self.isEmptyTextField(self.textCity.text! as String) {
            self.showAlert(message: "Please enter City")
        }
        if self.isEmptyTextField(self.textPincode.text! as String) {
            self.showAlert(message: "Please enter Pincode")
        }
        if self.isEmptyTextField(self.textHeigth.text!) {
            self.showAlert(message: "Please enter height")
        }
        if self.isEmptyTextField(self.textWeight.text!) {
            self.showAlert(message: "Please enter weight")
        }
        if self.isEmptyTextField(self.genderString as String) {
            self.showAlert(message: "Please select gender")
        }

        if(!(self.isEmptyTextField(self.textFirstName.text!)) &&  !(self.isEmptyTextField(self.textHeigth.text!)) && !(self.isEmptyTextField(self.textWeight.text!)) && !(self.isEmptyTextField(self.genderString as String))  && !(self.isEmptyTextField(self.textCountry.text!)) && !(self.isEmptyTextField(self.textState.text!)) && !(self.isEmptyTextField(self.textCity.text!)) && !(self.isEmptyTextField(self.textPincode.text!))){
            
            let height : String = (self.textHeigth.text! == "") ? "0" : self.textHeigth.text!
            let weight : String = (self.textWeight.text! == "") ? "0" : self.textWeight.text!
            let HeightInt = Int(height)
            let WeightIntValue = Int(weight)
//            let HeightNumber = NSNumber(value:HeightInt!)
//            let WeightInt = WeightIntValue
//            let WeightNumber = NSNumber(value:WeightInt!)
            let Parsedictionary: NSMutableDictionary = ["firstName": self.textFirstName.text!,
                                                        "lastname": self.textLastName.text!,
                                                        "height": height,
                                                        "weight": weight,
                                                        "govtId": self.textID.text!,
                                                        "gender": self.genderString,
                                                        "country": self.textCountry.text!,
                                                        "state": self.textState.text!,
                                                        "city": self.textCity.text!,
                                                        "general": true,
                                                        "agree": true,
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
                            (UIApplication.shared.delegate as! AppDelegate).initSetView()
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
