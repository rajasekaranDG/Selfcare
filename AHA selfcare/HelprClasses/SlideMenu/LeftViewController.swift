//
//  LeftViewController.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.


import UIKit

enum LeftMenu: Int {
    case DashBoard = 0
//    case Devices
    case Setting
    case Invite
//    case Lab
    case TermsandPolicy
    
    case Logout
}
protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelemail: UILabel!

    var menus = [
            ["Title":"Home","Icon":"home.png"],
//            ["Title":"List of devices","Icon":"listofdevices.png"],
            ["Title":"Settings","Icon":"settings.png"],
            ["Title":"Invite friends & family","Icon":"invite-friends.png"],
//            ["Title":"Lab","Icon":"labs.png"],
            ["Title":"Terms & Policy","Icon":"settings.png"],
            ["Title":"Logout","Icon":"logout.png"]
        ]
    var mainViewController: UIViewController!
    var myProfileViewController: UIViewController!
    var inviteViewController : UIViewController!
    var loginViewcontroller: UIViewController!
    var devicesViewController : UIViewController!
    var labViewController : UIViewController!
    var privacyPolicyController : UIViewController!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func UpdateDetail() {
        let firstName : NSString = AppManager.sharedInstance.userFirstName() as NSString
        if(firstName.isEqual(to: "")){
            self.labelName.text = AppManager.sharedInstance.userName()
        }
        else {
            self.labelName.text = String(format: "%@ %@",AppManager.sharedInstance.userFirstName(),AppManager.sharedInstance.userLastName())
        }
        self.labelemail.text = AppManager.sharedInstance.userMail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UpdateDetail()

        let myProfileViewController = ProfileViewController(nibName : "ProfileViewController" , bundle : nil)
        myProfileViewController.mainViewController = self
        self.myProfileViewController = UINavigationController(rootViewController: myProfileViewController)
        
        let inviteViewController = InviteViewController(nibName : "InviteViewController" , bundle : nil)
        inviteViewController.mainViewController = self
        self.inviteViewController = UINavigationController(rootViewController: inviteViewController)

        let labsViewController = LabsViewController(nibName : "LabsViewController" , bundle : nil)
        labsViewController.mainViewController = self
        self.labViewController = UINavigationController(rootViewController: labsViewController)

        let devicesViewcontroller = DevicesViewController(nibName : "DevicesViewController" , bundle : nil)
        devicesViewcontroller.mainViewController = self
        self.devicesViewController = UINavigationController(rootViewController: devicesViewcontroller)
        
        let loginViewcontroller = SignInViewController(nibName : "SignInViewController" , bundle : nil)
        self.loginViewcontroller = UINavigationController(rootViewController: loginViewcontroller)
        
        let privacypolicyVC = TermsandPolicyViewController(nibName : "TermsandPolicyViewController" , bundle : nil)
        privacypolicyVC.mainViewController = self
        self.privacyPolicyController = UINavigationController(rootViewController: privacypolicyVC)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func profileClick(_ sender : Any) {
    }
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .DashBoard:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
//        case .Devices:
//            self.slideMenuController()?.changeMainViewController(self.devicesViewController, close: true)
        case .Setting:
            self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)
        case .Invite:
            self.slideMenuController()?.changeMainViewController(self.inviteViewController, close: true)
//        case .Lab:
//            self.slideMenuController()?.changeMainViewController(self.labViewController, close: true)
        case .Logout:
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "userage")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "dataOfBirth")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "gender")
            UserDefaults.standard.removeObject(forKey: "height")
            UserDefaults.standard.removeObject(forKey: "weight")
            UserDefaults.standard.removeObject(forKey: "govtId")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "lastname")
            UserDefaults.standard.removeObject(forKey: "country")
            UserDefaults.standard.removeObject(forKey: "city")
            UserDefaults.standard.removeObject(forKey: "state")
            UserDefaults.standard.removeObject(forKey: "postalCode")
            UserDefaults.standard.removeObject(forKey: "mobile")
            UserDefaults.standard.removeObject(forKey: "assessmentStartFlag")
            UserDefaults.standard.removeObject(forKey: "obesityStartFlag")
            UserDefaults.standard.removeObject(forKey: "diabetesQuestionFlag")
            UserDefaults.standard.removeObject(forKey: "MonitoringStartFlag")
            UserDefaults.standard.removeObject(forKey: "referralCode")
            UserDefaults.standard.removeObject(forKey: "appVersion")
            UserDefaults.standard.synchronize()
            self.slideMenuController()?.changeMainViewController(self.loginViewcontroller, close: true)
        case .TermsandPolicy:
            self.slideMenuController()?.changeMainViewController(self.privacyPolicyController, close: true)

     
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .DashBoard, .Setting, .Invite, .Logout :
                return BaseTableViewCell.height()
            case .TermsandPolicy:
                return BaseTableViewCell.height()
           
            }//.Devices //.Lab,
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            
                self.changeViewController(menu)
            
            
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .DashBoard,.Setting,.Invite, .Logout,.TermsandPolicy:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.backgroundColor = UIColor.clear
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}






