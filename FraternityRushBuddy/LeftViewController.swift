//
//  LeftViewController.swift
//  FraternityRushBuddy
//
//  Created by Joseph Carroll on 2/3/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import MessageUI

enum LeftMenu: Int {
    case Main = 0
    case Schedule
    case News
    case Contact
    case Settings
    case Twitter
    case Facebook
    case Instagram
    case Pike
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["ΠKA", "Schedule", "News", "Contact", "Settings", "Twitter", "Facebook", "Instagram", "Pike Website"]
    var mainViewController: UIViewController!
    var scheduleViewController: UIViewController!
    var newsViewController: UIViewController!
    var contactViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let scheduleViewController = storyboard.instantiateViewControllerWithIdentifier("ScheduleViewController") as ScheduleViewController
        self.scheduleViewController = UINavigationController(rootViewController: scheduleViewController)
        
        let newsViewController = storyboard.instantiateViewControllerWithIdentifier("NewsViewController") as NewsViewController
        self.newsViewController = UINavigationController(rootViewController: newsViewController)
        
        let contactViewController = storyboard.instantiateViewControllerWithIdentifier("ContactViewController") as ContactViewController
        self.contactViewController = UINavigationController(rootViewController: contactViewController)
        
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as SettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        //cell.backgroundColor = UIColor(red: 64/255, green: 170/255, blue: 239/255, alpha: 1.0)
        cell.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        //cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Schedule:
            self.slideMenuController()?.changeMainViewController(self.scheduleViewController, close: true)
            break
        case .News:
            self.slideMenuController()?.changeMainViewController(self.newsViewController, close: true)
            break
        case .Contact:
            self.slideMenuController()?.changeMainViewController(self.contactViewController, close: true)            
            break
        case .Settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
            break
        case .Twitter:
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.twitter.com/IotaDeltaPikes")!)
            break
        case .Facebook:
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.facebook.com/Pi.Kappa.Alpha.Iota.Delta")!)
            break
        case .Instagram:
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.instagram.com/iotadeltapikes")!)
            break
        case .Pike:
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.pi-kappa-alpha.net/")!)
            break
        default:
            break
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
