//
//  ListViewController.swift
//  DownloadManager
//
//  Created by gxw on 14/11/29.
//  Copyright (c) 2014年 b-star. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var tasks = Task.allRecords() as [ Task ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Task.lazyFetcher().fetchRecords().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadCell", forIndexPath: indexPath) as DownloadViewCell
        
        var task = tasks[indexPath.row]

        cell.urlLabel.text = task.url
        cell.downloadProgress.progress = task.progress.floatValue / 100
        
        cell.configureDownloadInteractive()
        cell.listViewController = self

        return cell
    }
}
