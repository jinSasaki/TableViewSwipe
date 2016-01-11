//
//  ViewController.swift
//  TableSwipeTest
//
//  Created by Jin Sasaki on 2015/11/05.
//  Copyright © 2015年 AWA Co.Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var swipeEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = "swipe \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.swipeEnabled = !self.swipeEnabled
        self.tableView.swipeEnabled(self.swipeEnabled, delegate: self)
    }
}

extension ViewController: SwipeDelegate {
    func swipe(direction: SwipeDirection, shouldBeginAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

