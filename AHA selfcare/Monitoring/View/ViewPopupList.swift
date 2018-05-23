//
//  ViewPopupList.swift
//  Harbour
//
//  Created by SivaChandran on 10/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class ViewPopupList: UIView {

    var delegate : AnyObject?
    var arrayOfItems : NSMutableArray = []

    @IBOutlet weak var tblList : UITableView!
    @IBOutlet weak var ViewMain : UIView!
    @IBOutlet weak var lblTitle : UILabel!

    @IBAction func ClosePopupView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.ViewMain.setY(1500)
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
        })
    }
    func UpdateDetailView() {
        self.endEditing(true)
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.ViewMain.setY((self.height() - 450)/2)
        }, completion: {(finished: Bool) -> Void in
        })
        self.ViewMain.layer.cornerRadius = 6.0
        self.tblList.register(UINib(nibName: "CellPopupList", bundle: nil), forCellReuseIdentifier: "CellPopupListID")
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayOfItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return 45;
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellPopupListID", for: indexPath as IndexPath) as! CellPopupList
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        let titleString: NSString = self.arrayOfItems[indexPath.row] as! NSString
        cell.lblTitle.text = titleString as String
        
        cell.lblTitle.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.000)

        cell.BtnSelect.tag = indexPath.row
        cell.BtnSelect.addTarget(self, action: #selector(ViewPopupList.SelectFileClick(sender:)), for: .touchUpInside)
        return cell
    }
    func SelectFileClick(sender : AnyObject) {
        
        let titleString: NSString = self.arrayOfItems[sender.tag] as! NSString
        if(self.delegate is ViewDialogSingle) {
            let viewDialogSingle : ViewDialogSingle = (self.delegate as! ViewDialogSingle)
            viewDialogSingle.updateAnswer(Tag: self.tag, answer: titleString as String)
        }
        self.ClosePopupView("")
    }
}
