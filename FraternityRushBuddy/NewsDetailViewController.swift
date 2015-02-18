//
//  NewsDetailViewController.swift
//  FraternityRushBuddy
//
//  Created by CSSE Department on 2/17/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsBody: UITextView!
    var newsStory : GTLRushnewsRushNews?
    
    override func viewDidLoad() {
        updateView()
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        backButton.addTarget(self, action:"popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backButtonItem
        super.viewDidLoad()
    }
    
    func popToRoot(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        updateView()
    }
    
    func updateView() {
        newsTitle.text = newsStory?.title
        newsBody.text = newsStory?.body
    }
}
