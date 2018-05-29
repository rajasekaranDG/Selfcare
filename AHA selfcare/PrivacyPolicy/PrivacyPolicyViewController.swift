//
//  PrivacyPolicyViewController.swift
//  AHA selfcare
//
//  Created by Leo Chelliah on 29/05/18.
//  Copyright © 2018 Sivachandiran. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController,UIWebViewDelegate {

    var urlString:String = ""
    var titleString:String = ""
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var mainViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        labelTitle.text = titleString
        webView.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
//        do {
//            guard let filePath = Bundle.main.path(forResource: "terms_condition", ofType: "html")
//                else {
//                    // File Error
//                    print ("File reading error")
//                    return
//            }
//
//            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
//            let baseUrl = URL(fileURLWithPath: filePath)
//            webView.loadHTMLString(contents as String, baseURL: baseUrl)
//        }
//        catch {
//            print ("File HTML error")
//        }
        
        let url = URL (string: urlString)
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func menuClick(_ sender : Any) {
        self.slideMenuController()?.toggleLeft()
    }
    
    // MARK: - Webview Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    // MARK:- Button Actions
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
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
