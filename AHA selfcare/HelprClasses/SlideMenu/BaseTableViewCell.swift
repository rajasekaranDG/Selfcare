//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//
import UIKit

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 48
    }
    
    open func setData(_ data: Any?) {
        
        if let menuText = data as? Dictionary<String,String> {
            
//            if menuText["Title"] == "New Task" {
//                self.backgroundColor = UIColor(hex: "04B486")
//                self.textLabel?.font = UIFont.helveticaRegularWithSize(size: 14)
//                self.textLabel?.textColor = UIColor(hex: "FFFFFF")
//            }else{
//                self.backgroundColor = UIColor(hex: "230756")
//                self.textLabel?.font = UIFont.helveticaRegularWithSize(size: 14)
//                self.textLabel?.textColor = UIColor(hex: "FFFFFF")
//            }
            self.textLabel?.text = menuText["Title"]
            self.imageView?.image = UIImage(named: menuText["Icon"]!)
//            self.imageView?.image = self.imageView?.image!.withRenderingMode(.alwaysTemplate)
//            self.imageView?.tintColor = UIColor.white
            self.imageView?.contentMode = .center
            self.imageView?.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
//            self.imageView?.clipsToBounds = true;
//            self.imageView?.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.5
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
        
    }
  
}
