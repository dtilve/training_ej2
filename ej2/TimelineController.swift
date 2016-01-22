	//
//  customizedTableViewController.swift
//  ej2
//
//  Created by Dana Tilve on 18/01/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit
import Foundation
import DateTools
import Accounts
import ReactiveCocoa

final class TimelineController: UITableViewController {
    
    private static let cellIdentifier = "TweetCell"
    
    private let viewModel = TimelineViewModel()
    private let refreshCtrl = UIRefreshControl()
    private let controller = DetailedTweetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchTimeline()
        
        viewModel.fetchTimeline.errors.observeNext { self.showAlert($0) }
        viewModel.fetchTimeline.executing.producer.startWithNext { executing in
            if executing {
                print("Fetching timeline")
            } else {
                print("Timeline has been fetched")
            }
        }
        binding()
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueTweetCell(forIndexPath: indexPath)
        cell.bind(viewModel[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tweet = viewModel[indexPath.row]
        let controller = DetailedTweetView()
        controller.fillInWith(tweet)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func fetchTimeline() {
        viewModel.fetchTimeline.apply("").start()

    }
    
    func binding() {
        viewModel.tweets.producer.startWithNext { [unowned self]_ in self.tableView.reloadData()}
    }
    
    func reload (sender: AnyObject){
        viewModel.fetchTimeline.apply("").start()
        refreshCtrl.endRefreshing()
    }
    
    func refresh() {
        refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshCtrl.addTarget(self, action: "reload:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
    }
    
    func showAlert(error : ErrorType) {
        let alertController = UIAlertController(title: "Warning!", message: "Error encountered : \(error)", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
    
private extension TimelineController {

    func dequeueTweetCell(forIndexPath indexPath: NSIndexPath) -> TweetCell {
        return tableView.dequeueReusableCellWithIdentifier(TimelineController.cellIdentifier, forIndexPath: indexPath) as! TweetCell
    }
}



