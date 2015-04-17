//
//  FeedTableViewController.swift
//  SagraPadovana
//
//  Created by Romesh Singhabahu on 11/04/15.
//  Copyright (c) 2015 Romesh Singhabahu. All rights reserved.
//

import UIKit

private let refreshViewHeight: CGFloat = 200

func delayBySeconds(seconds: Double, delayedCode: ()->()) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}

class FeedTableViewController: UITableViewController, MWFeedParserDelegate {
    
    var refreshView: RefreshView!
    var feedItems = [MWFeedItem]()
    
    
    func request(urlString:String?){
        
        if urlString == nil{
            
            let url = NSURL(string: "feed://mattinopadova.gelocal.it/rss/cmlink/rss-mattino-padova-padova-cronaca-1.10289036")
            let feedParser = MWFeedParser(feedURL: url)
            feedParser.delegate = self
            feedParser.parse()
        }else{
            
            let url = NSURL(string: urlString!)
            let feedParser = MWFeedParser(feedURL: url)
            feedParser.delegate = self
            feedParser.parse()
        }
        
        
    }

    
    // MARK : - FEED PARSER DELEGATE
    
    func feedParserDidStart(parser: MWFeedParser!) {
        feedItems = [MWFeedItem]()
        
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    
    // toglie il titolo nella navigation bar
    /*
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        println(info)
        self.title = info.title
    }
    */
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(view.bounds), height: refreshViewHeight), scrollView: tableView)
        refreshView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.insertSubview(refreshView, atIndex: 0)

        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
        
        

    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    // ** FOR APPLE DTS ----> CAN'T IMPLEMENT THIS METHOD GIVES ME ERROR.
    
//    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//    }
//}
//
//extension FeedTableViewController: RefreshViewDelegate {
//    func refreshViewDidRefresh(refreshView: RefreshView) {
//        delayBySeconds(3) {
//            self.refreshView.endRefreshing()
//        }
//    }
//}



    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        request(nil)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Return the number of sections.
        return 1
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return feedItems.count
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.ItemImageView.image = UIImage(named: "placeholder")
        
        let item = feedItems[indexPath.row] as MWFeedItem?
        
        cell.ItemAuthorLabel.text = item?.author
        cell.ItemTitleLabel.text = item?.title
        
        if item?.content != nil {
            let htmlContent = item!.content as NSString
            var imageSource = ""
            let rangeOfString = NSMakeRange(0, htmlContent.length)
            let regex = NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: nil, error: nil)
            
            if htmlContent.length > 0 {
                let match = regex?.firstMatchInString(htmlContent as String, options: nil, range: rangeOfString)
                
                if match != nil {
                    let imageURL = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                    println(imageURL)
                    
                    if NSString (string: imageURL.lowercaseString).rangeOfString("feedburner").location == NSNotFound {
                        imageSource = imageURL as String
                    }
                }
            }
            
            if imageSource != "" {
                cell.ItemImageView.setImageWithURL(NSURL(string: imageSource), placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.ItemImageView.image = UIImage(named: "placeholder")
            }
        }

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = feedItems [indexPath.row] as MWFeedItem
        
        let webBrowser = KINWebBrowserViewController()
        let url = NSURL(string: item.link)
        
        webBrowser.loadURL(url)
        
        
        self.navigationController?.pushViewController(webBrowser, animated: true)
    }
    
}


