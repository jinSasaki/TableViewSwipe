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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        self.tableView.swipeEnabled(true, delegate: self)
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
}

extension ViewController: SwipeDelegate {
    func swipe(direction: SwipeDirection, shouldBeginAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func swipe(direction: SwipeDirection, willBeginAtIndexPath indexPath: NSIndexPath) {
        print("willBeginAtIndexPath: (\(indexPath.section), \(indexPath.row))")
    }
    
    func swipe(direction: SwipeDirection, didBeginAtIndexPath indexPath: NSIndexPath) {
        print("didBeginAtIndexPath: (\(indexPath.section), \(indexPath.row))")
    }
    
    func swipe(direction: SwipeDirection, didSwipeAtIndexPath indexPath: NSIndexPath, rate: CGFloat) {
        print("didSwipeAtIndexPath: (\(indexPath.section), \(indexPath.row)), rate: \(rate)")
    }
    
    func swipe(direction: SwipeDirection, willEndAtIndexPath indexPath: NSIndexPath, active: Bool) {
        print("willEndAtIndexPath: (\(indexPath.section), \(indexPath.row)), active: " + (active ? "true" : "false"))
    }
    
    func swipe(direction: SwipeDirection, didEndAtIndexPath indexPath: NSIndexPath, active: Bool) {
        print("didEndAtIndexPath: (\(indexPath.section), \(indexPath.row)), active: " + (active ? "true" : "false"))
    }
}

