//
//  AppDelegate.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 05/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import Alamofire
import Fabric
import Crashlytics
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var SignInVC : SignInViewController!
    var StartMonitoringVC : StartMonitoringViewController!
    var LeftVC : LeftViewController!
    let UserDefaultsDetails = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        guard let options = FirebaseOptions(contentsOfFile: firebasePlistFileName!) else {
            fatalError("Invalid Firebase configuration file.")
        }
        FirebaseApp.configure(options: options)

        Fabric.with([Crashlytics.self])
        self.initSetView()
        return true
    }
    fileprivate func createMenuView() {

        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = StartMonitoringViewController(nibName: "StartMonitoringViewController", bundle: nil)
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        self.LeftVC = leftViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()

    }
    func initSetView() -> Void {
        
        let aStrGetHomeCountry =  UserDefaultsDetails.value(forKey: kCountryName) as? String
        
        if aStrGetHomeCountry == nil {
            
            let aViewController = SelectHomeCountryViewController(nibName: "SelectHomeCountryViewController", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: aViewController)
            navigationController.isNavigationBarHidden = true;
            self.window!.rootViewController = navigationController
        }
        
        else {
            
            if (AppManager.sharedInstance.userName() == "") {
                self.SignInVC = SignInViewController(nibName: "SignInViewController", bundle: nil)
                let navigationController: UINavigationController = UINavigationController(rootViewController: self.SignInVC)
                navigationController.isNavigationBarHidden = true;
                self.window!.rootViewController = navigationController
                
            }else{
                createMenuView();
            }
        }
        
        
    }

    class func appDelegate() -> AppDelegate {
        return (UIApplication.shared.delegate! as? AppDelegate)!
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

