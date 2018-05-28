//
//  ViewInvite.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 05/08/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit
import MessageUI

let INVITETEXT = "Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. Click the link below to download. Wish you a healthy life.\nThanks,\n \(AppManager.sharedInstance.userName()) \n \n https://itunes.apple.com/in/app/aha-health/id1374814041?mt=8"

//As of now no need invite code  lblCode.text!

class ViewInvite: UIView,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
    var delegate : AnyObject?
    
    @IBOutlet weak var lblCode : UILabel!
    
    @IBAction func ShareWhatsApp(_ sender : Any) {
        let shareFinal = NSString(format:"whatsapp://send?text= %@",INVITETEXT)

        /*
          let shareFinal = NSString(format:"whatsapp://send?text=Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. You can get the app free and save Rs365 with this code %@. Click the link below to download. Wish you a healthy life.\nThanks,\n %@",lblCode.text!,AppManager.sharedInstance.userName())
 */
        if let urlString = shareFinal.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                        UIApplication.shared.openURL(whatsappURL as URL)
            }
        }
    }
    @IBAction func ShareEmail(_ sender : Any) {
        if self.delegate is InviteViewController {
            let InviteVC : InviteViewController = (self.delegate as! InviteViewController)
            let Subject = "Aha Health App"
            let controller = MFMailComposeViewController()
            let shareFinal = INVITETEXT
            //NSString(format:"Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. You can get the app free and save Rs365 with this code %@. Click the link below to download. Wish you a healthy life.\nThanks,\n %@",lblCode.text!,AppManager.sharedInstance.userName())
            
            controller.mailComposeDelegate = self
            controller.setSubject(Subject)
            controller.setMessageBody(shareFinal as String, isHTML: false)
            InviteVC.present(controller, animated: true, completion: nil)
        }
        else if self.delegate is RiskViewController {
                let RiskVC : RiskViewController = (self.delegate as! RiskViewController)
                let Subject = "Aha Health App"
                let controller = MFMailComposeViewController()
                let shareFinal = NSString(format:"Hi,\n %@",INVITETEXT)
                controller.mailComposeDelegate = self
                controller.setSubject(Subject)
                controller.setMessageBody(shareFinal as String, isHTML: false)
                RiskVC.present(controller, animated: true, completion: nil)
        }
        else if self.delegate is StartAssessmentViewController {
            let StartAssessmentVC : StartAssessmentViewController = (self.delegate as! StartAssessmentViewController)
            let Subject = "Aha Health App"
            let controller = MFMailComposeViewController()
            let shareFinal = INVITETEXT//NSString(format:"Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. You can get the app free and save Rs365 with this code %@. Click the link below to download. Wish you a healthy life.\nThanks,\n %@",lblCode.text!,AppManager.sharedInstance.userName())
            controller.mailComposeDelegate = self
            controller.setSubject(Subject)
            controller.setMessageBody(shareFinal as String, isHTML: false)
            StartAssessmentVC.present(controller, animated: true, completion: nil)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if self.delegate is InviteViewController {
            let InviteVC : InviteViewController = (self.delegate as! InviteViewController)
            InviteVC.dismiss(animated: true, completion: nil)
        }
        else if self.delegate is RiskViewController {
            let RiskVC : RiskViewController = (self.delegate as! RiskViewController)
            RiskVC.dismiss(animated: true, completion: nil)
        }
        else if self.delegate is StartAssessmentViewController {
            let StartAssessmentVC : StartAssessmentViewController = (self.delegate as! StartAssessmentViewController)
            StartAssessmentVC.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func ShareSMS(_ sender : Any) {
        if self.delegate is InviteViewController {
            let InviteVC : InviteViewController = (self.delegate as! InviteViewController)
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = INVITETEXT//NSString(format:"Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. You can get the app free and save Rs365 with this code %@. Click the link below to download. Wish you a healthy life.\nThanks,\n %@",lblCode.text!,AppManager.sharedInstance.userName()) as String
                controller.messageComposeDelegate = self
                InviteVC.present(controller, animated: true, completion: nil)
            }
        }
        else if self.delegate is RiskViewController {
            let RiskVC : RiskViewController = (self.delegate as! RiskViewController)
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = INVITETEXT//NSString(format:"Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. You can get the app free and save Rs365 with this code %@. Click the link below to download. Wish you a healthy life.\nThanks,\n %@",lblCode.text!,AppManager.sharedInstance.userName()) as String
                controller.messageComposeDelegate = self
                RiskVC.present(controller, animated: true, completion: nil)
            }
        }
        else if self.delegate is StartAssessmentViewController {
            let StartAssessmentVC : StartAssessmentViewController = (self.delegate as! StartAssessmentViewController)
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = INVITETEXT//NSString(format:"Hi,\n I am using Aha Health App to track and monitor my health. I strongly believe you will benefit from it too. You can get the app free and save Rs365 with this code %@. Click the link below to download. Wish you a healthy life.\nThanks,\n %@",lblCode.text!,AppManager.sharedInstance.userName()) as String
                controller.messageComposeDelegate = self
                StartAssessmentVC.present(controller, animated: true, completion: nil)
            }
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if self.delegate is InviteViewController {
            let InviteVC : InviteViewController = (self.delegate as! InviteViewController)
            InviteVC.dismiss(animated: true, completion: nil)
        }
        else if self.delegate is RiskViewController {
            let RiskVC : RiskViewController = (self.delegate as! RiskViewController)
            RiskVC.dismiss(animated: true, completion: nil)
        }
        else if self.delegate is StartAssessmentViewController {
            let StartAssessmentVC : StartAssessmentViewController = (self.delegate as! StartAssessmentViewController)
            StartAssessmentVC.dismiss(animated: true, completion: nil)
        }
    }
}
