//
//  ReadPolicyViewController.swift
//  AHA selfcare
//
//  Created by Dreamguys on 12/04/18.
//  Copyright © 2018 Sivachandiran. All rights reserved.
//

import UIKit

class ReadPolicyViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)

        do {
            guard let filePath = Bundle.main.path(forResource: "terms_condition", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
        // Do any additional setup after loading the view.
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
