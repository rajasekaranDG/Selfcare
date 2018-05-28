//
//  SelectHomeCountryViewController.swift
//  AHA selfcare
//
//  Created by user on 12/04/2018.
//  Copyright © 2018 Sivachandiran. All rights reserved.
//

import UIKit
import DropDown

//var kAPIDOMAIN = "http://us.ahahealth.io:12200/rest-scphr/public/v1.0/scphr/"

class SelectHomeCountryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var myBtnSave: UIButton!
    @IBOutlet weak var myTxtFldHomeCountry: UITextField!
    
    
    let dropDown = DropDown()
    
    let UserDefaultsDetails = UserDefaults.standard
    var myAryCountryInfo = [[String:Any]]()
    var myFilteredArrayDropDownInfo = [String]()
    
    var myStrHomeCountryName = String()
    var myStrHomeCountryCode = String()
    var gStrBaseUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUPUi()
        setUpModel()
        loadModel()
    }

    //MARK: - View Initialize
    func setUPUi() {
        
        self.setRoundCornerView(aView:myBtnSave , borderRadius: 5.0)
        myTxtFldHomeCountry.text = UserDefaultsDetails.value(forKey: kCountryName) as? String
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        loadJsonValue()
    }
    
    //MARK: - Textfield delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        dropDown.hide()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        dropDown.anchorView = textField
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        
        var aFilteredArray = [String] ()
        
        let aPredicateName = NSPredicate(format:"SELF CONTAINS[c] %@",txtAfterUpdate)
        aFilteredArray = myFilteredArrayDropDownInfo.filter {aPredicateName.evaluate(with: $0)};
        
        dropDown.dataSource = aFilteredArray
        
        if aFilteredArray.count == 0 {
            
            dropDown.hide()
        }
            
        else {
            
            dropDown.show()
        }
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.view.endEditing(true)
            textField.text = item
            self.myStrHomeCountryName = item
            let index = self.myFilteredArrayDropDownInfo.index(of: item)
            self.myStrHomeCountryCode =  self.myAryCountryInfo[index!]["code"] as! String
        }
        
        return true
    }
    
    //MARK: - Get Json Value
    func loadJsonValue() {
        
        do {
            if let file = Bundle.main.url(forResource: "countries", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                    self.myAryCountryInfo = object as! [[String : Any]]
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        for countryAry in myAryCountryInfo {
            
            myFilteredArrayDropDownInfo.append(countryAry["name"] as! String)
        }
    }
    
    //MARK: - Button Actions
    // Save Button Action
    @IBAction func myBtnSaveAction(_ sender: Any) {
        
        MBProgressHUD.showAdded(to: myBtnSave, animated: true)
        
        
        
        if  let aText = myTxtFldHomeCountry.text {
            
            if aText.length > 0 {
                let countryName = UserDefaultsDetails.value(forKey: kCountryName) as? String
                if countryName == aText {
                    self.navigationController?.popViewController(animated: true)
                    return
                }

                var aFilteredArray = [String] ()
                
                let aPredicateName = NSPredicate(format:"SELF CONTAINS[c] %@",aText)
                aFilteredArray = myFilteredArrayDropDownInfo.filter {aPredicateName.evaluate(with: $0)}
                
                if aFilteredArray.count != 0 {
                    
                    UserDefaultsDetails.set(myStrHomeCountryCode, forKey: kCountryCode)
                    UserDefaultsDetails.set(myTxtFldHomeCountry.text, forKey: kCountryName)
                    if myStrHomeCountryCode == "US" {
                        
                        gStrBaseUrl = "http://cprod.ahahealth.io:12200/rest-scphr/public/v1.0/scphr/"
                    }
                        
                    else {
                        
                        gStrBaseUrl = "http://cprod.ahahealth.io:12200/rest-scphr/public/v1.0/scphr/"
                    }
                    
                    UserDefaultsDetails.set(gStrBaseUrl, forKey: kBaseUrl)
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "userage")
                    UserDefaults.standard.removeObject(forKey: "password")
                    let SignInVC : SignInViewController = SignInViewController(nibName : "SignInViewController" , bundle : nil)
                    self.navigationController?.pushViewController(SignInVC, animated: false)
                }
                
                else {
                    
                    MBProgressHUD.hide(for: myBtnSave, animated: true)
                    self.showAlert(message: "Please choose country in the list")
                }
            }
            
            else {
                
                MBProgressHUD.hide(for: myBtnSave, animated: true)
                self.showAlert(message: "Please choose country")
            }
        }
    }
    
    
    //MARK: - Private Functions
    // Round Corner View
    func setRoundCornerView(aView : UIView, borderRadius:CGFloat)  {
        
        aView.layer.masksToBounds = true
        aView.layer.cornerRadius = borderRadius
    }
    
    // Show Alert
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK:- Button Actions
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
