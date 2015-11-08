//
//  ViewController.swift
//  TableSwipeTest
//
//  Created by Jin Sasaki on 2015/11/05.
//  Copyright © 2015年 AWA Co.Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
        
        self.tableView.swipeEnabled(true, delegate: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = "swipe \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
}

extension ViewController: SwipeDelegate {
    func swipe(direction: SwipeDirection, shouldBeginAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

