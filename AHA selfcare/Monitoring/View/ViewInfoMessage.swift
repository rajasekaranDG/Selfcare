//
//  ViewInfoMessage.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 17/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewInfoMessage: UIView {

    @IBOutlet weak var viewBox:UIView!
    @IBOutlet weak var labelMessage:UILabel!

    var delegate : AnyObject?
    var messageString : NSString = ""
    
    @IBAction func closeView(_ sender : Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBox.transform = CGAffineTransform(scaleX: 0, y: 0)

        }) { (completed) in
            self.removeFromSuperview()
        }
    }
    func updateView() {
        
        self.labelMessage.text = messageString as String

        let constraintNameDes: CGSize = CGSize(width: 295, height: 2000.0)
        let SizeOfName: CGSize = AppManager.sharedInstance.dynamicHeightCalculation(current_constraint: constraintNameDes,
                                                                                    descriptions: self.labelMessage.text!, fontfamily: self.labelMessage.font!)
        self.labelMessage.setHeight(max(SizeOfName.height, 50))
        self.viewBox.setHeight(self.labelMessage.height() + 30)
        self.viewBox.setY(((AppDelegate.appDelegate().window?.height())! - self.viewBox.height())/2)
        self.viewBox.layer.cornerRadius = 6.0
        self.viewBox.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.viewBox.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}
