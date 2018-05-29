//
//  AppManager.swift
//  CCMC_User
//
//  Created by Sivachandiran on 27/04/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class AppManager: NSObject {

    var appVersionString : NSString!
    var internetFailAlert: UIAlertView!

    class var sharedInstance: AppManager {
        struct Static {
            static let instance: AppManager = AppManager()
        }
        return Static.instance
    }
    func dateFromMilliseconds(ms: NSNumber) -> NSDate {
        return NSDate(timeIntervalSince1970:Double(ms) / 1000.0)
    }
    func convertAge(birthDay : NSDate)-> NSString {
        let now = Date()
        let birthday: Date = birthDay as Date
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return String(age) as NSString
    }
    // MARK: Encryption Parameters
    func EncryptionParameters (params : NSMutableDictionary)-> [String: Any] {
        
        let MutableParams: NSMutableDictionary = AppManager.sharedInstance.parseDictionartDetial(Dic: params) as! NSMutableDictionary
        let optionsCoupon = JSONSerialization.WritingOptions(rawValue: 0)
        var stringParams : NSString = ""
        do{
            let postdata: NSData = try JSONSerialization.data(withJSONObject: MutableParams, options: optionsCoupon) as NSData
            if let string = NSString(data: postdata as Data, encoding: String.Encoding.ascii.rawValue) {
                stringParams = string as NSString
            }
        } catch {
        }
        stringParams = String(format: "%@&Completed=1", (stringParams as NSString)) as NSString!
        
        var dataParams : NSData = stringParams.data(using: String.Encoding.utf8.rawValue)! as NSData
        dataParams = dataParams.aes128Encrypt(withKey: kAES128_Encryption_Key, iv: kAES128_Encryption_IV) as NSData
        stringParams = dataParams.hexadecimalString() as NSString;
        return ["ccmc_input": stringParams as String!]
    }

    // MARK: Save User Info
    func saveLoginDetails(_ details: [AnyHashable: Any], forKey key: String, completion block: @escaping (_ success: Bool) -> Void) {
        var Detail = details as [AnyHashable: Any]
        if (key == kUser) {
            Detail[kUserLoggedIn] = Int(true)
        }
        let loginData = NSKeyedArchiver.archivedData(withRootObject: Detail)
        let defaults = UserDefaults.standard
        defaults.set(loginData, forKey: key)
        defaults.synchronize()
        block(true)
    }
    func saveAddDataDetails(_ details: NSMutableDictionary, forKey key: String, completion block: @escaping (_ success: Bool) -> Void) {
        if (key == kAddData) {
            details[kAddDataIn] = Int(true)
        }
        let loginData = NSKeyedArchiver.archivedData(withRootObject: details)
        let defaults = UserDefaults.standard
        defaults.set(loginData, forKey: key)
        defaults.synchronize()
        block(true)
    }
    func addDataInfo() -> NSDictionary {
        
        let userDefaults: NSData? = UserDefaults.standard.value(forKey: kAddData) as? NSData
        if userDefaults != nil {
            let userdetails: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults! as Data) as! NSDictionary
            return (userdetails.allKeys.count != 0) ? userdetails as NSDictionary : NSDictionary()
        }
        return NSDictionary()
    }

    // MARK: User Info
    func userInfo() -> NSDictionary {
        
        let userDefaults: NSData? = UserDefaults.standard.value(forKey: kUser) as? NSData
        if userDefaults != nil {
            let userdetails: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults! as Data) as! NSDictionary
            return (userdetails.allKeys.count != 0) ? userdetails as NSDictionary : NSDictionary()
        }
        return NSDictionary()
    }
    
    // MARK: User Loggin Check
    func isLoggedIn() -> Bool {
        let details: NSDictionary = self.userInfo() as NSDictionary
        
        var LogIn : NSString = ""
        if (details[kUserLoggedIn] != nil) {
            if let str = details[kUserLoggedIn] as? NSNumber {
                LogIn = str.stringValue as NSString
            }
            else {
                LogIn = NSString(format:"%@", details[kUserLoggedIn] as! String)
            }
        }
        return details.allKeys.count != 0 ? LogIn.boolValue : false
    }
    // MARK: Get UserId
    func userId() -> String {
        var userid: String = ""
        let userinfo: NSDictionary = self.userInfo() as NSDictionary
        let count :Int = userinfo.allKeys.count
        
        if count > 0 {
            if ((userinfo["user_id"] != nil) && (userinfo["user_id"] as! NSObject != NSNull())){
                let UserId : String = AppManager.sharedInstance.checkNumberString(DetailDictionary: userinfo.mutableCopy() as! NSMutableDictionary, key: "user_id")
                userid = UserId
            }
        }
        return userid
    }
    func authendication() -> String {
        let username = AppManager.sharedInstance.userName()
        let password = AppManager.sharedInstance.userPassword()
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let stringAuth : String = String(format : "Basic %@",base64LoginString)
        return base64LoginString
    }
    // MARK: Get UserName
    func userName() -> String {
        var username: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "username") != nil) && (defaults.object(forKey: "username") as! NSObject != NSNull())){
            username = defaults.object(forKey: "username") as! String
        }
        return username
    }
    func userAge() -> String {
        var userage: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "userage") != nil) && (defaults.object(forKey: "userage") as! NSObject != NSNull())){
            userage = defaults.object(forKey: "userage") as! String
        }
        return userage
    }
    func userMail() -> String {
        var userage: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "email") != nil) && (defaults.object(forKey: "email") as! NSObject != NSNull())){
            userage = defaults.object(forKey: "email") as! String
        }
        return userage
    }
    func userDOB() -> String {
        var userdob: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "dataOfBirth") != nil) && (defaults.object(forKey: "dataOfBirth") as! NSObject != NSNull())){
            userdob = defaults.object(forKey: "dataOfBirth") as! String
        }
        return userdob
    }
    // MARK: Get Password
    func userPassword() -> String {
        var userpassword: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "password") != nil) && (defaults.object(forKey: "password") as! NSObject != NSNull())){
            userpassword = defaults.object(forKey: "password") as! String
        }
        return userpassword
    }
    // MARK: Check Appplication Version
    func applicationVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        // let build = dictionary["CFBundleVersion"] as! String
        return version
    }
    // MARK: Get FirstName
    func userFirstName() -> String {
        var firstName: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "firstName") != nil) && (defaults.object(forKey: "firstName") as! NSObject != NSNull())){
            firstName = defaults.object(forKey: "firstName") as! String
        }
        return firstName
    }
    // MARK: Get LastName
    func userLastName() -> String {
        var lastname: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "lastname") != nil) && (defaults.object(forKey: "lastname") as! NSObject != NSNull())){
            lastname = defaults.object(forKey: "lastname") as! String
        }
        return lastname
    }
    // MARK: Get Gender
    func userGender() -> String {
        var gender: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "gender") != nil) && (defaults.object(forKey: "gender") as! NSObject != NSNull())){
            gender = defaults.object(forKey: "gender") as! String
        }
        return gender
    }
    // MARK: Get Height
    func userHeight() -> String {
        var height: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "height") != nil) && (defaults.object(forKey: "height") as! NSObject != NSNull())){
            height = defaults.object(forKey: "height") as! String
        }
        return height
    }
    // MARK: Get Weight
    func userWeight() -> String {
        var weight: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "weight") != nil) && (defaults.object(forKey: "weight") as! NSObject != NSNull())){
            weight = defaults.object(forKey: "weight") as! String
        }
        return weight
    }
    func userGovtId() -> String {
        var govtId: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "govtId") != nil) && (defaults.object(forKey: "govtId") as! NSObject != NSNull())){
            govtId = defaults.object(forKey: "govtId") as! String
        }
        return govtId
    }
    func userCountry() -> String {
        var country: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "country") != nil) && (defaults.object(forKey: "country") as! NSObject != NSNull())){
            country = defaults.object(forKey: "country") as! String
        }
        return country
    }
    func userState() -> String {
        var state: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "state") != nil) && (defaults.object(forKey: "state") as! NSObject != NSNull())){
            state = defaults.object(forKey: "state") as! String
        }
        return state
    }
    func userCity() -> String {
        var city: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "city") != nil) && (defaults.object(forKey: "city") as! NSObject != NSNull())){
            city = defaults.object(forKey: "city") as! String
        }
        return city
    }
    func userPostalCode() -> String {
        var postalCode: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "postalCode") != nil) && (defaults.object(forKey: "postalCode") as! NSObject != NSNull())){
            postalCode = defaults.object(forKey: "postalCode") as! String
        }
        return postalCode
    }
    func userMobile() -> String {
        var mobile: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "mobile") != nil) && (defaults.object(forKey: "mobile") as! NSObject != NSNull())){
            mobile = defaults.object(forKey: "mobile") as! String
        }
        return mobile
    }

    // MARK: Check Success
    func isSuccess(_ successflag: String) -> Bool {
        return ((successflag is String) && (successflag == "Y"))
    }

    // MARK: NSArray Conver to NSMutableArray
    func convertToNSMutableArray (array : NSArray) -> NSMutableArray {
        let arrayOfItems : NSMutableArray = []
        for DetailDic in array{
            let dictionaryDetails: NSMutableDictionary = AppManager.sharedInstance.checkNullValue(DetailDictionary: DetailDic as! [NSObject : AnyObject] as NSDictionary)
            arrayOfItems.add(dictionaryDetails)
        }
        return arrayOfItems
    }

    // MARK: Check Dictionary Null value
    func checkNullValue(DetailDictionary : NSDictionary) -> NSMutableDictionary {
        
        let dictionaryDetails: NSMutableDictionary = NSMutableDictionary()
        let KeyValueArray : NSArray = (DetailDictionary.allKeys as AnyObject) as! NSArray
        
        for i in 0 ..< DetailDictionary.count {
            let KeyValue : NSString = KeyValueArray[i] as! NSString
            if ((DetailDictionary[KeyValue] as! NSObject != NSNull()) && (DetailDictionary[KeyValue] != nil)) {
                dictionaryDetails.setObject(DetailDictionary[KeyValue]!, forKey: KeyValue as NSCopying)
            }
            else {
                dictionaryDetails.setObject("", forKey: KeyValue as NSCopying)
            }
        }
        return dictionaryDetails
    }
    
    //Mark: Check Dictionary Keyvalue
    func checkDictionaryKeyValue(DetailDictionary : NSMutableDictionary, key KeyValue:String) -> String {
        
        var Assigned : NSString = ""
        if let val = DetailDictionary[KeyValue] {
            if let ResponeDetail : NSString = val as? NSString{
                Assigned = ResponeDetail as NSString
            }
        }
        return Assigned as String
    }

    //Mark: Check Number String
    func checkNumberString(DetailDictionary : NSMutableDictionary, key KeyValue:String) -> String {
        var Assigned : NSString = ""
        if DetailDictionary.count > 0 {
            if ((DetailDictionary[KeyValue] as! NSObject != NSNull()) && (DetailDictionary[KeyValue] != nil)) {
                if let str = DetailDictionary[KeyValue] as? NSNumber {
                    var roundOffValue = Int(str)//str.stringValue as NSString
                    Assigned = String(roundOffValue) as NSString
                }
                else {
                    Assigned = NSString(format:"%@", DetailDictionary[KeyValue] as! String)
                }
            }
        }
        return Assigned as String
    }

    //Mark: Check Number String For Assessment
    func checkNumberStringForAssessment(DetailDictionary : NSMutableDictionary, key KeyValue:String) -> String {
        var Assigned : NSString = ""
        if ((DetailDictionary[KeyValue] as! NSObject != NSNull()) && (DetailDictionary[KeyValue] != nil)) {
            if let str = DetailDictionary[KeyValue] as? NSNumber {
                var roundOffValue = Int(str)//str.stringValue as NSString
                Assigned = String(roundOffValue) as NSString
            }
            else {
                Assigned = NSString(format:"%@", DetailDictionary[KeyValue] as! String)
                if Assigned == "" {
                    Assigned = "0.0"
                }
            }
        }
        return Assigned as String
    }
    //Mark: Set cell dynamic height
    func dynamicHeightCalculation(current_constraint: CGSize, descriptions string_desc: String, fontfamily currentfont: UIFont) -> CGSize {
        var size_Title: CGSize = CGSize.zero
        let textRect: CGRect = string_desc.boundingRect(with: current_constraint, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: currentfont], context: nil)
        size_Title = textRect.size
        return size_Title
    }

    //Mark: change attribute lable text size, font family and color
    func attributedWithFont(text: String, highlight h1: String, size : CGFloat, FontName : String) -> NSMutableAttributedString {
        let string = text as NSString
        let stringAttr: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        let range: NSRange = string.range(of: h1)
        stringAttr.addAttribute(NSFontAttributeName, value: UIFont(name: FontName, size: size)!, range: NSMakeRange(range.location, range.length))
        return stringAttr
    }
    
    func attributedTextWithColor(text: String, highlight h1: String, h2: String, size : CGFloat, FontName : String) -> NSMutableAttributedString {
        let string = text as NSString
        let stringAttr: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        let range: NSRange = string.range(of: h1)
        let range2: NSRange = string.range(of: h2)

        stringAttr.addAttribute(NSFontAttributeName, value: UIFont(name: FontName, size: size)!, range: NSMakeRange(range.location, range.length))
        stringAttr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0), range: NSMakeRange(range.location, range.length))

        stringAttr.addAttribute(NSFontAttributeName, value: UIFont(name: FontName, size: size)!, range: NSMakeRange(range2.location, range2.length))
        stringAttr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 90.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0), range: NSMakeRange(range2.location, range2.length))
        return stringAttr
    }

    //Mark: View shaow effect
    func viewShadow(MainView: UIView) {
        MainView.layer.shadowColor = UIColor.black.cgColor
        MainView.layer.shadowOpacity = 0.2
        MainView.layer.shadowRadius = 2.0
        MainView.layer.shadowOffset = CGSize(width: 2.0, height: 1.0)
    }

    func ConertDateStringToDate(Date: String, Format format: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yourDate: NSDate = dateFormatter.date(from: Date)! as NSDate
        dateFormatter.dateFormat = format
        return yourDate as Date
    }

    //Mark: Convert NSString(Date) to NSString
    func conertDateStringToString(Date: String, Format format: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var yourDate: NSDate!
        if dateFormatter.date(from: Date) != nil  {
            yourDate = dateFormatter.date(from: Date)! as NSDate
            dateFormatter.dateFormat = format
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if dateFormatter.date(from: Date) != nil  {
                yourDate = dateFormatter.date(from: Date)! as NSDate
                dateFormatter.dateFormat = format
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
                if dateFormatter.date(from: Date) != nil  {
                    yourDate = dateFormatter.date(from: Date)! as NSDate
                    dateFormatter.dateFormat = format
                }
                else {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let DateInt = Int(Date )
                    let DateNumber = NSNumber(value:DateInt!)
                    let stringDate : String = AppManager.sharedInstance.conertDateToString(Date: AppManager.sharedInstance.dateFromMilliseconds(ms: DateNumber), formate: "yyyy-MM-dd HH:mm:ss")
                    yourDate = dateFormatter.date(from: stringDate)! as NSDate
                    dateFormatter.dateFormat = format
                }
            }
        }
        
        let ConvertDate: String = dateFormatter.string(from: yourDate as Date)
        return ConvertDate
    }

    //Mark: Convert NSDate to NSString
    func conertDateToString(Date: NSDate, formate DateFormat: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" //:ss
        //Optionally for time zone conversions
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = DateFormat
        let stringFromDate: String = formatter.string(from: Date as Date)
        return stringFromDate
    }
    //Mark: Convert NSString(Date) to NSString
    func conertDateStringToString2(Date: String, Format format: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yourDate: NSDate = dateFormatter.date(from: Date)! as NSDate
        dateFormatter.dateFormat = format
        let ConvertDate: String = dateFormatter.string(from: yourDate as Date)
        return ConvertDate
    }

    //MARK: Conver Hex Color to RGB Color
    func converRGBColor(hexString: String) -> UIColor {
        let r, g, b, a: CGFloat
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        return UIColor.clear
    }
    // Form Default Parameters
    func parseDictionartDetial (Dic: NSMutableDictionary) -> NSDictionary {
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "username" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userPassword(), forKey: "password" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userId(), forKey: "user_id" as NSCopying)
        Parsedictionary.setObject("ios", forKey: "platform" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.applicationVersion(), forKey: "AppVersion" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().deviceId(), forKey: "device_id" as NSCopying)
        return Parsedictionary
    }
    //Mark: Check Network
    func hasConnectedToNetwork() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    func showAlertFailure() {
        let strAlertTitle: String = KInternetAlretTitle
        let strAlertMsg: String = KInternetAlretMessage
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if !(self.internetFailAlert != nil) {
            self.internetFailAlert = UIAlertView(title: strAlertTitle, message: strAlertMsg, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
        }
        if !self.internetFailAlert.isVisible {
            self.internetFailAlert.show()
        }
    }
    func stringValueForInt(value: Int) -> String {
        var stringValue: String = ""
        stringValue = stringValue.appendingFormat("%d", value)
        return stringValue
    }
    func createBloodPressure(Dic: NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject("com.selfcare.shared.data.BloodPressure", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject(NSNull(), forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "bloodPresureLevel" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetHighPress"].stringValue as NSString) as NSString), forKey: "targetSystolic" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetHeartRate"].stringValue as NSString) as NSString), forKey: "targetHeartRate" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetLowPress"].stringValue as NSString) as NSString), forKey: "targetDiastolic" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdHighPress"].stringValue as NSString) as NSString), forKey: "thresholdSystolic" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdHeartRate"].stringValue as NSString) as NSString), forKey: "thresholdHeartRate" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdLowPress"].stringValue as NSString) as NSString), forKey: "thresholdDiastolic" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetSystolic" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetHeartRate" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetDiastolic" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdSystolic" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdHeartRate" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdDiastolic" as NSCopying)
        }
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("", forKey: "isArr" as NSCopying)
        return Parsedictionary

    }
    func subBloodPressure(Dic : NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        let noteString : NSString = AppManager.sharedInstance.checkDictionaryKeyValue(DetailDictionary: Dic, key: "note") as NSString

        Parsedictionary.setObject(Dic["systolic"] as Any, forKey: "systolicValue" as NSCopying)
        Parsedictionary.setObject(Dic["heartRate"] as Any, forKey: "heartRate" as NSCopying)
        Parsedictionary.setObject(Dic["diastolic"] as Any, forKey: "diastolic" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(noteString, forKey: "note" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["measurementDate"] as! String), forKey: "measurementDate" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetHighPress"].stringValue as NSString) as NSString), forKey: "targetSystolic" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetHeartRate"].stringValue as NSString) as NSString), forKey: "targetHeartRate" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetLowPress"].stringValue as NSString) as NSString), forKey: "targetDiastolic" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdHighPress"].stringValue as NSString) as NSString), forKey: "thresholdSystolic" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdHeartRate"].stringValue as NSString) as NSString), forKey: "thresholdHeartRate" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdLowPress"].stringValue as NSString) as NSString), forKey: "thresholdDiastolic" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetSystolic" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetHeartRate" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetDiastolic" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdSystolic" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdHeartRate" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdDiastolic" as NSCopying)
        }
        return Parsedictionary
    }
    
    func createBloodGlucose(Dic: NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.BloodGlucose", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "drugSituation" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataId" as NSCopying)
        Parsedictionary.setObject("", forKey: "bgunit" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "medicine" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetBloodGlucose"].stringValue as NSString) as NSString), forKey: "targetBG" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdBloodGlucose"].stringValue as NSString) as NSString), forKey: "thresholdBG" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetBG" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdBG" as NSCopying)
        }
        return Parsedictionary
        
    }
    func subBloodGlucose(Dic : NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        let noteString : NSString = AppManager.sharedInstance.checkDictionaryKeyValue(DetailDictionary: Dic, key: "note") as NSString

        Parsedictionary.setObject(Dic["context"] as! String, forKey: "context" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["measurementDate"] as! String), forKey: "measurementDate" as NSCopying)
        Parsedictionary.setObject(Dic["bloodGlucoseUnit"]  as Any, forKey: "bloodGlucoseUnit" as NSCopying)
        Parsedictionary.setObject(Dic["beforeMeal"]  as Any, forKey: "beforeMeal" as NSCopying)
        Parsedictionary.setObject(Dic["medication"]  as Any, forKey: "medication" as NSCopying)
        Parsedictionary.setObject(Dic["medicationTime"]  as Any, forKey: "medicationTime" as NSCopying)
        Parsedictionary.setObject(noteString, forKey: "note" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["bloodGlucoseValue"]  as Any, forKey: "bloodGlucoseValue" as NSCopying)
        if(monitoringParameter.count != 0){

            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdBloodGlucose"].stringValue as NSString) as NSString), forKey: "thresholdBloodGlucose" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetBloodGlucose"].stringValue as NSString) as NSString), forKey: "targetBloodGlucose" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "thresholdBloodGlucose" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetBloodGlucose" as NSCopying)
        }
        Parsedictionary.setObject("", forKey: "medicine" as NSCopying)
        return Parsedictionary
    }
    
    func createWeight(Dic: NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject("com.selfcare.shared.data.Weight", forKey: "@class" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: monitoringParameter[0]["thresholdWeightValue"].stringValue as NSString), forKey: "thresholdWeightValue" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: monitoringParameter[0]["targetWeightValue"].stringValue as NSString), forKey: "targetWeightValue" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: monitoringParameter[0]["thresholdBMI"].stringValue as NSString), forKey: "thresholdBMI" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "thresholdWeightValue" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetWeightValue" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdBMI" as NSCopying)
        }
        Parsedictionary.setObject("", forKey: "note" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "boneValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "fatValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdBoneValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdDCI" as NSCopying)
        Parsedictionary.setObject("", forKey: "dci" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetBMI" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetMuscaleValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataId" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdDailyCaloricIntake" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "measurementType" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetDCI" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdFatValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetFatValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "muscleValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetWaterValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdMuscaleValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "waterValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdWaterValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetBoneValue" as NSCopying)
        return Parsedictionary
        
    }
    func subWeight(Dic : NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(Dic["wgt"] as Any, forKey: "Weight" as NSCopying)
        Parsedictionary.setObject(Dic["bmi"] as Any, forKey: "bmi" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        if(monitoringParameter.count != 0){
            
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdWeightValue"].stringValue as NSString) as NSString), forKey: "thresholdWeightValue" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetWeightValue"].stringValue as NSString) as NSString), forKey: "targetWeightValue" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdBMI"].stringValue as NSString) as NSString), forKey: "thresholdBMI" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "thresholdWeightValue" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetWeightValue" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdBMI" as NSCopying)
        }
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["measurementDate"] as! String), forKey: "measurementDate" as NSCopying)
        return Parsedictionary
    }
    func createSleep(Dic: NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.Sleep", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataId" as NSCopying)
        Parsedictionary.setObject("", forKey: "note" as NSCopying)
        Parsedictionary.setObject(0, forKey: "startTime" as NSCopying)
        Parsedictionary.setObject(0, forKey: "endTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "sleepEfficiency" as NSCopying)
        Parsedictionary.setObject("", forKey: "fallSleep" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetSteps" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetFallSleep" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetSleepEfficiency" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdFallsleep" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdSleepEfficiency" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetHoursSlept"].stringValue as NSString) as NSString), forKey: "targetHoursSlept" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetAwaken"].stringValue as NSString) as NSString), forKey: "targetAwaken" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdHoursSlept"].stringValue as NSString) as NSString), forKey: "thresholdHoursSlept" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdAwaken"].stringValue as NSString) as NSString), forKey: "thresholdAwaken" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetHoursSlept" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetAwaken" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdHoursSlept" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdAwaken" as NSCopying)
        }
        return Parsedictionary
    }
    func subSleep(Dic : NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        Parsedictionary.setObject(Dic["awaken"] as Any, forKey: "awaken" as NSCopying)
        Parsedictionary.setObject(Dic["hoursSlept"] as Any, forKey: "hoursSlept" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["measurementDate"] as! String), forKey: "measurementDate" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetHoursSlept"].stringValue as NSString) as NSString), forKey: "targetHoursSlept" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetAwaken"].stringValue as NSString) as NSString), forKey: "targetAwaken" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdHoursSlept"].stringValue as NSString) as NSString), forKey: "thresholdHoursSlept" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdAwaken"].stringValue as NSString) as NSString), forKey: "thresholdAwaken" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetHoursSlept" as NSCopying)
            Parsedictionary.setObject(0, forKey: "targetAwaken" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdHoursSlept" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdAwaken" as NSCopying)
        }
        return Parsedictionary
    }
    
    func createActivity(Dic: NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        Parsedictionary = Dic
        Parsedictionary.setObject("com.selfcare.shared.data.Activity", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataId" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject(0, forKey: "calories" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: monitoringParameter[0]["targetSteps"].stringValue as NSString), forKey: "targetSteps" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetSteps" as NSCopying)
        }
        return Parsedictionary
        
    }
    func subActivity(Dic : NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        let noteString : NSString = AppManager.sharedInstance.checkDictionaryKeyValue(DetailDictionary: Dic, key: "note") as NSString

        Parsedictionary.setObject(0, forKey: "calories" as NSCopying)
        Parsedictionary.setObject(Dic["distanceTraveled"] as Any, forKey: "distanceTraveled" as NSCopying)
        Parsedictionary.setObject(noteString, forKey: "note" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["steps"] as Any, forKey: "steps" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["measurementDate"] as! String), forKey: "measurementDate" as NSCopying)
        return Parsedictionary
    }
    
    
    func createSports(Dic: NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject("com.selfcare.shared.data.Sports", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataID" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetCaloriesBurnt"].stringValue as NSString) as NSString), forKey: "targetCaloriesBurnt" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdCaloriesBurnt"].stringValue as NSString) as NSString), forKey: "thresholdCaloriesBurnt" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetCaloriesBurnt" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdCaloriesBurnt" as NSCopying)
        }
        return Parsedictionary
        
    }
    func subSports(Dic : NSMutableDictionary, monitoringParameter : [JSON]) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        
        Parsedictionary.setObject(Dic["calories"] as Any, forKey: "calories" as NSCopying)
        Parsedictionary.setObject(Dic["sportName"] as Any, forKey: "sportName" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["sportStartTime"] as! String), forKey: "sportStartTime" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(Dic["sportEndTime"] as! String), forKey: "sportEndTime" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        if(monitoringParameter.count != 0){
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["targetCaloriesBurn"].stringValue as NSString) as NSString), forKey: "targetCaloriesBurnt" as NSCopying)
            Parsedictionary.setObject(AppManager.sharedInstance.convertNumber(answerString: AppManager.sharedInstance.checkStringValue(value: monitoringParameter[0]["thresholdCaloriesBurnt"].stringValue as NSString) as NSString), forKey: "thresholdCaloriesBurnt" as NSCopying)
        }
        else {
            Parsedictionary.setObject(0, forKey: "targetCaloriesBurnt" as NSCopying)
            Parsedictionary.setObject(0, forKey: "thresholdCaloriesBurnt" as NSCopying)
        }
        return Parsedictionary
    }
    func userCreate(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject("", forKey: "firstName" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastname" as NSCopying)
        Parsedictionary.setObject("", forKey: "govtId" as NSCopying)
        Parsedictionary.setObject("Patient", forKey: "profile" as NSCopying)
        Parsedictionary.setObject("Diabetes", forKey: "healthProfile" as NSCopying)
        Parsedictionary.setObject(0, forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.User", forKey: "_class" as NSCopying)
        return Parsedictionary
    }
    func subuserCreate(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(Dic["password"] as! String, forKey: "password" as NSCopying)
        Parsedictionary.setObject(Dic["email"] as! String, forKey: "email" as NSCopying)
        Parsedictionary.setObject(Dic["_id"] as! String, forKey: "userid" as NSCopying)
        Parsedictionary.setObject(Dic["dataOfBirth"] as Any, forKey: "dataOfBirth" as NSCopying)
        Parsedictionary.setObject(Dic["mobile"] as Any, forKey: "mobile" as NSCopying)
        Parsedictionary.setObject(Dic["firstName"] as Any, forKey: "firstName" as NSCopying)
        Parsedictionary.setObject(Dic["lastname"] as Any, forKey: "lastname" as NSCopying)
        Parsedictionary.setObject(Dic["govtId"] as Any, forKey: "govtId" as NSCopying)
        Parsedictionary.setObject("Diabetes", forKey: "healthProfile" as NSCopying)
        Parsedictionary.setObject("Patient", forKey: "profile" as NSCopying)
        Parsedictionary.setObject(Dic["height"] as Any, forKey: "height" as NSCopying)
        Parsedictionary.setObject(Dic["weight"] as Any, forKey: "weight" as NSCopying)
        Parsedictionary.setObject(Dic["gender"] as Any, forKey: "gender" as NSCopying)
        Parsedictionary.setObject(Dic["country"] as Any, forKey: "country" as NSCopying)
        Parsedictionary.setObject(Dic["state"] as Any, forKey: "state" as NSCopying)
        Parsedictionary.setObject(Dic["city"] as Any, forKey: "city" as NSCopying)
        Parsedictionary.setObject(Dic["postalCode"] as Any, forKey: "postalCode" as NSCopying)
        Parsedictionary.setObject(0, forKey: "versionNo" as NSCopying)
        return Parsedictionary
    }

    func createBloodPressureMonitoringParameter(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.BloodPressureMonitoringParameter", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        
        return Parsedictionary
    }
    func subBloodPressureMonitoringParameter(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["targetHighPress"] as Any, forKey: "targetHighPress" as NSCopying)
        Parsedictionary.setObject(Dic["targetLowPress"] as Any, forKey: "targetLowPress" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdHighPress"] as Any, forKey: "thresholdHighPress" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdLowPress"] as Any, forKey: "thresholdLowPress" as NSCopying)
        Parsedictionary.setObject(Dic["targetHeartRate"] as Any, forKey: "targetHeartRate" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdHeartRate"] as Any, forKey: "thresholdHeartRate" as NSCopying)
        return Parsedictionary
    }
    func createBloodGlucoseMonitoringParameter(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.BloodGlucoseMonitoringParameter", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        
        return Parsedictionary
    }
    func subBloodGlucoseMonitoringParameter(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["targetBloodGlucose"] as Any, forKey: "targetBloodGlucose" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdBloodGlucose"] as Any, forKey: "thresholdBloodGlucose" as NSCopying)
        return Parsedictionary
    }
    func createSportsMonitoringParameter(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.SportsMonitoringParameter", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        return Parsedictionary
    }
    func subSportsMonitoringParameter(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["targetCaloriesBurn"] as Any, forKey: "targetCaloriesBurn" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdCaloriesBurnt"] as Any, forKey: "thresholdCaloriesBurnt" as NSCopying)
        return Parsedictionary
    }
    func createWeightMonitoringParameter(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.WeightMonitoringParameter", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdBoneValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdDCI" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdMuscleValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetDCI" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetMuscleValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetFatValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetWaterValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdWaterValue" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetBoneValue" as NSCopying)
        
        return Parsedictionary
    }
    func subWeightMonitoringParameter(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["targetWeightValue"] as Any, forKey: "targetWeightValue" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdBMI"] as Any, forKey: "thresholdBMI" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdWeightValue"] as Any, forKey: "thresholdWeightValue" as NSCopying)
        return Parsedictionary
    }
    func createActivityMonitoringParameter(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.ActivityMonitoringParameter", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdCalories" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetCalories" as NSCopying)
        
        return Parsedictionary
    }
    func subActivityMonitoringParameter(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        return Parsedictionary
    }
    func createSleepMonitoringParameter(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.SleepMonitoringParameter", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetFallSleep" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdSleepEfficiency" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "targetSleepEfficiency" as NSCopying)
        Parsedictionary.setObject("", forKey: "thresholdFallSleep" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
                
        return Parsedictionary
    }
    func subSleepMonitoringParameter(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["targetAwaken"] as Any, forKey: "targetAwaken" as NSCopying)
        Parsedictionary.setObject(Dic["targetHoursSlept"] as Any, forKey: "targetHoursSlept" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdAwaken"] as Any, forKey: "thresholdAwaken" as NSCopying)
        Parsedictionary.setObject(Dic["thresholdHoursSlept"] as Any, forKey: "thresholdHoursSlept" as NSCopying)
        return Parsedictionary
    }
    //Mark: -Assessment
    func createAssessmentObesity(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        Parsedictionary.setObject("com.selfcare.shared.data.Bmi", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject(0, forKey: "bodyMassIndex" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.Bmi", forKey: "_class" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "yyyy-MM-dd hh:mm:ss"), forKey: "measurementDate" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        return Parsedictionary
        
    }
    func subAssessmentObesity(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["weight"] as Any, forKey: "weight" as NSCopying)
        Parsedictionary.setObject(Dic["height"] as Any, forKey: "height" as NSCopying)
        Parsedictionary.setObject(Dic["answeringQuestion"] as! String, forKey: "answeringQuestion" as NSCopying)
        Parsedictionary.setObject("com.selfcare.shared.data.Bmi", forKey: "_class" as NSCopying)
        Parsedictionary.setObject(0, forKey: "bodyMassIndex" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "yyyy-MM-dd hh:mm:ss")), forKey: "measurementDate" as NSCopying)
        return Parsedictionary
    }
    func createAssessmentDisease(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        let ageInt = Int(AppManager.sharedInstance.userAge())
        let ageNumber = NSNumber(value:ageInt!)
        
        Parsedictionary = Dic
        Parsedictionary.setObject("com.selfcare.shared.data.CardioVascular", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "yyyy-MM-dd hh:mm:ss"), forKey: "measurementDate" as NSCopying)
        Parsedictionary.setObject(10, forKey: "timePeriod" as NSCopying)
        Parsedictionary.setObject(0, forKey: "scottishIndex" as NSCopying)
        Parsedictionary.setObject(0, forKey: "gender" as NSCopying)
        Parsedictionary.setObject(ageNumber, forKey: "age" as NSCopying)
        Parsedictionary.setObject(0, forKey: "cvd" as NSCopying)
        Parsedictionary.setObject(0, forKey: "ha" as NSCopying)
        Parsedictionary.setObject(0, forKey: "stroke" as NSCopying)
        Parsedictionary.setObject(0, forKey: "chd" as NSCopying)
        Parsedictionary.setObject(0, forKey: "dr" as NSCopying)
        Parsedictionary.setObject(0, forKey: "cvddr" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        return Parsedictionary
    }
    func subAssessmentDisease(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        let ageInt = Int(AppManager.sharedInstance.userAge())
        let ageNumber = NSNumber(value:ageInt!)

        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["smokingStatus"]  as Any, forKey: "smokingStatus" as NSCopying)
        Parsedictionary.setObject(Dic["diabetes"] as Any, forKey: "diabetes" as NSCopying)
        Parsedictionary.setObject(Dic["lvh"]  as Any, forKey: "lvh" as NSCopying)
        Parsedictionary.setObject(Dic["systolic"]  as Any, forKey: "systolic" as NSCopying)
        Parsedictionary.setObject(Dic["totalCholastrol"]  as Any, forKey: "totalCholastrol" as NSCopying)
        Parsedictionary.setObject(Dic["hdlCholastrol"]  as Any, forKey: "hdlCholastrol" as NSCopying)
        Parsedictionary.setObject(Dic["timePeriod"]  as Any, forKey: "timePeriod" as NSCopying)
        Parsedictionary.setObject(ageNumber, forKey: "age" as NSCopying)
        Parsedictionary.setObject(0, forKey: "cvddr" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "yyyy-MM-dd hh:mm:ss")), forKey: "measurementDate" as NSCopying)
        Parsedictionary.setObject(0, forKey: "gender" as NSCopying)
        Parsedictionary.setObject(0, forKey: "ha" as NSCopying)
        Parsedictionary.setObject(0, forKey: "stroke" as NSCopying)
        Parsedictionary.setObject(0, forKey: "chd" as NSCopying)
        Parsedictionary.setObject(0, forKey: "dr" as NSCopying)
        Parsedictionary.setObject(0, forKey: "cvd" as NSCopying)

        return Parsedictionary
    }
    func createAssessmentDiabetes(Dic: NSMutableDictionary) -> NSMutableDictionary{
        var Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        Parsedictionary = Dic
        let ageInt = Int(Dic["age"] as! String)
        let ageNumber = NSNumber(value:ageInt!)

        let weightQuestionInt = Int(Dic["weightQuestion"] as! String)!
        let weightQuestionNumber = NSNumber(value:weightQuestionInt)
        
        let heightQuestionInt = Int(Dic["heightQuestion"]  as! String)!
        let heightQuestionNumber = NSNumber(value:heightQuestionInt)

        Parsedictionary.setObject("com.selfcare.shared.data.DiabetesData", forKey: "@class" as NSCopying)
        Parsedictionary.setObject("", forKey: "latitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "longitude" as NSCopying)
        Parsedictionary.setObject("", forKey: "timeZone" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChangeTime" as NSCopying)
        Parsedictionary.setObject("", forKey: "lastChanegeBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdDate" as NSCopying)
        Parsedictionary.setObject("", forKey: "createdBy" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataVendor" as NSCopying)
        Parsedictionary.setObject("", forKey: "dataSource" as NSCopying)
        Parsedictionary.setObject("", forKey: "versionNo" as NSCopying)
        Parsedictionary.setObject("", forKey: "_class" as NSCopying)
        Parsedictionary.setObject(ageNumber, forKey: "age" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "yyyy-MM-dd hh:mm:ss"), forKey: "measurementDate" as NSCopying)
        Parsedictionary.setObject(10, forKey: "timePeriod" as NSCopying)
        Parsedictionary.setObject(0.0, forKey: "score" as NSCopying)
        Parsedictionary.setObject(weightQuestionNumber, forKey: "weightQuestion" as NSCopying)
        Parsedictionary.setObject(heightQuestionNumber, forKey: "heightQuestion" as NSCopying)
        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        return Parsedictionary
    }
    func subAssessmentDiabetes(Dic : NSMutableDictionary) -> NSMutableDictionary {
        let Parsedictionary : NSMutableDictionary = NSMutableDictionary ()
        let ageInt = Int(Dic["age"] as! String)
        let ageNumber = NSNumber(value:ageInt!)

        let weightQuestionInt = Int(Dic["weightQuestion"] as! String)!
        let weightQuestionNumber = NSNumber(value:weightQuestionInt)
        
        let heightQuestionInt = Int(Dic["heightQuestion"]  as! String)!
        let heightQuestionNumber = NSNumber(value:heightQuestionInt)

        Parsedictionary.setObject(AppManager.sharedInstance.userName(), forKey: "userId" as NSCopying)
        Parsedictionary.setObject(Dic["answeringQuestion"]  as Any, forKey: "answeringQuestion" as NSCopying)
        Parsedictionary.setObject(ageNumber, forKey: "age" as NSCopying)
        Parsedictionary.setObject(Dic["sex"]  as Any, forKey: "sex" as NSCopying)
        Parsedictionary.setObject(Dic["ethnicity"]  as Any, forKey: "ethnicity" as NSCopying)
        Parsedictionary.setObject(Dic["smokingStatus"]  as Any, forKey: "smokingStatus" as NSCopying)
        Parsedictionary.setObject(Dic["familyHistory"]  as Any, forKey: "familyHistory" as NSCopying)
        Parsedictionary.setObject(Dic["diseaseHistory"]  as Any, forKey: "diseaseHistory" as NSCopying)
        Parsedictionary.setObject(Dic["highBpHistory"]  as Any, forKey: "highBpHistory" as NSCopying)
        Parsedictionary.setObject(Dic["steroidQuestion"]  as Any, forKey: "steroidQuestion" as NSCopying)
        Parsedictionary.setObject(weightQuestionNumber, forKey: "weightQuestion" as NSCopying)
        Parsedictionary.setObject(heightQuestionNumber, forKey: "heightQuestion" as NSCopying)
        Parsedictionary.setObject(HelpAppManager.shared().convertMilliSeconds(AppManager.sharedInstance.conertDateToString(Date: NSDate(), formate: "yyyy-MM-dd hh:mm:ss")), forKey: "measurementDate" as NSCopying)
        Parsedictionary.setObject(10, forKey: "timePeriod" as NSCopying)
        Parsedictionary.setObject(0.0, forKey: "score" as NSCopying)
        return Parsedictionary
    }
    func selectArrayType(type: NSString)-> NSMutableArray{
        var arrayOfItem : NSMutableArray = []
        if(type.isEqual(to: "Whos")) {
            arrayOfItem =  HelpAppManager.shared().whoAnsweringarray()
        }
        else if(type.isEqual(to: "YesNo")) {
            arrayOfItem =  HelpAppManager.shared().yesNoAnsweringarray()
        }
        else if(type.isEqual(to: "gender")) {
            arrayOfItem =  HelpAppManager.shared().genderarray()
        }
        else if(type.isEqual(to: "ethnicity")) {
            arrayOfItem =  HelpAppManager.shared().ethnicityarray()
        }
        else if(type.isEqual(to: "smoking")) {
            arrayOfItem =  HelpAppManager.shared().smokingarray()
        }
        else if(type.isEqual(to: "number")) {
            arrayOfItem =  HelpAppManager.shared().numberarray()
        }
        else if(type.isEqual(to: "answeringQuestionarray")) {
            arrayOfItem =  HelpAppManager.shared().answeringQuestionarray()
        }

        return arrayOfItem
    }
    func convertNumber(answerString : NSString)-> NSNumber {
        let targetCaloriesBurnInt = Int(answerString as String )
        let targetCaloriesBurnNumber = NSNumber(value:targetCaloriesBurnInt!)
        return targetCaloriesBurnNumber
    }
    func assessmentStartFlag() -> String {
        var assessmentFlag: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "assessmentStartFlag") != nil) && (defaults.object(forKey: "assessmentStartFlag") as! NSObject != NSNull())){
            assessmentFlag = defaults.object(forKey: "assessmentStartFlag") as! String
        }
        return assessmentFlag
    }
    func obesityStartFlag() -> String {
        var obesityFlag: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "obesityStartFlag") != nil) && (defaults.object(forKey: "obesityStartFlag") as! NSObject != NSNull())){
            obesityFlag = defaults.object(forKey: "obesityStartFlag") as! String
        }
        return obesityFlag
    }
    func diabetesQuestionFlag() -> String {
        var diabetesFlag: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "diabetesQuestionFlag") != nil) && (defaults.object(forKey: "diabetesQuestionFlag") as! NSObject != NSNull())){
            diabetesFlag = defaults.object(forKey: "diabetesQuestionFlag") as! String
        }
        return diabetesFlag
    }
    func MonitoringStartFlag() -> String {
        var MonitoringFlag: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "MonitoringStartFlag") != nil) && (defaults.object(forKey: "MonitoringStartFlag") as! NSObject != NSNull())){
            MonitoringFlag = defaults.object(forKey: "MonitoringStartFlag") as! String
        }
        return MonitoringFlag
    }
    func appVersion() -> String {
        var StringAppVersion: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "appVersion") != nil) && (defaults.object(forKey: "appVersion") as! NSObject != NSNull())){
            StringAppVersion = defaults.object(forKey: "appVersion") as! String
        }
        return StringAppVersion
    }
    func referralCode() -> String {
        var stringReferralCode: String = ""
        let defaults: UserDefaults = UserDefaults.standard
        if ((defaults.object(forKey: "referralCode") != nil) && (defaults.object(forKey: "referralCode") as! NSObject != NSNull())){
            stringReferralCode = defaults.object(forKey: "referralCode") as! String
        }
        return stringReferralCode
    }
    func checkStringValue(value : NSString) -> String {
        let stringValue : String = "0"
        if(value.isEqual(to: "")){
            return stringValue
        }
        return value as String
    }
}
