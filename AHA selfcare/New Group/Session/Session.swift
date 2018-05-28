//
//  Session.swift
//  AHA selfcare
//
//  Created by Leo Chelliah on 24/05/18.
//  Copyright © 2018 Sivachandiran. All rights reserved.
//

import UIKit

class Session: NSObject {

    static let sharedInstance: Session = {
        
        let instance = Session()
        
        // setup code
        
        return instance
    }()
    
    // Set and get App Language Name
    func setName(aStrLocName : String) {
        
        UserDefaults.standard.set(aStrLocName, forKey: "country")
        userdefaultsSynchronize()
    }
    
    func getName() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "country") {
            return appLang
        }
        return ""
        
    }
    
    func setUserName(aStrName : String) {
        
        UserDefaults.standard.set(aStrName, forKey: "user_name")
        userdefaultsSynchronize()
    }
    
    func getUserName() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "user_name") {
            return appLang
        }
        return ""
        
    }
    
    
    // MARK: - Private Methods
    
    private func userdefaultsSynchronize() {
        
        UserDefaults.standard.synchronize()
    }
    
}
