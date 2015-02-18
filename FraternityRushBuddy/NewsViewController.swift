//
//  NewsViewController.swift
//  FraternityRushBuddy
//
//  Created by Joseph Carroll on 2/3/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

let isLocalHostTesting = false
let localHostRpcUrl = "http://localhost:8080/_ah/api/rpc?prettyPrint=false"

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    let newsCellIdentifier = "newsCell"
    let noNewsCellIdentifier = "noNewsCell"
    let loadingNewsCellIdentifier = "loadingNewsCell"
    
    var news = [GTLRushnewsRushNews]()
    
    var initialQueryComplete = false
    
    var service : GTLServiceRushnews {
        if (_service != nil) {
            return _service!
        }
        _service = GTLServiceRushnews()
        if isLocalHostTesting {
            _service!.rpcURL = NSURL(string: localHostRpcUrl)
            _service!.fetcherService.allowLocalhostRequest = true
        }
        _service!.retryEnabled = true
        _service!.apiVersion = "v1"
        return _service!
    }
    var _service : GTLServiceRushnews?
    var selectedItem: GTLRushnewsRushNews?
//    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let refreshView = UIView(frame: CGRectMake(0,55,0,0))
//        self.newsTable.insertSubview(refreshView, atIndex: 0)
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "_refreshRushNews", forControlEvents: UIControlEvents.ValueChanged)
//        refreshView.addSubview(refreshControl)
        
        self.newsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        _refreshRushNews()
    }
    
    func _refreshRushNews() {
        _queryForNews(pageToken: nil)
    }
    
    func _queryForNews(pageToken : NSString? = nil) {
        let query = GTLQueryRushnews.queryForRushnewsList() as GTLQueryRushnews
        query.limit = 30
        query.order = "-last_touch_date_time"
        query.pageToken = pageToken
        if pageToken == nil {
            self.news.removeAll(keepCapacity: true)
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query) { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.initialQueryComplete = true
            //self.refreshControl.endRefreshing()
            if error != nil {
                self._showErrorDialog(error!)
            } else {
                let rushNewsCollection = response as GTLRushnewsCollection
                if let newNews = rushNewsCollection.items() as? [GTLRushnewsRushNews] {
                    self.news += newNews
                    if let nextPageToken = rushNewsCollection.nextPageToken {
                        println("Using page token to get more news. count = \(self.news.count)")
                        self._queryForNews(pageToken: nextPageToken)
                    } else {
                        println("Finished getting news. count = \(self.news.count)")
                    }
                } else {
                    println("No news found on backend")
                }
            }
            self.newsTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if news.count == 0 {
            if initialQueryComplete {
                cell = newsTable.dequeueReusableCellWithIdentifier(noNewsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            } else {
                cell = newsTable.dequeueReusableCellWithIdentifier(loadingNewsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
                
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                spinner.startAnimating()
            }
        } else {
            cell = newsTable.dequeueReusableCellWithIdentifier(newsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            let rushNews = news[indexPath.row]
            cell.textLabel?.text = self.news[indexPath.row].title
            cell.detailTextLabel?.text = self.news[indexPath.row].lastTouchDateTime
            selectedItem = self.news[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedItem = self.news[indexPath.row]
        self.performSegueWithIdentifier("showDetails", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as NewsDetailViewController
        detailVC.newsStory = selectedItem
    }
    
    func _showErrorDialog(error: NSError) {
        let alertController = UIAlertController(title: "Endpoints Error", message: error.localizedDescription, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
