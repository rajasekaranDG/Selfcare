//
//  KConstants.swift
//  Testing
//
//  Created by SivaChandran on 04/03/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Foundation


//let kAPIDOMAIN = "http://cprod.ahahealth.io:12200/rest-scphr/public/v1.0/scphr/"
let kAPIDOMAIN = UserDefaults.standard.value(forKey: kBaseUrl) as! String
//let kAPIDOMAIN = "http://us.ahahealth.io:12200/rest-scphr/public/v1.0/scphr/"
let kAES128_Encryption_Key = "NLP$#SMLPO36!~MN"
let kAES128_Encryption_IV = "XZAQ@PGDSA36~~GS"
let firebasePlistFileName = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")// "GoogleService-Info"

let KInternetAlretTitle = ""
let KInternetAlretMessage = "Please check your internet connection and try again"

let kTimelineLimit = 10
let kUser = "User"
let kUserLoggedIn  = "AHA_isLoggedIn"
let kAddData = "AddData"
let kAddDataIn  = "AHA_isAddDataIn"
let kPushToken = "PushToken"
let kAppDeviceID = "RAppDeviceID"
let kHomeCountry = "home_country"
let kCountryName = "country_name"
let kCountryCode = "country_code"
let kBaseUrl = "baseurl"

let kFontSanFrancisco = "SanFranciscoText-Regular"
let kFontSanFranciscoBold = "SanFranciscoText-Bold"
let kFontSanFranciscoMedium = "SanFranciscoText-Medium"
let kFontSanFranciscoSemibold = "SanFranciscoText-Semibold"
let kFontSanFranciscoThin = "SanFranciscoText-Thin"

let kErrorMessage = "Please check your internet connection and try again"

/* Check is iphone 5 or not */

let iPhone4 = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 480)
let iPhone5 = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 568)
let iPhone6 = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 667)
let iPhone6Pluse = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 736)

