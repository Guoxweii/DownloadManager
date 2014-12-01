//
//  DownloadViewCell.swift
//  DownloadManager
//
//  Created by gxw on 14/11/29.
//  Copyright (c) 2014年 b-star. All rights reserved.
//

import UIKit

class DownloadViewCell: UITableViewCell {
    
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var downloadProgress: UIProgressView!
    
    var operation: AFDownloadRequestOperation!
    var task: Task!
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    
    @IBAction func download(sender: AnyObject) {
        println(DownloadManager.sharedInstance.tasks)
        if operation.isPaused() {
            operation.resume()
        } else {
            operation.start()
        }
    }
    
    func configureDownloadInteractive() {
        var fetcher = Task.lazyFetcher().limit(1).whereField("url", equalToValue: urlLabel.text)
        task = fetcher.fetchRecords().first as Task
        
        if (DownloadManager.sharedInstance.tasks[urlLabel.text!] == nil) {
            var url = NSURL(string: urlLabel.text!)
            if (url == nil) {
                return
            }
            
            var filename = url!.lastPathComponent
            var path = documentsPath.stringByAppendingPathComponent(filename)
            
            var request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 7200)
            operation = AFDownloadRequestOperation(request: request, targetPath: path, shouldResume: true)
            DownloadManager.sharedInstance.tasks[urlLabel.text!] = operation
        } else {
            operation = DownloadManager.sharedInstance.tasks[urlLabel.text!]!
        }
        
        operation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
            self.task.progress = 100
            self.task.setValue(100, forKey: "progress")
            if !self.task.update() {
                println(self.task.errors())
            }
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            self.task.setValue(0, forKey: "progress")
            self.task.update()
            println(error)
        })
        
        operation.setProgressiveDownloadProgressBlock { (operation: AFDownloadRequestOperation!, bytesRead: Int, totalBytesRead: Int64, totalBytesExpected: Int64, totalBytesReadForFile: Int64, totalBytesExpectedToReadForFile: Int64) -> Void in
            var currentBytes = NSNumber(longLong: totalBytesReadForFile)
            var totalBytes = NSNumber(longLong: totalBytesExpectedToReadForFile)
            
            var progress =  currentBytes.doubleValue / totalBytes.doubleValue
            self.downloadProgress.progress = Float(progress)
            
            self.saveProgress()
            
            println(progress)
        }
    }
    
    @IBAction func pause(sender: AnyObject) {
        if (operation != nil) {
            operation.pause()
        }
    }
    
    func saveProgress() {
        var progress = downloadProgress.progress
        
        if (Int(progress * 100) - task.progress.integerValue < 1) {
            return
        }
        
        self.task.setValue(Int(progress * 100), forKey: "progress")
        if !self.task.update() {
            println(self.task.errors())
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
